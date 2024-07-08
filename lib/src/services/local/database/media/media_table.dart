part of '../database.dart';

@DataClassName('Media')
class CachedMedia extends Table {
  TextColumn get url => text()();
  TextColumn get videoIds => text().map(const VideoIdsConverter())();
  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {url};
}

// stores preferences as strings
class VideoIdsConverter extends TypeConverter<List<String>, String> {
  const VideoIdsConverter();

  @override
  List<String> fromSql(String fromDb) {
    return (json.decode(fromDb) as List).cast<String>();
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}
