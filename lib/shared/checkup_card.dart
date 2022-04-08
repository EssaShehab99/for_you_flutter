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

import '../constants/constant_values.dart';
import '../data/models/checkup.dart';
import '../styles/colors_app.dart';
import 'dropdown_input.dart';

class CheckupCard extends StatefulWidget {
  const CheckupCard(
      {Key? key, required this.checkup})
      : super(key: key);
  final Checkup checkup;


  @override
  State<CheckupCard> createState() => _CheckupCardState();
}

class _CheckupCardState extends State<CheckupCard> {

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
          Expanded(child: Row(
            children: [
              // for(int i=0;i<widget.checkup.numberAttach;i++)
                Flexible(flex: 2,child: Padding(
                  padding:  EdgeInsetsDirectional.only(end: ConstantValues.padding),
                  child: InkWell(onTap: () {
                    Components.selectFile(allowedExtensions: ["pdf"]).then((value) {
                     setState(() {
                       if(value!=null){
                         if(widget.checkup.checkupAttach.length==widget.checkup.numberAttach)
                           widget.checkup.checkupAttach.removeAt(widget.checkup.numberAttach-1);
                         if(widget.checkup.checkupAttach.contains(value.path))
                           return;
                         widget.checkup.checkupAttach.insert(0, value.path);
                         Provider.of<CheckupManager>(context,listen: false).updateItem(widget.checkup);
                       }else{
                       }
                     });
                    });
                  },child: CircleAvatar(child: Icon(Icons.add),radius: 30,)),
                )),

              for(var item in widget.checkup.checkupAttach)
                Flexible(child: TextButton(onPressed: ()async{
                  await OpenFile.open(item);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           Scaffold(
                  //               body: Container(
                  //                   child: SfPdfViewer.file(
                  //                       File(item),controller: PdfViewerController(),)))
                  //     ));
                }, child: Text("${widget.checkup.checkupAttach.indexOf(item)+1}",style: Theme.of(context).textTheme.bodyText1?.copyWith(decoration: TextDecoration.underline),)))
            ],
          ))
        ],
      ),
    );
  }
}
