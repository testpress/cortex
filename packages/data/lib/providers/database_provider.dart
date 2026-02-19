import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../db/app_database.dart';

part 'database_provider.g.dart';

/// Riverpod provider that creates and exposes the singleton [AppDatabase].
/// Uses path_provider to open the SQLite file in the app documents directory.
@Riverpod(keepAlive: true)
Future<AppDatabase> appDatabase(Ref ref) async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'lms.db'));
  final db = AppDatabase(NativeDatabase(file, logStatements: false));

  ref.onDispose(db.close);

  return db;
}
