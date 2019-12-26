import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoteDetail extends StatefulWidget {
  final appBarTitle;
  final note;

  NoteDetail(this.appBarTitle, this.note);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NoteDetailState(this.note, this.appBarTitle);
  }
}

class _NoteDetailState extends State<NoteDetail> {
  final appBarTitle;
  final note;
  String generatedPdfFilePath;
  PermissionName permissionName = PermissionName.Internet;
  String message = '';

  _NoteDetailState(this.appBarTitle, this.note);

  @override
  void initState() {
    super.initState();
  }

  Future<void> generateExampleDocument() async {
    var htmlContent = """
    <!DOCTYPE html>
    <html>
    <head>
        <style>
       
        
        h2 {
          color:#F4D03F;
        }
        
         #des {
          color:#34495E;
        }
        
        
         #created {
          color:#34495E;
          padding: 30px 0px 0px 0px;
          text-align: right;
        }
        
         #last_modified {
         color:#34495E;
        
          padding: px 0px 2px 0px;
          text-align: right;
        }
        
         #noteApp {
         color:#34495E;
        
          padding: 0px 0px 20px 0px;
          text-align: right;
        }
        
        
        </style>
      </head>
      <body>
        <h2>${note.title}</h2>

        <p id="des">${note.description}</p>
        <p id="created">${note.created}</p>
        <p id="last_modified">${note.last_modified}</p>
        <p id="noteApp">PDF created by Note App from SNN Systems</p>
    </html>
    """;

    Directory appDocDir = await getExternalStorageDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = "${note.title}";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.appBarTitle),
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  this.note.description,
                  style: TextStyle(letterSpacing: 1.1),
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  'Created: ${note.created}',
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 4),
                child: Text(
                  'Last Modified: ${note.last_modified}',
                  textAlign: TextAlign.end,
                ),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.picture_as_pdf),
        onPressed: () {
          debugPrint('FAB tapped');

          // pdfGenerator(note.title,note.description,note.created,note.last_modified,);
          _showAlertDailogue(context);
        },
        tooltip: 'Add Note',
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  String isNull() {
    if (note.last_modified == null) {
      return '';
    } else {
      return note.last_modified;
    }
  }

  requestPermissions() async {
    List<PermissionName> permissionNames = [];

    permissionNames.add(PermissionName.Storage);

    permissionNames.add(PermissionName.Storage);
    message = '';
    var permissions = await Permission.requestPermissions(permissionNames);
    permissions.forEach((permission) {
      message +=
          '${permission.permissionName}: ${permission.permissionStatus}\n';
    });
    setState(() {
      message;
    });
  }

  _showAlertDailogue(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Export Note as PDF'),
      content: Text(
          'This is an experimental feature!\n\nFor convert note to pdf and save it to phone, App needs storage permission'
          '\n\nPDF will be saved in \'/Android/data/snnsystems.note_app/files/${note.title}.pdf\''),
      actions: <Widget>[
        RaisedButton(
            child: Text(
              'Grant Permission',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
              requestPermissions();
            }),
        RaisedButton(
            child: Text(
              'Make PDF',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
              generateExampleDocument();

              Fluttertoast.showToast(
                  msg: 'PDF created successfully',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 2,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0);
            })
      ],
    );

    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }
}
