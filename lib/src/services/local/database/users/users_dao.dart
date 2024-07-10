part of '../database.dart';

@DriftAccessor(tables: [Users])
class UsersDAO extends DatabaseAccessor<Database> with _$UsersDAOMixin {
  UsersDAO(super.db);

  Future<User?> read(int id) {
    final query = db.select(db.users)..where((tbl) => tbl.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<User?> readUsername(String username) {
    final query = db.select(db.users)
      ..where((tbl) => tbl.username.equals(username.replaceFirst('@', '')));
    return query.getSingleOrNull();
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
  }) async {
    final companion = UsersCompanion(
      id: Value(id),
      firstName: Value.absentIfNull(firstName),
      lastName: Value.absentIfNull(lastName),
      username: Value.absentIfNull(username),
      language: Value.absentIfNull(language),
      isPremium: Value.absentIfNull(isPremium),
      isAuthorized: Value.absentIfNull(isAuthorized),
      isAdmin: Value.absentIfNull(isAdmin),
      friendlyNickname: Value.absentIfNull(friendlyNickname),
    );

    if ((await read(id)) == null) {
      await db.into(db.users).insert(companion);
    } else {
      final query = db.update(db.users)..where((tbl) => tbl.id.equals(id));
      await query.write(companion);
    }
  }
}
