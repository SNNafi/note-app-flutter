class Note {
  int _id;
  String _title;
  String _description;
  String _created;
  String _last_modified;
  int _priority;

  Note(this._title, this._created, this._priority, [this._description, this._last_modified]);

  Note.withID(this._id, this._title, this._created, this._priority,
      [this._description, this._last_modified]);

  int get id => _id;

  String get title => _title;

  String get created => _created;

  String get last_modified => _last_modified;

  int get priority => _priority;

  String get description => _description;

  set title(String newTitle) {
    if (newTitle.length < 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {

      _description = newDescription;

  }

  set created(String newCreated) {
    _created = newCreated;
  }

  set last_modified(String newLastModified) {
    _last_modified = newLastModified;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['created'] = _created;
    map['last_modified'] = _last_modified;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map){

    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _created = map['created'];
    _last_modified = map['last_modified'];



  }


}
