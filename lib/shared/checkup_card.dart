import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:for_you_flutter/data/providers/checkup_manager.dart';
import 'package:for_you_flutter/data/providers/questionnaires_manager.dart';
import 'package:for_you_flutter/shared/components.dart';
import 'package:for_you_flutter/shared/text_input.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constant_values.dart';
import '../data/models/checkup.dart';
import '../styles/colors_app.dart';
import 'dropdown_input.dart';

class CheckupCard extends StatefulWidget {
  const CheckupCard({Key? key, required this.checkup}) : super(key: key);
  final Checkup checkup;

  @override
  State<CheckupCard> createState() => _CheckupCardState();
}

class _CheckupCardState extends State<CheckupCard> {
  File? file;
  DateTime? selectedDate;

  Future<bool> showSelectDialog(
      {Function? selectFile, required bool oneButton,String? text}) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: StatefulBuilder(
                builder: (context, setStateChild) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Components.MainButton(
                        onTap: () async {
                          if (selectFile != null) await selectFile();
                          setStateChild(() {});
                        },
                        children: [
                          Icon(
                            Icons.file_copy,
                            color: ColorsApp.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Text(
                              text??(file == null
                                  ? "select-file".tr()
                                  : "${file!.path.split("/").last}"),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: ColorsApp.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                    Components.MainButton(
                        onTap: () async {
                        if(text==null)  {
                            final DateTime? selected = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2025),
                            );
                            if (selected != null)
                              setStateChild(() {
                                selectedDate = selected;
                              });
                          }
                        },
                        children: [
                          Icon(
                            Icons.date_range,
                            color: ColorsApp.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            selectedDate?.year == null
                                ? "select-date".tr()
                                : "${selectedDate?.year}/${selectedDate?.month}/${selectedDate?.day}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: ColorsApp.white),
                          ),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        if (!oneButton)
                          TextButton(
                            child: Text(
                              "yes".tr(),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            onPressed: () {
                              if (file != null && selectedDate != null)
                                Navigator.pop(context, true);
                            },
                          ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            oneButton ? "cancel".tr() : "no".tr(),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: double.infinity,
      padding: EdgeInsets.all(ConstantValues.padding),
      margin: EdgeInsets.only(top: ConstantValues.padding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: ColorsApp.white,
          boxShadow: [
            BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
            widget.checkup.name,
            style: Theme.of(context).textTheme.headline1,
          )),
          Expanded(
              child: Row(
            children: [
              // for(int i=0;i<widget.checkup.numberAttach;i++)
              Flexible(
                  flex: 2,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.only(end: ConstantValues.padding),
                    child: InkWell(
                        onTap: () async {
                          showSelectDialog(
                                  selectFile: () async {
                                    await Components.selectFile(
                                            allowedExtensions: ["pdf"])
                                        .then((value) {
                                      if (value != null) {
                                        file = value;
                                      } else {}
                                    });
                                  },
                                  oneButton: false)
                              .then((value) {
                            if (value) {
                              if (file != null && selectedDate != null) {
                                if (widget.checkup.checkupAttach.length ==
                                    widget.checkup.numberAttach)
                                  widget.checkup.checkupAttach.removeAt(
                                      widget.checkup.numberAttach - 1);
                                if (widget.checkup.checkupAttach
                                    .contains(file!.path)) return;
                                widget.checkup.checkupAttach.insert(
                                    0,
                                    FileAndDate(
                                        file: file!.path,
                                        dateTime: selectedDate!));
                                Provider.of<CheckupManager>(context,
                                        listen: false)
                                    .updateItem(widget.checkup);
                                setState(() {});
                              }
                            }
                            file = null;
                            selectedDate = null;
                          });
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.add),
                          radius: 30,
                        )),
                  )),

              for (FileAndDate item in widget.checkup.checkupAttach)
                Flexible(
                    child: TextButton(
                        onPressed: () async {
                          selectedDate=item.dateTime;
                          showSelectDialog(
                            text: "open".tr(),
                              selectFile: () async {
                                await File(item.file).exists()
                                    ? await OpenFile.open(item.file)
                                    : Components.launchUrl(item.file);
                              },
                              oneButton: true).whenComplete((){
                            file = null;
                            selectedDate = null;

                          });
                        },
                        child: Text(
                          "${widget.checkup.checkupAttach.indexOf(item) + 1}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(decoration: TextDecoration.underline),
                        )))
            ],
          ))
        ],
      ),
    );
  }
}
