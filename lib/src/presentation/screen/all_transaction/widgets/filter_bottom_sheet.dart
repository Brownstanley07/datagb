import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/all_transaction_controller.dart';

const Color _blue = Color(0xFF2452F9);
const Color _muted = Color(0xFF64748B);
const Color _line = Color(0xFFE2E8F0);

class FilterBottomSheet extends GetView<AllTransactionController> {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetColor = colorScheme.surface;
    final fieldColor = isDark
        ? colorScheme.surfaceContainerHighest
        : const Color(0xFFF8FAFC);
    final textColor = colorScheme.onSurface;
    final mutedColor = isDark ? colorScheme.onSurfaceVariant : _muted;
    final lineColor = isDark
        ? colorScheme.outline.withValues(alpha: 0.55)
        : _line;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header handle & title
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Transactions',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.resetFilters(),
                    child: Text(
                      'Reset All',
                      style: TextStyle(
                        color: const Color(0xFFEF4444),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // 1. Transaction Type Dropdown
              Text(
                'Transaction Type',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                final availableValues = controller.systemTransactionTypes
                    .map((type) => type['value'])
                    .toSet();
                final selected = controller.selectedFilterType.value;

                return DropdownButtonFormField<String>(
                  initialValue: availableValues.contains(selected)
                      ? selected
                      : 'all',
                  isExpanded: true,
                  menuMaxHeight: 320.h,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: textColor,
                    size: 22.sp,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    fillColor: fieldColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: lineColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: lineColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: _blue, width: 1.5.w),
                    ),
                  ),
                  items: controller.systemTransactionTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type['value'],
                      child: Text(
                        type['name']!,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  dropdownColor: sheetColor,
                  onChanged: (val) {
                    if (val != null) controller.selectedFilterType.value = val;
                  },
                );
              }),
              SizedBox(height: 18.h),

              // 2. Status Dropdown
              Text(
                'Status',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: controller.selectedStatus.value.isEmpty
                      ? 'all'
                      : controller.selectedStatus.value,
                  isExpanded: true,
                  menuMaxHeight: 280.h,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: textColor,
                    size: 22.sp,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    fillColor: fieldColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: lineColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: lineColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: _blue, width: 1.5.w),
                    ),
                  ),
                  items: controller.systemStatusOptions.map((st) {
                    return DropdownMenuItem<String>(
                      value: st['value'],
                      child: Text(
                        st['name']!,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  dropdownColor: sheetColor,
                  onChanged: (val) {
                    if (val != null) controller.selectedStatus.value = val;
                  },
                ),
              ),
              SizedBox(height: 18.h),

              // 3. Date Selection Field
              Text(
                'Date',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => controller.selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: fieldColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: lineColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: _blue,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Obx(() {
                          final selectedDate = controller.selectedDate.value;
                          return Text(
                            selectedDate == null
                                ? 'Select Date'
                                : controller.dateController.text,
                            style: TextStyle(
                              color: selectedDate == null
                                  ? mutedColor
                                  : textColor,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }),
                      ),
                      Obx(() {
                        final hasDate = controller.selectedDate.value != null;
                        if (hasDate) {
                          return GestureDetector(
                            onTap: controller.clearDate,
                            child: Icon(
                              Icons.cancel_rounded,
                              color: mutedColor,
                              size: 18.sp,
                            ),
                          );
                        }
                        return Icon(
                          Icons.chevron_right_rounded,
                          color: mutedColor,
                          size: 20.sp,
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 26.h),

              // Apply Filter Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => controller.applyFilters(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    'Apply Filter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
