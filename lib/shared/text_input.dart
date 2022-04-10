import 'package:flutter/material.dart';
import 'package:for_you_flutter/constants/constant_values.dart';

import '../styles/colors_app.dart';

class TextInput extends StatelessWidget {
  TextInput(
      {Key? key,
      required this.controller,
      this.hint,
      this.icon,
      this.validator,
      this.keyboardType,
      this.enabled,
      this.obscureText,
      this.textDirection,
      this.textInputAction})
      : super(key: key);
  final TextEditingController controller;
  final String? hint;
  final IconData? icon;
  final bool? enabled;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ConstantValues.padding * 0.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
          ]),
      child: TextFormField(
        textInputAction: textInputAction ?? TextInputAction.next,
        validator: validator,
        textDirection: textDirection,
        controller: controller,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        enabled: enabled,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(fontStyle: FontStyle.italic,),
          prefixIcon:
              icon == null ? null : Icon(icon, color: ColorsApp.primary),
        ),
      ),
    );
  }
}
