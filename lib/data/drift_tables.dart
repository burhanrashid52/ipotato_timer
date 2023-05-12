import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_tables.g.dart';

const DATABASE_VERSION = 1;

@DataClassName('TaskTable')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn? get description => text().nullable()();

  IntColumn get duration => integer()();

  IntColumn get elapsedDuration => integer().nullable()();

  IntColumn get startedAt => integer()();
}

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase({
    NativeDatabase? database,
  }) : super(database ?? _openConnection());

  @override
  int get schemaVersion => DATABASE_VERSION;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
