enum NoteTableKey {
  id, title, info, user_id
}
class Note {
  late int id;
  late String title;
  late String info;
  late int userId;

  static const tableName = 'notes';

  Note();

  Note.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap[NoteTableKey.id.name];
    title = rowMap[NoteTableKey.title.name];
    info = rowMap[NoteTableKey.info.name];
    userId = rowMap[NoteTableKey.user_id.name];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map[NoteTableKey.title.name] = title;
    map[NoteTableKey.info.name] = info;
    map[NoteTableKey.user_id.name] = userId;
    return map;
  }
}