import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../extension/translation_extension.dart';
import '../../../utils/helper/spin_loader.dart';
import '../../../utils/snackbar/snackbar_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String? title;

  const WebViewScreen({super.key, required this.paymentUrl, this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final WebViewController _controller = WebViewController();
  bool _isLoading = true;
  bool _redirectProcessed = false;

  @override
  void initState() {
    super.initState();

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null || uri.scheme != 'https') {
              ToastService.showError(
                'webView.blockedInsecureNavigation'.trns(),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });

            if (url.contains('/success')) {
              await _handleSuccessResponse();
            } else if (url.contains('/cancel')) {
              await _handleCancelResponse();
            }
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
            });
            ToastService.showError(
              '${'webView.error'.trns()}: ${error.description}',
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  Future<void> _handleSuccessResponse() async {
    try {
      String jsonResponse =
          await _controller.runJavaScriptReturningResult(
                "document.body.innerText",
              )
              as String;

      // Clean up the response
      jsonResponse = jsonResponse.trim();

      // Remove extra quotes if present
      if (jsonResponse.startsWith('"') && jsonResponse.endsWith('"')) {
        jsonResponse = jsonResponse.substring(1, jsonResponse.length - 1);
      }

      // Replace escaped quotes
      jsonResponse = jsonResponse.replaceAll(r'\"', '"');

      if (jsonResponse.isEmpty) {
        throw Exception('Empty response from server');
      }

      final decoded = jsonDecode(jsonResponse);

      // Check if status exists and is boolean
      if (decoded.containsKey('status')) {
        final status = decoded['status'];

        if (!_redirectProcessed) {
          _redirectProcessed = true;

          if (status == true || status == 'true') {
            Get.back(
              result: {
                'status': true,
                'data': decoded,
                'message':
                    decoded['message'] ?? 'addMoney.paymentSuccess'.trns(),
              },
            );
            ToastService.showSuccess(
              decoded['message']?.toString() ??
                  'addMoney.paymentSuccess'.trns(),
            );
          } else {
            Get.back(
              result: {
                'success': false,
                'message':
                    decoded['message'] ?? 'addMoney.paymentFailed'.trns(),
              },
            );
            ToastService.showError(
              decoded['message']?.toString() ?? 'addMoney.paymentFailed'.trns(),
            );
          }
        }
      } else {
        // If no status field, check for success field
        final success = decoded['success'];
        if (!_redirectProcessed) {
          _redirectProcessed = true;
          if (success == true || success == 'success' || success == 'true') {
            Get.back(
              result: {
                'status': true,
                'data': decoded,
                'message':
                    decoded['message'] ?? 'addMoney.paymentSuccess'.trns(),
              },
            );
            ToastService.showSuccess(
              decoded['message']?.toString() ??
                  'addMoney.paymentSuccess'.trns(),
            );
          } else {
            Get.back(
              result: {
                'success': false,
                'message':
                    decoded['message'] ?? 'addMoney.paymentFailed'.trns(),
              },
            );
            ToastService.showError(
              decoded['message']?.toString() ?? 'addMoney.paymentFailed'.trns(),
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing success response: $e');
      }
      if (!_redirectProcessed) {
        _redirectProcessed = true;
        Get.back(
          result: {'status': false, 'error': 'Failed to parse response: $e'},
        );
        ToastService.showError('addMoney.paymentError'.trns());
      }
    }
  }

  Future<void> _handleCancelResponse() async {
    try {
      String jsonResponse =
          await _controller.runJavaScriptReturningResult(
                "document.body.innerText",
              )
              as String;

      // Clean up the response
      jsonResponse = jsonResponse.trim();

      if (jsonResponse.startsWith('"') && jsonResponse.endsWith('"')) {
        jsonResponse = jsonResponse.substring(1, jsonResponse.length - 1);
      }

      jsonResponse = jsonResponse.replaceAll(r'\"', '"');

      // Debug: Print the response
      if (jsonResponse.isEmpty) {
        throw Exception('Empty response from server');
      }

      final decoded = jsonDecode(jsonResponse);

      if (!_redirectProcessed) {
        _redirectProcessed = true;

        // Check multiple possible status fields
        final success = decoded['success']?.toString().toLowerCase();
        final status = decoded['status']?.toString().toLowerCase();

        if (success == 'failed' || status == 'false') {
          Get.back(
            result: {
              'status': false,
              'message':
                  decoded['message']?.toString() ??
                  'addMoney.paymentCancel'.trns(),
            },
          );
          ToastService.showError(
            decoded['message']?.toString() ?? 'addMoney.paymentCancel'.trns(),
          );
        } else {
          Get.back(
            result: {
              'status': false,
              'message': 'addMoney.paymentCancelUser'.trns(),
            },
          );
          ToastService.showError('addMoney.paymentCancel'.trns());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing cancel response: $e');
      }
      if (!_redirectProcessed) {
        _redirectProcessed = true;
        Get.back(
          result: {
            'status': false,
            'message': 'addMoney.paymentCancelUser'.trns(),
          },
        );
        ToastService.showError('addMoney.paymentCancel'.trns());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (!_redirectProcessed) {
            _redirectProcessed = true;
            Get.back(
              result: {
                'status': false,
                'message': 'addMoney.paymentCancelUser'.trns(),
              },
            );
            ToastService.showError('addMoney.paymentCancel'.trns());
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? 'deposit.payment'.trns()),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.title != null
                ? () => Get.back()
                : () {
                    if (!_redirectProcessed) {
                      _redirectProcessed = true;
                      Get.back(
                        result: {
                          'status': false,
                          'message': 'addMoney.paymentCancelUser'.trns(),
                        },
                      );
                      ToastService.showError('addMoney.paymentCancel'.trns());
                    }
                  },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) SpinLoader.loader(),
          ],
        ),
      ),
    );
  }
}
