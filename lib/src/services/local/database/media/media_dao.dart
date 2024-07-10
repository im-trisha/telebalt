part of '../database.dart';

@DriftAccessor(tables: [CachedMedia])
class MediaDAO extends DatabaseAccessor<Database> with _$MediaDAOMixin {
  MediaDAO(super.db);

  Future<Media?> read(String url) {
    final query =
        (db.select(db.cachedMedia)..where((tbl) => tbl.url.equals(url)));
    return query.getSingleOrNull();
  }

  Future<Media> create(String url, List<String> videoIds, String name) {
    return db.into(db.cachedMedia).insertReturning(
          CachedMediaCompanion(
            url: Value(url),
            videoIds: Value(videoIds),
            name: Value(name),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
