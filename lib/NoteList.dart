import 'package:flutter/material.dart';
import 'package:note_app/NoteDetail.dart';
import 'package:note_app/NoteEdit.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/utils/breathePage.dart';
import 'package:note_app/utils/datebase_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/utils/theme_changer.dart';
import 'package:permission/permission.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    // TODO: implement createState
    return _NoteListState();
  }
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  PermissionName permissionName = PermissionName.Internet;
  String message = '';

  @override
  Widget build(BuildContext context) {




    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lightbulb_outline,color: Colors.white,),
            onPressed: () {

              ThemeBuilder.of(context).changeTheme();

            },
          ),
          IconButton(
            icon: Icon(Icons.bubble_chart,color: Colors.white,),
            onPressed: () {

              navigateToBreathe();

            },
          ),

          IconButton(
            icon: Icon(Icons.info,color: Colors.white,),
            onPressed: () {

              _showAboutInfo(context);

            },
          )


        ],
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add),
        onPressed: () {
          debugPrint('FAB tapped');

          navigateToEdit(
              Note(
                '',
                '',
                2,
              ),
              'Add Note');
        },
        tooltip: 'Add Note',
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titlestyle = Theme.of(context).textTheme.title;


    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          //color: Colors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: SizedBox(
              height: 100,
              child: ListTile(
                leading: CircleAvatar(
                    backgroundColor:
                        getPriorityColor(noteList[position].priority),
                    child: getPriorityIcon(noteList[position].priority)),
                title: Text(
                  noteList[position].title,
                  style: titlestyle,
                ),
                subtitle: Text(noteList[position].description,
                    overflow: TextOverflow.ellipsis, maxLines: 3),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.grey,
                  onPressed: () {
                    navigateToEdit(this.noteList[position], 'Edit Note');
                  },
                ),
                onTap: () {
                  debugPrint('ListView tapped');

                  navigateToDetail(
                      this.noteList[position], this.noteList[position].title);
                },
              )),
        );
      },
    );
  }

  void navigateToEdit(Note note, String title) async {
    bool result = true;
    result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteEdit(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;

      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.arrow_forward_ios);
        break;

      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  _deleteNote(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackbar(context, 'Note Deleted Successfully');
      //TODO update list view
      updateListView();
    }
  }

  _showSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.intializeDatabse();

    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void navigateToDetail(Note note, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
  }

  requestPermissions() async {
    List<PermissionName> permissionNames = [];

    permissionNames.add(PermissionName.Storage);


    permissionNames.add(PermissionName.Storage);
    message = '';
    var permissions = await Permission.requestPermissions(permissionNames);
    permissions.forEach((permission) {
      message += '${permission.permissionName}: ${permission.permissionStatus}\n';
    });
    setState(() {
      message;
    });
  }

  _showAlertDailogue(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Storage Permission'),
      content: Text('For convert note to pdf and save it to phone,\n App needs storage permission'),
      actions: <Widget>[

        RaisedButton(

          child: Text('Grant Permission'),
          //onPressed: requestPermissions,


        )

      ],
    );

    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  _showAboutInfo(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Note App'),
      content: Text('By SNN Systems\n\nUse Note icon from Icons8'),

    );

    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }






  void navigateToBreathe()  {
   Navigator.push(context, MaterialPageRoute(builder: (context) {
      return breathePage();
    }));


  }

}
