import 'package:app_mock/core/colors';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.errorMessage,
    this.hintText,
    this.labelText,
    this.helperText,
    this.obscureText = false,
    this.onChanged,
    this.inputFormatters,
    this.controller,
    this.icon,
    this.suffixIcon,
    this.suffix,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.onEditingComplete,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.onFieldSubmitted,
    this.scrollPadding = const EdgeInsets.all(20),
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.onTap,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.hintStyle,
  });

  final String? errorMessage;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final Widget? icon;
  final Widget? suffixIcon;
  final Widget? suffix;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function()? onEditingComplete;
  final Function(String?)? onFieldSubmitted;
  final Widget? prefixIcon;
  final bool? enabled;
  final EdgeInsets scrollPadding;
  final int? maxLength;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final Function()? onTap;
  final TextStyle? hintStyle;

  final bool autocorrect;
  final bool enableSuggestions;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          if (enabled != false)
            BoxShadow(
              // color: Colors.grey.withOpacity(0.5),
              color: AppColor.getThemeColor(darkColor.grayBackground,
                  Colors.grey.withOpacity(0.5)), // Cor da sombra
              blurRadius: 5, // Intensidade da sombra
              offset: const Offset(0, 1), // Posição da sombra (x, y)
            )
          else
            BoxShadow(
              color: AppColor.getThemeColor(darkColor.grayBackground,
               Colors.black12), // Cor da sombra
              spreadRadius: 0.1,
            ),
        ],
      ),
      child: TextFormField(
        inputFormatters: inputFormatters,
        validator: validator,
        enabled: enabled,
        style: TextStyle(
          color: enabled != false
              ? const Color(0xFF212121)
              :const Color(0xFF212121),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        onChanged: onChanged,
        obscureText: obscureText,
        controller: controller,
        // Restante das configurações
        decoration: InputDecoration(
          errorMaxLines: 2,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColor.getThemeColor(
              darkColor.grayBackground, lightColor.background),
          hintStyle: hintStyle ??
              TextStyle(
                color: AppColor.getThemeColor(
               Colors.black26, const Color(0xFF212121)),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
          // Restante das configurações
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none, // Sem borda
          ),
        ),
      ),
    );
  }
}
