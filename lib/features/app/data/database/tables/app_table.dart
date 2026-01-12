import 'package:drift/drift.dart';

import 'package:drift/drift.dart';

class AppTable extends Table {
  // Integer column
  IntColumn get intValue => integer()();

  // Real (double) column
  RealColumn get realValue => real()();

  // Text (string) column
  TextColumn get textValue => text()();

  // Boolean column
  BoolColumn get boolValue => boolean()();

  // DateTime column
  DateTimeColumn get dateValue => dateTime()();

  // Blob (binary data) column
  BlobColumn get blobValue => blob()();

  @override
  Set<Column> get primaryKey => {intValue};
}
