import 'package:flutter/material.dart';
import 'package:for_you_flutter/constants/constant_values.dart';

import '../styles/colors_app.dart';

class DropdownInput extends StatefulWidget {
   DropdownInput({Key? key,this.items,this.hint,required this.onChanged}) : super(key: key);
 final List<String>? items;
  final String? hint;
   final ValueChanged<String> onChanged;
  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  final dropdownState = GlobalKey<FormFieldState>();
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
          ]),
      child: DropdownButtonFormField(
        value: selectedValue,
        key: dropdownState,
        isDense: false,
        itemHeight: 55,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle:Theme.of(context).textTheme.bodyText1,
          contentPadding: EdgeInsets.symmetric(horizontal: ConstantValues.padding)
        ),
        alignment: Alignment.center,
        icon: Icon(Icons.keyboard_arrow_down,color: ColorsApp.primary),
        items: widget.items?.map((value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          )).toList(),
        onChanged: (value){
          widget.onChanged(value.toString());
        },
      ),
    );
  }
}
