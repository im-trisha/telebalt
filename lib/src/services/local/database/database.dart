import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:telebalt/src/consts.dart';
import 'misc.dart';

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

        for (final table in allTables) {
          if (table is Timestamps) {
            final name = table.entityName;

            await customStatement('''
            CREATE TRIGGER updated_at_$name AFTER UPDATE ON $name
            BEGIN
              UPDATE $name SET updated_at = CURRENT_TIMESTAMP;
            END;
          ''');
          }
        }

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
