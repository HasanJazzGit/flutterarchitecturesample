import 'package:drift/drift.dart';

/// Products table for offline preference
///
/// This table stores product data for offline support.
/// Located in feature's database/tables folder for better modularity.
class Products extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  RealColumn get price => real()();
  RealColumn get discountPercentage => real()();
  RealColumn get rating => real()();
  IntColumn get stock => integer()();
  TextColumn get tags => text()(); // JSON string
  TextColumn get brand => text().nullable()();
  TextColumn get sku => text()();
  TextColumn get thumbnail => text()();
  TextColumn get images => text()(); // JSON string
  IntColumn get createdAt => integer()(); // Timestamp

  @override
  Set<Column> get primaryKey => {id};
}
