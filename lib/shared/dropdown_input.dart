import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_you_flutter/constants/constant_values.dart';
import 'package:provider/provider.dart';

import '../data/providers/hospitals_manager.dart';
import '../styles/colors_app.dart';

class DropdownInput extends StatefulWidget {
  DropdownInput(
      {Key? key,
      this.items,
      this.hint,
      this.width,
      this.isCheckBox,
      this.onCheckBox,
      this.selectedValue,
       this.onChanged})
      : super(key: key);
  final List<String>? items;
  final String? hint;
  final String? selectedValue;
  final double? width;
  final bool? isCheckBox;
  final ValueChanged<String>? onChanged;
  final ValueChanged<List<bool>>? onCheckBox;

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  final dropdownState = GlobalKey<FormFieldState>();
  String? selectedValue;
  List<bool> selected = [];

  @override
  void initState() {
    selectedValue=widget.selectedValue;
    for(var item in Provider.of<HospitalManager>(context,listen: false).hospitalList) {
      this.selected.add(item.isChecked);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 55,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
          ]),
      child: widget.isCheckBox ?? false
          ? DropdownButtonFormField<String>(
              validator: (value) {
                if (value == null) {
                  return 'select-validate-value'.tr();
                }
                return null;
              },
              isDense: false,
              itemHeight: 55,
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 15),
              selectedItemBuilder: (context) {
                return widget.items!
                    .map((e) => DropdownMenuItem(
                          child: Container(
                              child: Text(
                            widget.hint ?? '',
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                        ))
                    .toList();
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: ConstantValues.padding)),
              alignment: Alignment.center,
              icon: Icon(Icons.keyboard_arrow_down, color: ColorsApp.primary),
              onChanged: (_) {},
              value: selectedValue,
              items: widget.items!
                  .map((item) => DropdownMenuItem(
                      child: StatefulBuilder(
                        builder: (context, setStateChild) => _SelectRow(
                            onChange: (value) {
                              setStateChild(() {
                                selected[widget.items!.indexOf(item)] = value;
                                // selectedValue = value.toString();
                                widget.onCheckBox!=null?widget.onCheckBox!(selected):null;
                              });

                            },
                            select: selected[widget.items!.indexOf(item)],
                            text: item),
                      ),
                      value: item + selected.length.toString()))
                  .toList(),
            )
          : DropdownButtonFormField(
              value: selectedValue,
              key: dropdownState,
              validator: (value) {
                if (value == null) {
                  return 'select-validate-value'.tr();
                }
                return null;
              },
              isDense: false,
              itemHeight: 55,
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 15),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: ConstantValues.padding)),
              alignment: Alignment.center,
              icon: Icon(Icons.keyboard_arrow_down, color: ColorsApp.primary),
              items: widget.items
                  ?.map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                            width: widget.width,
                            child: FittedBox(
                                fit: BoxFit.scaleDown, child: Text(value))),
                      ))
                  .toList(),
              onChanged: (value) {
                widget.onChanged!(value.toString());
              },
            ),
    );
  }
}

class _SelectRow extends StatefulWidget {
  final Function(bool) onChange;
  final String text;
  final bool select;

  const _SelectRow(
      {Key? key,
      required this.onChange,
      required this.text,
      required this.select})
      : super(key: key);

  @override
  State<_SelectRow> createState() => _SelectRowState();
}

class _SelectRowState extends State<_SelectRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
            value: widget.select,
            onChanged: (x) {
              widget.onChange(x!);
            }),
        SizedBox(
            width: 230,
            child: FittedBox(fit: BoxFit.scaleDown,alignment: AlignmentDirectional.centerStart, child: Text(widget.text,style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 12),))),
      ],
    );
  }
}
