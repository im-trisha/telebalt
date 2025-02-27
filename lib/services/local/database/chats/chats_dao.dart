part of '../database.dart';

@DriftAccessor(tables: [Chats])
class ChatsDAO extends DatabaseAccessor<Database> with _$ChatsDAOMixin {
  ChatsDAO(super.db);

  Future<List<Chat>> all() => db.select(db.chats).get();

  Future<Chat?> read(int id) {
    final query = db.select(db.chats)..where((tbl) => tbl.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<Chat?> readUsername(String username) {
    final query = db.select(db.chats)
      ..where((tbl) => tbl.username.equals(username.replaceFirst('@', '')));
    return query.getSingleOrNull();
  }

  Future<Chat> insert(
    int id, {
    required DbChatType type,
    String? title,
    String? username,
    String? firstName,
    String? lastName,
    bool? isForum,
    bool? isAuthorized,
  }) {
    return db
        .into(db.chats)
        .insertReturning(
          ChatsCompanion(
            id: Value(id),
            type: Value(type),
            title: Value.absentIfNull(title),
            firstName: Value.absentIfNull(firstName),
            lastName: Value.absentIfNull(lastName),
            username: Value.absentIfNull(username),
            isForum: Value.absentIfNull(isForum),
            isAuthorized: Value.absentIfNull(isAuthorized),
          ),
        );
  }

  Future<void> patch(
    int id, {
    DbChatType? type,
    String? title,
    String? username,
    String? firstName,
    String? lastName,
    bool? isForum,
    bool? isAuthorized,
  }) {
    return (db.update(db.chats)..where((tbl) => tbl.id.equals(id))).write(
      ChatsCompanion(
        type: Value.absentIfNull(type),
        title: Value.absentIfNull(title),
        firstName: Value.absentIfNull(firstName),
        lastName: Value.absentIfNull(lastName),
        username: Value.absentIfNull(username),
        isForum: Value.absentIfNull(isForum),
        isAuthorized: Value.absentIfNull(isAuthorized),
      ),
    );
  }

  Future<int> upsert(
    int id, {
    required DbChatType type,
    String? title,
    String? username,
    String? firstName,
    String? lastName,
    bool? isForum,
    bool? isAuthorized,
  }) async {
    return db
        .into(db.chats)
        .insertOnConflictUpdate(
          ChatsCompanion(
            id: Value(id),
            type: Value(type),
            title: Value.absentIfNull(title),
            firstName: Value.absentIfNull(firstName),
            lastName: Value.absentIfNull(lastName),
            username: Value.absentIfNull(username),
            isForum: Value.absentIfNull(isForum),
            isAuthorized: Value.absentIfNull(isAuthorized),
          ),
        );
  }
}
