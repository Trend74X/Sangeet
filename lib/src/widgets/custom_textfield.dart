import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final Color? cursorColor;
  final Color? filledColor;
  final bool filled;
  final int? maxLines;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final AutovalidateMode? autoValidateMode;
  final bool? enableSuggestions;
  final bool? enableInteractiveSelection;
  final int? errorMaxLines;
  final bool autofocus;

  const CustomTextField({
    super.key,
    this.initialValue,
    this.controller,
    this.labelText,
    this.hintText,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder = const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red, 
        width: 1.0
      ),
    ),
    this.disabledBorder,
    this.cursorColor,
    this.maxLines,
    this.width,
    this.height, 
    this.filledColor, 
    this.filled = false, 
    this.readOnly = false, 
    this.onTap, 
    this.autoValidateMode,
    this.enableSuggestions,
    this.enableInteractiveSelection = true, 
    this.errorMaxLines,
    this.autofocus = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: labelText != null,
          child: Text(
            labelText.toString(),
            // style: labelStyle ?? roboto(13.0, 0.0),
          ),
        ),
        const SizedBox(height: 4.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: SizedBox(
            width: width,
            height: height,
            child: TextFormField(
              enableInteractiveSelection: onTap != null 
                ? false
                : enableInteractiveSelection,
              enableSuggestions: enableSuggestions ?? false,
              onTap: onTap,
              autofocus: autofocus,
              autovalidateMode: autoValidateMode ?? AutovalidateMode.onUserInteraction,
              initialValue: initialValue,
              controller: controller,
              obscureText: obscureText,
              readOnly: readOnly,
              textInputAction: textInputAction,
              keyboardType: keyboardType,
              validator: validator,
              onChanged: onChanged,
              cursorColor: cursorColor,
              maxLines: maxLines,
              decoration: InputDecoration(
                errorMaxLines: errorMaxLines ?? 2,
                // labelText: labelText,
                hintText: hintText,
                // labelStyle: labelStyle,
                hintStyle: hintStyle,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                border: border ?? const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, 
                    width: 1.0
                  ),
                ),
                enabledBorder: border ?? const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, 
                    width: 1.0
                  ),
                ),
                focusedBorder: readOnly 
                  ? InputBorder.none
                  : focusedBorder ?? const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, 
                    width: 1.0
                  ),
                ),
                fillColor: filledColor ?? Colors.grey[900], // (Get.isDarkMode ? textFormFieldColorDark : textFormFieldColorLight),
                filled: true,
                errorBorder: errorBorder,
                focusedErrorBorder: errorBorder,
                disabledBorder: disabledBorder,
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}