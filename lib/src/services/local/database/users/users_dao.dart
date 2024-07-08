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


  Future<int> patch(
    int id, {
    String? firstName,
    String? lastName,
    String? username,
    String? language,
    bool? isPremium,
    bool? isAuthorized,
    bool? isAdmin,
  }) {
    return db.into(db.users).insertOnConflictUpdate(
          UsersCompanion(
            id: Value(id),
            firstName: Value.absentIfNull(firstName),
            lastName: Value.absentIfNull(lastName),
            username: Value.absentIfNull(username),
            language: Value.absentIfNull(language),
            isPremium: Value.absentIfNull(isPremium),
            isAuthorized: Value.absentIfNull(isAuthorized),
            isAdmin: Value.absentIfNull(isAdmin),
          ),
        );
  }
}
