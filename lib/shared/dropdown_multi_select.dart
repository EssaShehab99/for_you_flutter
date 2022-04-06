// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:states_rebuilder/states_rebuilder.dart';
//
// import '../constants/constant_values.dart';
// import '../styles/colors_app.dart';
//
// class _TheState {}
//
// var _theState = RM.inject(() => _TheState());
//
// class _SelectRow extends StatelessWidget {
//   final Function(bool) onChange;
//   final bool selected;
//   final String text;
//
//   const _SelectRow(
//       {Key? key,
//       required this.onChange,
//       required this.selected,
//       required this.text})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Checkbox(
//             value: selected,
//             onChanged: (x) {
//               onChange(x!);
//               _theState.notify();
//             }),
//         SizedBox(
//             width: 240,
//             child: FittedBox(fit: BoxFit.scaleDown, child: Text(text))),
//       ],
//     );
//   }
// }
//
// class DropDownMultiSelect extends StatefulWidget {
//   final List<String> options;
//   final List<String> selectedValues;
//   final Function(List<String>) onChanged;
//   final String? hint;
//   final Widget Function(List<String> selectedValues)? childBuilder;
//
//   const DropDownMultiSelect({
//     Key? key,
//     required this.options,
//     required this.selectedValues,
//     required this.onChanged,
//     this.childBuilder,
//     this.hint,
//   }) : super(key: key);
//
//   @override
//   _DropDownMultiSelectState createState() => _DropDownMultiSelectState();
// }
//
// class _DropDownMultiSelectState extends State<DropDownMultiSelect> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       validator: (value) {
//         if (value == null) {
//           return 'select-validate-value'.tr();
//         }
//         return null;
//       },
//       isDense: false,
//       itemHeight: 55,
//       style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 15),
//       decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: widget.hint,
//           hintStyle: Theme.of(context).textTheme.bodyText1,
//           contentPadding:
//               EdgeInsets.symmetric(horizontal: ConstantValues.padding)),
//       alignment: Alignment.center,
//       icon: Icon(Icons.keyboard_arrow_down, color: ColorsApp.primary),
//       onChanged: (x) {},
//       value: null,
//       items: widget.options
//           .map((x) => DropdownMenuItem(
//                 child: _theState.rebuilder(() => _SelectRow(
//                       selected: widget.selectedValues.contains(x),
//                       text: x,
//                       onChange: (isSelected) {
//                         if (isSelected) {
//                           var ns = widget.selectedValues;
//                           ns.add(x);
//                           widget.onChanged(ns);
//                         } else {
//                           var ns = widget.selectedValues;
//                           ns.remove(x);
//                           widget.onChanged(ns);
//                         }
//                       },
//                     )),
//                 value: x,
//                 onTap: () {
//                   if (widget.selectedValues.contains(x)) {
//                     var ns = widget.selectedValues;
//                     ns.remove(x);
//                     widget.onChanged(ns);
//                   } else {
//                     var ns = widget.selectedValues;
//                     ns.add(x);
//                     widget.onChanged(ns);
//                   }
//                 },
//               ))
//           .toList(),
//     );
//   }
// }
