import 'package:flutter/material.dart';

import '../styles/colors_app.dart';

class TextInput extends StatelessWidget {
   TextInput({Key? key,required this.controller,this.hint,this.icon,this.validator}) : super(key: key);
  final TextEditingController controller;
  final String? hint;
  final IconData? icon;
   final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow:[ BoxShadow(
              color: ColorsApp.shadow,
              blurRadius: 1,
              spreadRadius: 1
          )]
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        validator: validator,
        controller: controller,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          border: InputBorder.none,contentPadding: EdgeInsets.all(10),
          hintText: hint,
          prefixIcon: Icon(icon,color: ColorsApp.primary),
        ),
      ),
    );
  }
}
