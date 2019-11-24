import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/utils/datebase_helper.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoteEdit extends StatefulWidget {
  final appBarTitle;
  final note;

  NoteEdit(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NoteEditState(this.note, this.appBarTitle);
  }
}

class _NoteEditState extends State<NoteEdit> {
  String appBarTitle;
  Note note;
  static var _priorities = ['High', 'Low'];
  var _currentItemSelected = 'Low';
  var _form_key = GlobalKey<FormState>();

  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteEditState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;

    TextStyle textStyle = Theme.of(context).textTheme.title;
    TextStyle descriptionStyle = Theme.of(context).textTheme.body1;
    // TODO: implement build
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(this.appBarTitle),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    moveToLastScreen();
                  })),
          body: Form(
              key: _form_key,
              child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        updatePriorityAsInt(newValueSelected);
                      });
                    },
                    value: getPriorityAsString(note.priority),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: TextFormField(
                    style: textStyle,
                    controller: titleController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Enter Title';
                      }
                    },
                    onChanged: (value) {
                      debugPrint('Changed');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter Note title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: TextFormField(
                    style: descriptionStyle,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: descriptionController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Enter Description';
                      }
                    },
                    onChanged: (value) {
                      debugPrint('Des Changed');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter Note description',
                        labelStyle: descriptionStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 30),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            textColor: Theme.of(context).primaryColorLight,
                            color: Theme.of(context).primaryColorDark,
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if(_form_key.currentState.validate()){

                                  debugPrint('Saved');
                                  _save();

                                }

                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            textColor: Theme.of(context).primaryColorLight,
                            color: Theme.of(context).primaryColorDark,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint('Deleted');
                                _delete();
                              });
                            },
                          ),
                        )
                      ],
                    ))
              ],
            ),
          )),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;

    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }

    return priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    if (note.id != null) {
      note.last_modified = DateFormat.yMMMd().format(DateTime.now());
    } else {
      note.created = DateFormat.yMMMd().format(DateTime.now());
      note.last_modified = DateFormat.yMMMd().format(DateTime.now());
    }
    var result;

    if (note.id != null) {
      result = await databaseHelper.updateNote(note);
    } else {
      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
      if (note.id != null) {
        Fluttertoast.showToast(
            msg: 'Note Edited Succcesfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Note Added Succcesfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      /// _showAlertDailogue('Status', 'Note Saved Succcesfully');

    } else {
      //_showAlertDailogue('Status', 'Problem Saving Note');
      Fluttertoast.showToast(
          msg: 'Problem Saving Note',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _showAlertDailogue(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  _delete() async {
    moveToLastScreen();

    var result;

    if (note.id == null) {
      // _showAlertDailogue('Status', 'There no note to delete');
      Fluttertoast.showToast(
          msg: 'There is no note to delete',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);

      return;
    } else {
      result = await databaseHelper.deleteNote(note.id);
    }

    if (result != null) {
      //_showAlertDailogue('Status', 'Note Deleted succesfully');
      Fluttertoast.showToast(
          msg: 'Note Deleted succesfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      //_showAlertDailogue('Status', 'Error Occured While Deleting Note');
      Fluttertoast.showToast(
          msg: 'Error Occured While Deleting Note',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
