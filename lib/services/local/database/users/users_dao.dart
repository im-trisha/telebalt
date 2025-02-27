part of '../database.dart';

@DriftAccessor(tables: [Users])
class UsersDAO extends DatabaseAccessor<Database> with _$UsersDAOMixin {
  UsersDAO(super.db);

  Future<List<User>> all() => db.select(db.users).get();

  Future<User?> read(int id) {
    final query = db.select(db.users)..where((tbl) => tbl.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<User?> readUsername(String username) {
    final query = db.select(db.users)
      ..where((tbl) => tbl.username.equals(username.replaceFirst('@', '')));
    return query.getSingleOrNull();
  }

  Future<User> insert(
    int id, {
    required String firstName,
    String? lastName,
    String? username,
    String? language,
    bool? isPremium,
    bool? isAuthorized,
    bool? isAdmin,
    String? friendlyNickname,
  }) {
    return db
        .into(db.users)
        .insertReturning(
          UsersCompanion(
            id: Value(id),
            firstName: Value.absentIfNull(firstName),
            lastName: Value.absentIfNull(lastName),
            username: Value.absentIfNull(username),
            language: Value.absentIfNull(language),
            isPremium: Value.absentIfNull(isPremium),
            isAuthorized: Value.absentIfNull(isAuthorized),
            isAdmin: Value.absentIfNull(isAdmin),
            friendlyNickname: Value.absentIfNull(friendlyNickname),
          ),
        );
  }

  Future<void> patch(
    int id, {
    String? firstName,
    String? lastName,
    String? username,
    String? language,
    bool? isPremium,
    bool? isAuthorized,
    bool? isAdmin,
    String? friendlyNickname,
  }) {
    return (db.update(db.users)..where((tbl) => tbl.id.equals(id))).write(
      UsersCompanion(
        firstName: Value.absentIfNull(firstName),
        lastName: Value.absentIfNull(lastName),
        username: Value.absentIfNull(username),
        language: Value.absentIfNull(language),
        isPremium: Value.absentIfNull(isPremium),
        isAuthorized: Value.absentIfNull(isAuthorized),
        isAdmin: Value.absentIfNull(isAdmin),
        friendlyNickname: Value.absentIfNull(friendlyNickname),
      ),
    );
  }

  Future<int> upsert(
    int id, {
    String? firstName,
    String? lastName,
    String? username,
    String? language,
    bool? isPremium,
    bool? isAuthorized,
    bool? isAdmin,
    String? friendlyNickname,
  }) async {
    return db
        .into(db.users)
        .insertOnConflictUpdate(
          UsersCompanion(
            id: Value(id),
            firstName: Value.absentIfNull(firstName),
            lastName: Value.absentIfNull(lastName),
            username: Value.absentIfNull(username),
            language: Value.absentIfNull(language),
            isPremium: Value.absentIfNull(isPremium),
            isAuthorized: Value.absentIfNull(isAuthorized),
            isAdmin: Value.absentIfNull(isAdmin),
            friendlyNickname: Value.absentIfNull(friendlyNickname),
          ),
        );
  }
}
