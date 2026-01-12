import 'package:drift/drift.dart';

import '../../../../../core/database/app_database.dart';
import '../tables/app_table.dart';

part 'app_dao.g.dart'; // Required for code generation

@DriftAccessor(tables: [AppTable])
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  AppDao(AppDatabase db) : super(db);

  // Insert a record
  Future<int> insertAppRecord(AppTableCompanion entry) =>
      into(appTable).insert(entry);

  // Get all records
  Future<List<AppTableData>> getAllRecords() => select(appTable).get();

  // Get a single record by id
  Future<AppTableData?> getRecordById(int id) =>
      (select(appTable)..where((tbl) => tbl.intValue.equals(id))).getSingleOrNull();

  // Update a record
  Future<bool> updateRecord(AppTableCompanion entry) =>
      update(appTable).replace(entry);

  // Delete a record
  Future<int> deleteRecord(int id) =>
      (delete(appTable)..where((tbl) => tbl.intValue.equals(id))).go();
}
