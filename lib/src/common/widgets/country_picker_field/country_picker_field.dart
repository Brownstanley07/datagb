import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../auth_text_field/auth_text_field.dart';
import '../extension/translation_extension.dart';
import '../../../utils/constants/app_colors.dart';

class CountryPickerField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isRequired;
  final List<String> countries;
  final ValueChanged<String>? onChanged;
  final bool isLoading;

  const CountryPickerField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.isRequired = true,
    required this.countries,
    this.onChanged,
    this.isLoading = false,
  });

  @override
  State<CountryPickerField> createState() => _CountryPickerFieldState();
}

class _CountryPickerFieldState extends State<CountryPickerField> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
    _searchController.addListener(() {
      _filterCountries();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = widget.countries
          .where((country) => country.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "${widget.label} ",
            style: TextStyle(
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            children: [
              widget.isRequired
                  ? const TextSpan(
                      text: "*",
                      style: TextStyle(letterSpacing: 0, color: Colors.red),
                    )
                  : const TextSpan(),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: widget.controller,
          readOnly: true,
          style: TextStyle(color: AppColors.textPrimary),
          onTap: () {
            _searchController.clear();
            _filteredCountries = widget.countries;
            _showCountryPicker(context);
          },
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(letterSpacing: 0, color: AppColors.muted),
            filled: true,
            fillColor: AppColors.textfieldColor,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 6.0).r,
              child: Container(
                margin: const EdgeInsets.all(3).w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: AppColors.primary,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ).r,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20).w,
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20).w,
              borderSide: BorderSide(color: AppColors.border),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20).w,
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20).w,
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  void _showCountryPicker(BuildContext context) {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: Get.height * 0.6,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(24).w,
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 34.w,
                    height: 5.h,
                    margin: const EdgeInsets.all(10).w,
                    decoration: BoxDecoration(
                      color: AppColors.muted.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(10).w,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16).r,
                  child: AuthTextField(
                    label: 'signUp.country'.trns(),
                    hintText: 'signUp.searchCountry'.trns(),
                    labelFontSize: 16.sp,
                    labelFontWeight: FontWeight.w700,
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _filteredCountries = widget.countries
                            .where(
                              (country) => country.toLowerCase().contains(
                                value.toLowerCase(),
                              ),
                            )
                            .toList();
                      });
                    },
                    icon: Icons.search,
                    isRequired: false,
                    validator: null,
                  ),
                ),
                Expanded(
                  child: widget.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: _filteredCountries.length,
                            padding: const EdgeInsets.all(0).r,
                            itemBuilder: (context, index) {
                              final country = _filteredCountries[index];
                              final isSelected =
                                  widget.controller.text == country;
                              return Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  tileColor: isSelected
                                      ? AppColors.primary.withValues(alpha: .1)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10).w,
                                  ),
                                  title: Text(
                                    country,
                                    style: TextStyle(
                                      letterSpacing: 0,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.textPrimary
                                          : AppColors.muted,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onTap: () {
                                    widget.controller.text = country;
                                    widget.onChanged?.call(country);
                                    Get.back();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
