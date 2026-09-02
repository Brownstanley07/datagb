import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import '../../../../backend/secure_api_controller.dart';
import '../model/ticket_message_response_model.dart';
import '../model/ticket_response_model.dart';

class MyTicketController extends GetxController {
  final SecureApiController secureApiController;

  MyTicketController({required this.secureApiController});

  final ScrollController scrollController = ScrollController();
  final ScrollController messageScrollController = ScrollController();
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool loadMessage = false.obs;
  RxString isRead = ''.obs;
  RxList<Ticket> tickets = <Ticket>[].obs;
  int currentPage = 1;
  int lastPage = 1;
  final int perPage = 10;

  final replyController = TextEditingController();
  RxBool isSending = false.obs;
  RxBool isClose = false.obs;

  //
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final RxMap<String, File> pickedFiles = <String, File>{}.obs;
  final RxMap<String, File> pickedReplyFiles = <String, File>{}.obs;
  final Rxn<MessageData> message = Rxn<MessageData>();
  final Rxn<MessageTicket> messageTicket = Rxn<MessageTicket>();

  @override
  void onInit() {
    super.onInit();
    loadTicket();
    scrollController.addListener(_onTicketScroll);
  }

  void _onTicketScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      loadMoreTickets();
    }
  }

  Future<void> loadTicket() async {
    isLoading.value = true;
    currentPage = 1;
    try {
      await _fetchTickets(page: currentPage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTickets() async {
    isLoading.value = true;
    currentPage = 1;
    try {
      await _fetchTickets(page: currentPage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchTickets({required int page}) async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getTicket(
        page: page,
        perPage: perPage,
      );
      if (response.status == true) {
        lastPage = response.meta?.lastPage ?? 1;
        currentPage = response.meta?.currentPage ?? page;
        final loadedTickets = response.data?.tickets ?? [];
        if (page == 1) {
          tickets.assignAll(loadedTickets);
        } else {
          tickets.addAll(loadedTickets);
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error loading tickets: $e\n$stackTrace');
      }
    }
  }

  Future<void> loadMoreTickets() async {
    if (isLoading.value || isLoadMore.value || currentPage >= lastPage) {
      return;
    }

    isLoadMore.value = true;
    try {
      await _fetchTickets(page: currentPage + 1);
    } finally {
      isLoadMore.value = false;
    }
  }

  Future<void> pickFile(String fieldName) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        pickedFiles[fieldName] = File(result.files.single.path!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('File picking error: $e');
      }
    }
  }

  /// Picks a file for the ticket reply.
  Future<void> pickReplyFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final key = 'reply_${DateTime.now().millisecondsSinceEpoch}';
        pickedReplyFiles[key] = file;
      }
    } catch (e) {
      if (kDebugMode) {
        print('File picking error for reply: $e');
      }
    }
  }

  Future<void> submitTicket() async {
    if (!formKey.currentState!.validate()) return;
    isSubmitting.value = true;
    try {
      await secureApiController.ensureInitialized();
      final payload = <String, dynamic>{
        'title': titleController.text,
        'message': descriptionController.text,
      };
      if (pickedFiles.isNotEmpty) {
        payload['attach'] = await MultipartFile.fromFile(
          pickedFiles.values.first.path,
          filename: pickedFiles.values.first.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(payload);
      final response = await secureApiController.api!.createNewTicket(formData);
      if (response.status == true) {
        await loadTicket();
        titleController.clear();
        descriptionController.clear();
        pickedFiles.clear();
        formKey.currentState?.reset();
        Get.back();
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Ticket submission error: $e\n$stackTrace');
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> getMessage(String id) async {
    loadMessage.value = true;
    await _fetchMessage(id);
    loadMessage.value = false;
  }

  Future<void> refreshMessage(String id) async {
    loadMessage.value = true;
    await _fetchMessage(id);
    loadMessage.value = false;
  }

  Future<void> _fetchMessage(String id) async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.ticketMessage(id: id);
      if (response.status == true) {
        message.value = response.data;
        messageTicket.value = response.data?.ticket;
        Future.delayed(const Duration(milliseconds: 80), () {
          if (messageScrollController.hasClients) {
            messageScrollController.animateTo(
              messageScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error loading tickets: $e\n$stackTrace');
      }
    }
  }

  // send reply message
  Future<void> sendReply(String id) async {
    isSending.value = true;
    await secureApiController.ensureInitialized();
    final text = replyController.text.trim();
    if (text.isEmpty) {
      isSending.value = false;
      return;
    }

    try {
      final Map<String, dynamic> payload = {'message': text};
      if (pickedReplyFiles.isNotEmpty) {
        payload['attach'] = await MultipartFile.fromFile(
          pickedReplyFiles.values.first.path,
          filename: pickedReplyFiles.values.first.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(payload);

      final response = await secureApiController.api!.replyTicket(
        id: id,
        payload: formData,
      );
      if (response.status == true) {
        await getMessage(id);

        replyController.clear();
        pickedReplyFiles.clear();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending reply: $e');
      }
    } finally {
      isSending.value = false;
    }
  }

  //mark as complete
  Future<void> markAsCompleted(String id) async {
    isClose.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.markAsComplete(id: id);
      if (response.status == true) {
        await getMessage(id);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending reply: $e');
      }
    } finally {
      isClose.value = false;
    }
  }

  /// Removes a picked file from the list.
  void removeFile(String key) {
    if (pickedReplyFiles.containsKey(key)) {
      pickedReplyFiles.remove(key);
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onTicketScroll);
    scrollController.dispose();
    messageScrollController.dispose();
    replyController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
