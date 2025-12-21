# 🗄️ Drift: Create Table & DAO Guide

Generic guide for creating Drift database tables and DAOs - no project-specific examples.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Folder Structure](#folder-structure)
3. [Step 1: Create Table](#step-1-create-table)
4. [Step 2: Register Table](#step-2-register-table)
5. [Step 3: Generate Code](#step-3-generate-code)
6. [Step 4: Create DAO](#step-4-create-dao)
7. [Step 5: CRUD Operations](#step-5-crud-operations)

---

## 📖 Overview

This guide shows the **generic process** for creating a Drift table and DAO. Replace `TableName` with your actual table name.

---

## 📁 Folder Structure

### Complete Folder Structure

```
lib/
├── core/
│   └── database/
│       ├── app_database.dart          # Main database class
│       ├── app_database.g.dart        # Generated (don't edit)
│       └── DRIFT_TABLE_DAO_GUIDE.md   # This guide
│
└── features/
    └── [your_feature]/
        └── data/
            ├── database/
            │   └── tables/
            │       └── [table_name]_table.dart    # Table definition
            │
            └── dao/
                └── [table_name]_dao.dart         # DAO (Data Access Object)
```

### File Locations

| File Type | Location | Example |
|-----------|----------|---------|
| **Database** | `lib/core/database/` | `app_database.dart` |
| **Table** | `lib/features/[feature]/data/database/tables/` | `[table_name]_table.dart` |
| **DAO** | `lib/features/[feature]/data/dao/` | `[table_name]_dao.dart` |

### Example Structure

If creating a "Users" table for "auth" feature:

```
lib/
├── core/
│   └── database/
│       └── app_database.dart
│
└── features/
    └── auth/
        └── data/
            ├── database/
            │   └── tables/
            │       └── users_table.dart
            │
            └── dao/
                └── users_dao.dart
```

---

## 🏗️ Step 1: Create Table

### File Location

Create: `lib/features/[your_feature]/data/database/tables/[table_name]_table.dart`

### Table Structure

```dart
import 'package:drift/drift.dart';

/// [TableName] table description
class TableName extends Table {
  // Primary key
  IntColumn get id => integer().autoIncrement()();
  
  // Text columns
  TextColumn get name => text()();
  TextColumn get description => text()();
  
  // Nullable text
  TextColumn get optionalField => text().nullable()();
  
  // Numeric columns
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
  
  // Boolean
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  
  // Timestamp
  IntColumn get createdAt => integer()();
  
  // Primary key definition
  @override
  Set<Column> get primaryKey => {id};
}
```

### Column Types

| Type | Syntax |
|------|--------|
| Integer | `IntColumn get fieldName => integer()();` |
| Auto-increment | `IntColumn get id => integer().autoIncrement()();` |
| Text | `TextColumn get fieldName => text()();` |
| Nullable Text | `TextColumn get fieldName => text().nullable()();` |
| Real (Float) | `RealColumn get fieldName => real()();` |
| Boolean | `BoolColumn get fieldName => boolean()();` |
| Boolean with Default | `BoolColumn get fieldName => boolean().withDefault(const Constant(false))();` |
| DateTime | `DateTimeColumn get fieldName => dateTime()();` |
| Blob | `BlobColumn get fieldName => blob()();` |

---

## 📝 Step 2: Register Table

### Edit Database File

Edit: `lib/core/database/app_database.dart`

```dart
import 'package:drift/drift.dart';
// ... other imports

// Import your table
import '../../features/[your_feature]/data/database/tables/[table_name]_table.dart';

part 'app_database.g.dart';

// Add TableName to tables list
@DriftDatabase(tables: [TableName]) // Add your table here
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; // Increment if adding to existing DB

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // If adding to existing database:
        if (from < 2) {
          await m.createTable(database.tableName); // Create new table
        }
      },
    );
  }
}
```

### Important

- **New Database:** Keep `schemaVersion = 1`
- **Existing Database:** Increment `schemaVersion` and add migration

---

## ⚙️ Step 3: Generate Code

Run code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Generated Files

- `app_database.g.dart` - Database implementation
- `TableName` - Data class
- `TableNameCompanion` - For inserts/updates

---

## 📚 Step 4: Create DAO

### File Location

Create: `lib/features/[your_feature]/data/dao/[table_name]_dao.dart`

### DAO Structure

```dart
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';

/// Data Access Object for TableName
@DriftAccessor(tables: [TableName])
class TableNameDao extends DatabaseAccessor<AppDatabase> with _$TableNameDaoMixin {
  TableNameDao(AppDatabase db) : super(db);

  // READ operations
  Future<List<TableNameData>> getAll() {
    return select(tableName).get();
  }

  Future<TableNameData?> getById(int id) {
    return (select(tableName)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<TableNameData>> getByField(String fieldValue) {
    return (select(tableName)
          ..where((t) => t.fieldName.equals(fieldValue)))
          .get();
  }

  // CREATE operation
  Future<int> insert(TableNameCompanion item) {
    return into(tableName).insert(item);
  }

  // UPDATE operation
  Future<bool> update(int id, TableNameCompanion item) {
    return (update(tableName)..where((t) => t.id.equals(id))).write(item);
  }

  // DELETE operation
  Future<int> delete(int id) {
    return (delete(tableName)..where((t) => t.id.equals(id))).go();
  }

  Future<int> deleteAll() {
    return delete(tableName).go();
  }
}
```

### Register DAO

Edit `app_database.dart`:

```dart
@DriftDatabase(tables: [TableName], daos: [TableNameDao])
class AppDatabase extends _$AppDatabase {
  // ...
}
```

### Generate Code Again

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🔍 Step 5: CRUD Operations

### CREATE (Insert)

```dart
// Create Companion
final companion = TableNameCompanion.insert(
  name: 'Item Name',
  description: 'Description',
  optionalField: Value('Optional'), // Value() for nullable
  quantity: 10,
  price: 99.99,
  isActive: const Value(true),
  createdAt: DateTime.now().millisecondsSinceEpoch,
);

// Insert using database
final id = await database.into(database.tableName).insert(companion);

// Or using DAO
final id = await database.tableNameDao.insert(companion);
```

### READ (Select)

```dart
// Get all
final all = await database.select(database.tableName).get();
// Or
final all = await database.tableNameDao.getAll();

// Get by ID
final item = await (database.select(database.tableName)
  ..where((t) => t.id.equals(1)))
  .getSingleOrNull();
// Or
final item = await database.tableNameDao.getById(1);

// Filter
final filtered = await (database.select(database.tableName)
  ..where((t) => t.fieldName.equals('value')))
  .get();

// Order by
final sorted = await (database.select(database.tableName)
  ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
  .get();

// Limit/Offset (Pagination)
final paginated = await (database.select(database.tableName)
  ..limit(10, offset: 20))
  .get();
```

### UPDATE

```dart
// Update single row
await (database.update(database.tableName)
  ..where((t) => t.id.equals(1)))
  .write(TableNameCompanion(
    name: Value('Updated Name'),
    description: Value('Updated Description'),
  ));

// Or using DAO
await database.tableNameDao.update(
  1,
  TableNameCompanion(name: Value('Updated Name')),
);
```

### DELETE

```dart
// Delete single row
await (database.delete(database.tableName)
  ..where((t) => t.id.equals(1)))
  .go();

// Or using DAO
await database.tableNameDao.delete(1);

// Delete all
await database.delete(database.tableName).go();
// Or
await database.tableNameDao.deleteAll();
```

---

## 📋 Quick Reference

### Table Template

```dart
class TableName extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  // Add more columns...
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### DAO Template

```dart
@DriftAccessor(tables: [TableName])
class TableNameDao extends DatabaseAccessor<AppDatabase> with _$TableNameDaoMixin {
  TableNameDao(AppDatabase db) : super(db);
  
  Future<List<TableNameData>> getAll() => select(tableName).get();
  Future<TableNameData?> getById(int id) => /* ... */;
  Future<int> insert(TableNameCompanion item) => into(tableName).insert(item);
  Future<bool> update(int id, TableNameCompanion item) => /* ... */;
  Future<int> delete(int id) => /* ... */;
}
```

### CRUD Template

```dart
// CREATE
final id = await database.tableNameDao.insert(TableNameCompanion.insert(/* ... */));

// READ
final items = await database.tableNameDao.getAll();
final item = await database.tableNameDao.getById(id);

// UPDATE
await database.tableNameDao.update(id, TableNameCompanion(/* ... */));

// DELETE
await database.tableNameDao.delete(id);
```

---

## ✅ Checklist

- [ ] Create table file: `[table_name]_table.dart`
- [ ] Define columns with correct types
- [ ] Set primary key
- [ ] Import table in `app_database.dart`
- [ ] Add to `@DriftDatabase(tables: [TableName])`
- [ ] If existing DB: increment `schemaVersion` and add migration
- [ ] Run `build_runner` to generate code
- [ ] Create DAO file: `[table_name]_dao.dart`
- [ ] Add DAO methods (getAll, getById, insert, update, delete)
- [ ] Register DAO in `@DriftDatabase(daos: [TableNameDao])`
- [ ] Run `build_runner` again
- [ ] Test CRUD operations

---

## 🎯 Summary

1. Create `TableName extends Table` with columns
2. Register in `@DriftDatabase(tables: [TableName])`
3. Generate code: `build_runner build`
4. Create `TableNameDao` with CRUD methods
5. Register in `@DriftDatabase(daos: [TableNameDao])`
6. Generate code again
7. Use `TableNameCompanion` for inserts/updates
8. Use DAO methods for all operations

---

**Replace `TableName` with your actual table name throughout!**
