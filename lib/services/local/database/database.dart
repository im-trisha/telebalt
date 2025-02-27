import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:telebalt/consts.dart';
import 'package:televerse/televerse.dart';
import 'misc.dart';

part 'chats/chats_dao.dart';
part 'chats/chats_table.dart';
part 'media/media_dao.dart';
part 'media/media_table.dart';
part 'users/users_dao.dart';
part 'users/users_table.dart';
part 'database.g.dart';

LazyDatabase _openConnection(String dbPath) {
  return LazyDatabase(() async {
    final dbFolder = Directory(dbPath)..createSync(recursive: true);
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [CachedMedia, Users])
class Database extends _$Database {
  final int adminId;
  Database(String dbPath, this.adminId) : super(_openConnection(dbPath));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();

        await into(users).insert(
          UsersCompanion(
            id: Value(adminId),
            firstName: Value('admin'),
            isAdmin: Value(true),
            isAuthorized: Value(true),
          ),
        );
      },
    );
  }
}
