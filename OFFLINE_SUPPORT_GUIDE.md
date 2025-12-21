# Offline Support with Drift Database

## Overview

The products feature now supports offline functionality using Drift database. When there's no internet connection, the app automatically fetches data from the local database.

## Architecture

### Data Flow

```
ProductsCubit
    ↓
GetProductsUseCase
    ↓
ProductRepository
    ↓
    ├─→ ConnectivityService (Check Internet)
    │
    ├─→ [Has Internet]
    │   ├─→ ProductRemoteDataSource (API)
    │   └─→ ProductLocalDataSource (Save to DB)
    │
    └─→ [No Internet]
        └─→ ProductLocalDataSource (Get from DB)
```

## Implementation Details

### 1. Database Setup

**Location:** `lib/core/database/app_database.dart`

- Uses Drift (SQLite) for local storage
- Products table stores all product data
- Automatic migrations support

### 2. Connectivity Service

**Location:** `lib/core/utils/connectivity_service.dart`

Checks internet connectivity:
```dart
final hasInternet = await connectivityService.hasInternetConnection();
```

### 3. Local Data Source

**Location:** `lib/features/products/data/data_sources/product_local_data_source.dart`

Handles:
- Saving products to database
- Retrieving products from database
- Clearing products
- Product count

### 4. Repository Logic

**Location:** `lib/features/products/data/repositories/product_repository_impl.dart`

**Flow:**
1. Check internet connectivity
2. If online:
   - Fetch from API
   - Save to local database
   - Return API data
3. If offline:
   - Fetch from local database
   - Return cached data

## Usage

### Automatic Offline Support

The repository automatically handles offline scenarios:

```dart
// Repository automatically checks connectivity
final result = await productRepository.getProducts(
  GetProductsParams(skip: 0, limit: 30),
);

result.fold(
  (error) => print('Error: $error'),
  (products) => print('Products: ${products.products.length}'),
);
```

### Manual Database Access

```dart
// Get database instance
final database = sl<AppDatabase>();

// Query products
final products = await database.select(database.products).get();

// Clear all products
await database.delete(database.products).go();
```

## Features

### ✅ Online Mode
- Fetches data from API
- Automatically saves to local database
- Returns fresh data

### ✅ Offline Mode
- Automatically detects no internet
- Fetches from local database
- Returns cached data
- Shows appropriate error if no cached data

### ✅ Data Persistence
- Products saved after each API call
- Data persists across app restarts
- Pagination support in local storage

## Setup Instructions

### 1. Install Dependencies

Dependencies are already added:
- `drift: ^2.14.1`
- `sqlite3_flutter_libs: ^0.5.18`
- `path_provider: ^2.1.1`
- `connectivity_plus: ^5.0.2`

### 2. Generate Database Code

Run build_runner to generate database code:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates: `lib/core/database/app_database.g.dart`

### 3. Database is Ready

The database is automatically initialized in dependency injection:
- Registered in `dependency_injection.dart`
- Available via `sl<AppDatabase>()`

## Testing Offline Mode

### Simulate Offline

1. **Android Emulator:**
   ```bash
   adb shell svc wifi disable
   adb shell svc data disable
   ```

2. **iOS Simulator:**
   - Settings → Airplane Mode

3. **Physical Device:**
   - Enable Airplane Mode
   - Disable Wi-Fi and Mobile Data

### Expected Behavior

1. **First Load (Online):**
   - Fetches from API
   - Saves to database
   - Displays products

2. **Subsequent Loads (Offline):**
   - Detects no internet
   - Fetches from database
   - Displays cached products

3. **No Cached Data (Offline):**
   - Shows error: "No products available offline. Please connect to the internet."

## Database Schema

### Products Table

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Product ID (Primary Key) |
| title | TEXT | Product title |
| description | TEXT | Product description |
| category | TEXT | Product category |
| price | REAL | Product price |
| discountPercentage | REAL | Discount percentage |
| rating | REAL | Product rating |
| stock | INTEGER | Stock quantity |
| tags | TEXT | JSON array of tags |
| brand | TEXT | Product brand (nullable) |
| sku | TEXT | SKU code |
| thumbnail | TEXT | Thumbnail image URL |
| images | TEXT | JSON array of image URLs |
| createdAt | INTEGER | Timestamp (milliseconds) |

## Best Practices

### ✅ DO:

1. **Always save API responses to database**
   - Ensures data is available offline
   - Automatic cache management

2. **Handle offline gracefully**
   - Show cached data when available
   - Display clear error messages when no cache

3. **Clear database on refresh**
   - When `skip == 0`, clear old data
   - Prevents stale data accumulation

4. **Use pagination in local storage**
   - Supports skip/limit for efficient queries
   - Matches API pagination behavior

### ❌ DON'T:

1. **Don't block UI on database operations**
   - Use async/await properly
   - Handle errors gracefully

2. **Don't store sensitive data**
   - Database is local and accessible
   - Use secure storage for sensitive data

3. **Don't forget to handle empty cache**
   - Check if local data exists
   - Show appropriate messages

## Troubleshooting

### Issue: Database not generating

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Products not saving

**Check:**
- Database is initialized in DI
- Local data source is registered
- Repository is using local data source

### Issue: Offline mode not working

**Check:**
- Connectivity service is registered
- Repository checks connectivity
- Local data source is implemented

## Future Enhancements

- [ ] Sync queue for offline actions
- [ ] Conflict resolution strategies
- [ ] Background sync
- [ ] Cache expiration
- [ ] Database encryption

---

**Last Updated:** 2024
**Version:** 1.0.0
