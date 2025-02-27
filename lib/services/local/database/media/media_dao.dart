part of '../database.dart';

@DriftAccessor(tables: [CachedMedia])
class MediaDAO extends DatabaseAccessor<Database> with _$MediaDAOMixin {
  MediaDAO(super.db);

  Future<Media?> read(String url) {
    final query = (db.select(db.cachedMedia)
      ..where((tbl) => tbl.url.equals(url)));
    return query.getSingleOrNull();
  }

  Future<Media> create({
    required String url,
    required List<String> videoIds,
    required List<String> fileIds,
    required bool isPicker,
    required String name,
  }) {
    return db
        .into(db.cachedMedia)
        .insertReturning(
          CachedMediaCompanion(
            url: Value(url),
            videoIds: Value(videoIds),
            name: Value(name),
            fileIds: Value(fileIds),
            isPicker: Value(isPicker),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
