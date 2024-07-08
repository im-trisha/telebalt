part of '../database.dart';

@TableIndex(name: 'usernames', columns: {#username})
@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer()();

  TextColumn get firstName => text()();
  TextColumn get lastName => text().nullable()();
  TextColumn get username => text().nullable()();
  TextColumn get language => text().withDefault(Constant(K.defaultLang))();
  BoolColumn get isPremium => boolean().withDefault(Constant(false))();

  BoolColumn get isAuthorized => boolean().withDefault(Constant(false))();
  BoolColumn get isAdmin => boolean().withDefault(Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
