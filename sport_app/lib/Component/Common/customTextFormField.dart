import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/colorConstant.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final String errorText;

  CustomTextFormField({
    required this.controller,
    required this.hintText,
    required this.textInputAction,
    required this.focusNode,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
      focusNode: focusNode,
      controller: controller,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.fromLTRB(18 * fem, 18 * fem, 18 * fem, 18 * fem),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16 * fem,
          fontWeight: FontWeight.w400,
          height: 1.25 * fem,
          color: kComponentHintTextColor,
        ),
        filled: true,
        fillColor: kMainComponentColor,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kComponentErrorTextColor)),
      ),
      style: TextStyle(color: kMainTitleColor),
    );
  }
}
