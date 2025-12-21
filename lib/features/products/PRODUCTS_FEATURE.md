# Products Feature - Complete Guide

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [File Structure](#file-structure)
4. [Component Details](#component-details)
5. [Data Flow](#data-flow)
6. [State Management](#state-management)
7. [Offline Support](#offline-support)
8. [UI Components](#ui-components)
9. [Usage Examples](#usage-examples)
10. [Adding New Features](#adding-new-features)
11. [Best Practices](#best-practices)

---

## Overview

The Products feature implements a complete product listing system following **Clean Architecture** principles with **offline-first** support. It demonstrates:

- ✅ **Clean Architecture** (Domain, Data, Presentation layers)
- ✅ **Repository Pattern** (Abstract interface + Implementation)
- ✅ **Use Case Pattern** (Business logic encapsulation)
- ✅ **State Management** (Cubit/Bloc pattern)
- ✅ **Dependency Injection** (GetIt service locator)
- ✅ **Error Handling** (Either/Left/Right pattern)
- ✅ **Offline-First Strategy** (Drift database with connectivity checks)
- ✅ **Pagination** (Infinite scroll with skip/limit)
- ✅ **Pull-to-Refresh** (Manual data refresh)

### Features Implemented

- ✅ Product listing with pagination
- ✅ Infinite scroll loading
- ✅ Pull-to-refresh functionality
- ✅ Offline support with local database
- ✅ Automatic data synchronization
- ✅ Loading shimmer effects
- ✅ Error handling and retry mechanism
- ✅ Product card display with images
- ✅ Discount price calculation

---

## Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER              │
│  (UI, Widgets, State Management)        │
│  - ProductsPage                         │
│  - ProductsCubit (State Management)     │
│  - ProductsState                        │
│  - ProductsList Widget                  │
│  - ProductCard Widget                   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           DOMAIN LAYER                   │
│  (Business Logic, Entities)             │
│  - ProductEntity                        │
│  - ProductListEntity                    │
│  - ProductRepository (Interface)       │
│  - GetProductsUseCase                   │
│  - GetProductsParams                    │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            DATA LAYER                    │
│  (API, Storage, Models)                 │
│  - ProductRepositoryImpl                │
│  - ProductRemoteDataSource (Interface) │
│  - ProductRemoteDataSourceImpl          │
│  - ProductLocalDataSource (Interface)  │
│  - ProductLocalDataSourceImpl           │
│  - ProductModel                         │
│  - ProductsResponse                      │
│  - ProductMapper                        │
│  - AppDatabase (Drift)                  │
└─────────────────────────────────────────┘
```

### Dependency Flow

```
UI (ProductsPage)
    ↓
ProductsCubit (State Management)
    ↓
GetProductsUseCase (Business Logic)
    ↓
ProductRepository (Interface)
    ↓
ProductRepositoryImpl (Implementation)
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

---

## File Structure

```
lib/features/products/
├── data/
│   ├── data_sources/
│   │   ├── product_remote_data_source.dart          # Abstract interface
│   │   ├── product_remote_data_source_impl.dart      # API implementation
│   │   ├── product_local_data_source.dart             # Abstract interface
│   │   └── product_local_data_source_impl.dart        # Drift implementation
│   ├── mappers/
│   │   └── product_mapper.dart                        # Model ↔ Entity mapper
│   ├── models/
│   │   ├── product_model.dart                         # API response model
│   │   └── products_response.dart                     # Paginated response model
│   └── repositories/
│       └── product_repository_impl.dart               # Repository implementation
├── domain/
│   ├── entities/
│   │   ├── product_entity.dart                        # Single product entity
│   │   └── product_list.dart                          # Paginated list entity
│   ├── repositories/
│   │   └── product_repository.dart                    # Repository interface
│   └── use_cases/
│       └── get_products_use_case.dart                 # Use case + Params
├── presentation/
│   ├── cubit/
│   │   ├── products_cubit.dart                         # State management
│   │   └── products_state.dart                         # State class
│   ├── pages/
│   │   └── products_page.dart                          # Main products page
│   └── widgets/
│       ├── products_list.dart                          # List widget
│       └── product_card.dart                            # Card widget
└── products_injection.dart                              # Dependency injection
```

---

## Component Details

### 1. Domain Layer

#### ProductEntity

**Location:** `lib/features/products/domain/entities/product_entity.dart`

Represents a single product in the domain layer.

```dart
class ProductEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String sku;
  final String thumbnail;
  final List<String> images;

  // Computed property
  double get discountedPrice => price * (1 - discountPercentage / 100);
}
```

**Key Features:**
- Immutable entity (Equatable)
- Computed property for discounted price
- All product information fields

#### ProductListEntity

**Location:** `lib/features/products/domain/entities/product_list.dart`

Represents a paginated list of products.

```dart
class ProductListEntity extends Equatable {
  final List<ProductEntity> products;
  final int total;
  final int skip;
  final int limit;
}
```

**Key Features:**
- Pagination metadata (total, skip, limit)
- List of ProductEntity objects

#### ProductRepository (Interface)

**Location:** `lib/features/products/domain/repositories/product_repository.dart`

Abstract interface for product data operations.

```dart
abstract class ProductRepository {
  Future<Either<ErrorMsg, ProductListEntity>> getProducts({
    required GetProductsParams params,
  });
}
```

**Key Features:**
- Returns Either type for error handling
- Uses params for pagination

#### GetProductsUseCase

**Location:** `lib/features/products/domain/use_cases/get_products_use_case.dart`

Encapsulates business logic for fetching products.

```dart
class GetProductsUseCase implements UseCase<ProductListEntity, GetProductsParams> {
  final ProductRepository productRepository;

  @override
  Future<Either<ErrorMsg, ProductListEntity>> call(GetProductsParams params) async {
    return await productRepository.getProducts(params: params);
  }
}

class GetProductsParams {
  final int? skip;
  final int? limit;
}
```

**Key Features:**
- Implements base UseCase interface
- Handles pagination parameters
- Delegates to repository

---

### 2. Data Layer

#### ProductModel

**Location:** `lib/features/products/data/models/product_model.dart`

API response model that extends ProductEntity.

```dart
class ProductModel extends ProductEntity {
  const ProductModel({...});

  factory ProductModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
  ProductEntity toEntity() {...}
}
```

**Key Features:**
- Extends ProductEntity
- JSON serialization/deserialization
- Converts to entity

#### ProductsResponse

**Location:** `lib/features/products/data/models/products_response.dart`

Paginated API response model.

```dart
class ProductsResponse {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;
}
```

#### ProductRemoteDataSource

**Location:** `lib/features/products/data/data_sources/product_remote_data_source.dart`

Abstract interface for remote API calls.

```dart
abstract class ProductRemoteDataSource {
  Future<ProductsResponse> getProducts({required GetProductsParams params});
}
```

#### ProductRemoteDataSourceImpl

**Location:** `lib/features/products/data/data_sources/product_remote_data_source_impl.dart`

Concrete implementation using ApiClient.

```dart
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  @override
  Future<ProductsResponse> getProducts({required GetProductsParams params}) async {
    final queryParams = <String, dynamic>{};
    if (params.skip != null) queryParams['skip'] = params.skip;
    if (params.limit != null) queryParams['limit'] = params.limit;

    final response = await apiClient.get(
      '/products',
      queryParameters: queryParams,
    );

    return ProductsResponse.fromJson(response);
  }
}
```

**Key Features:**
- Uses ApiClient for HTTP requests
- Handles query parameters for pagination
- Returns ProductsResponse model

#### ProductLocalDataSource

**Location:** `lib/features/products/data/data_sources/product_local_data_source.dart`

Abstract interface for local database operations.

```dart
abstract class ProductLocalDataSource {
  Future<void> saveProducts(ProductsResponse response, {bool clearFirst = false});
  Future<ProductsResponse> getProducts({int? skip, int? limit});
  Future<void> clearProducts();
  Future<int> getProductsCount();
}
```

#### ProductLocalDataSourceImpl

**Location:** `lib/features/products/data/data_sources/product_local_data_source_impl.dart`

Concrete implementation using Drift database.

```dart
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase database;

  @override
  Future<void> saveProducts(ProductsResponse response, {bool clearFirst = false}) async {
    if (clearFirst) {
      await database.delete(database.products).go();
    }

    await database.batch((batch) {
      for (final product in response.products) {
        batch.insert(
          database.products,
          ProductsCompanion.insert(
            id: Value(product.id),
            title: Value(product.title),
            // ... other fields
            createdAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
      }
    });
  }

  @override
  Future<ProductsResponse> getProducts({int? skip, int? limit}) async {
    var query = database.select(database.products)
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);

    if (skip != null) query = query..limit(limit ?? 30, offset: skip);
    if (limit != null) query = query..limit(limit, offset: skip ?? 0);

    final results = await query.get();
    // Convert to ProductModel and return ProductsResponse
  }
}
```

**Key Features:**
- Uses Drift database for local storage
- Handles pagination with skip/limit
- Converts database rows to models
- Supports clearing data before saving

#### ProductRepositoryImpl

**Location:** `lib/features/products/data/repositories/product_repository_impl.dart`

Implements offline-first strategy.

```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  @override
  Future<Either<ErrorMsg, ProductListEntity>> getProducts({
    required GetProductsParams params,
  }) async {
    final hasInternet = await connectivityService.hasInternetConnection();

    if (hasInternet) {
      try {
        // Fetch from API
        final response = await remoteDataSource.getProducts(params: params);
        
        // Save to local database
        await localDataSource.saveProducts(
          response,
          clearFirst: params.skip == null || params.skip == 0,
        );

        // Convert to entities and return
        return Right(ProductListEntity(...));
      } catch (e) {
        // If remote fails, try local
        return await _getProductsFromLocal(params);
      }
    } else {
      // No internet - get from local database
      return await _getProductsFromLocal(params);
    }
  }
}
```

**Key Features:**
- **Offline-First Strategy**: Checks connectivity first
- **Automatic Sync**: Saves remote data to local database
- **Fallback**: Uses local data if remote fails
- **Error Handling**: Returns Either type

#### ProductMapper

**Location:** `lib/features/products/data/mappers/product_mapper.dart`

Converts between Model and Entity.

```dart
class ProductMapper {
  static ProductEntity toEntity(ProductModel model) {
    return ProductEntity(
      id: model.id,
      title: model.title,
      // ... map all fields
    );
  }
}
```

---

### 3. Presentation Layer

#### ProductsState

**Location:** `lib/features/products/presentation/cubit/products_state.dart`

State class for products feature.

```dart
class ProductsState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? errorMessage;
  final int total;
  final int skip;
  final int limit;
  final bool hasMore;

  factory ProductsState.initial() {
    return const ProductsState(
      products: [],
      isLoading: false,
      errorMessage: null,
      total: 0,
      skip: 0,
      limit: 30,
      hasMore: true,
    );
  }

  ProductsState copyWith({...}) {...}
}
```

**Key Features:**
- Tracks loading state
- Error message handling
- Pagination state (skip, limit, hasMore)
- Product list

#### ProductsCubit

**Location:** `lib/features/products/presentation/cubit/products_cubit.dart`

State management for products.

```dart
class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsCubit({required this.getProductsUseCase})
      : super(ProductsState.initial()) {
    loadProducts();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getProductsUseCase(
      GetProductsParams(
        skip: refresh ? 0 : state.skip,
        limit: state.limit,
      ),
    );

    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (result) {
        final newProducts = refresh
            ? result.products
            : [...state.products, ...result.products];
        final hasMore = newProducts.length < result.total;

        emit(state.copyWith(
          products: newProducts,
          isLoading: false,
          skip: state.skip + result.products.length,
          total: result.total,
          hasMore: hasMore,
        ));
      },
    );
  }

  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
  }

  Future<void> loadMoreProducts() async {
    if (!state.hasMore || state.isLoading) return;
    await loadProducts();
  }
}
```

**Key Methods:**
- `loadProducts()`: Load products with pagination
- `refreshProducts()`: Refresh from beginning
- `loadMoreProducts()`: Load next page (infinite scroll)

#### ProductsPage

**Location:** `lib/features/products/presentation/pages/products_page.dart`

Main products page.

```dart
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Products'), centerTitle: true),
        body: const ProductsList(),
      ),
    );
  }
}
```

**Key Features:**
- Provides ProductsCubit via BlocProvider
- Uses factory registration (new instance per page)

#### ProductsList Widget

**Location:** `lib/features/products/presentation/widgets/products_list.dart`

Displays product list with loading, error, and empty states.

```dart
class ProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        // Loading state
        if (state.isLoading && state.products.isEmpty) {
          return AppShimmerGrid();
        }

        // Error state
        if (state.errorMessage != null && state.products.isEmpty) {
          return ErrorWidget(...);
        }

        // Empty state
        if (state.products.isEmpty) {
          return EmptyStateWidget(...);
        }

        // Success state with GridView
        return RefreshIndicator(
          onRefresh: () => context.read<ProductsCubit>().refreshProducts(),
          child: GridView.builder(
            itemCount: state.products.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.products.length) {
                // Load more indicator
                context.read<ProductsCubit>().loadMoreProducts();
                return CircularProgressIndicator();
              }
              return ProductCard(product: state.products[index]);
            },
          ),
        );
      },
    );
  }
}
```

**Key Features:**
- Loading shimmer effect
- Error handling with retry
- Pull-to-refresh
- Infinite scroll pagination
- Grid layout

#### ProductCard Widget

**Location:** `lib/features/products/presentation/widgets/product_card.dart`

Displays individual product card.

```dart
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(product.thumbnail),
          Text(product.title),
          Text('\$${product.discountedPrice.toStringAsFixed(2)}'),
          // ... other product details
        ],
      ),
    );
  }
}
```

---

## Data Flow

### 1. Initial Load

```
1. ProductsPage builds
2. BlocProvider creates ProductsCubit
3. ProductsCubit constructor calls loadProducts()
4. loadProducts() emits loading state
5. Calls GetProductsUseCase with skip=0, limit=30
6. GetProductsUseCase calls ProductRepository.getProducts()
7. ProductRepository checks connectivity
8. If online: Fetch from API → Save to DB → Return entities
9. If offline: Fetch from DB → Return entities
10. ProductsCubit receives result and emits success state
11. ProductsList widget rebuilds with products
```

### 2. Pull-to-Refresh

```
1. User pulls down on ProductsList
2. RefreshIndicator triggers onRefresh
3. Calls ProductsCubit.refreshProducts()
4. refreshProducts() calls loadProducts(refresh: true)
5. loadProducts() resets skip to 0 and clears products
6. Fetches fresh data from API
7. Updates state with new products
```

### 3. Infinite Scroll (Load More)

```
1. User scrolls to bottom of list
2. GridView.builder reaches last item
3. Checks if hasMore is true
4. Calls ProductsCubit.loadMoreProducts()
5. loadMoreProducts() calls loadProducts() with current skip
6. Appends new products to existing list
7. Updates skip and hasMore state
```

### 4. Offline Flow

```
1. User opens app without internet
2. ProductsCubit.loadProducts() called
3. ProductRepository checks connectivity → false
4. Calls _getProductsFromLocal()
5. ProductLocalDataSource queries Drift database
6. Returns cached products
7. ProductsCubit emits success with local data
```

---

## State Management

### State Transitions

```
Initial State
    ↓
Loading (isLoading: true, products: [])
    ↓
    ├─→ Success (isLoading: false, products: [...])
    │       ↓
    │   Load More (isLoading: true, products: [...])
    │       ↓
    │   Success (isLoading: false, products: [...more])
    │
    └─→ Error (isLoading: false, errorMessage: "...")
            ↓
        Retry → Loading
```

### State Properties

| Property | Type | Description |
|----------|------|-------------|
| `products` | `List<ProductEntity>` | List of loaded products |
| `isLoading` | `bool` | Loading indicator state |
| `errorMessage` | `String?` | Error message if any |
| `total` | `int` | Total products available |
| `skip` | `int` | Current pagination offset |
| `limit` | `int` | Items per page (default: 30) |
| `hasMore` | `bool` | Whether more products available |

---

## Offline Support

### Architecture

The products feature implements an **offline-first** strategy:

1. **Connectivity Check**: Uses `ConnectivityService` to check internet
2. **Remote First**: If online, fetch from API
3. **Auto-Sync**: Save API response to local database
4. **Fallback**: If offline or API fails, use local database
5. **Seamless UX**: User doesn't notice the difference

### Database Schema

**Table:** `Products`

| Column | Type | Description |
|--------|------|-------------|
| `id` | `int` | Product ID (Primary Key) |
| `title` | `text` | Product title |
| `description` | `text` | Product description |
| `category` | `text` | Product category |
| `price` | `real` | Original price |
| `discountPercentage` | `real` | Discount percentage |
| `rating` | `real` | Product rating |
| `stock` | `int` | Available stock |
| `tags` | `text` | JSON array of tags |
| `brand` | `text` | Product brand (nullable) |
| `sku` | `text` | SKU code |
| `thumbnail` | `text` | Thumbnail image URL |
| `images` | `text` | JSON array of image URLs |
| `createdAt` | `int` | Timestamp (for sorting) |

### Implementation Details

**Location:** `lib/core/database/app_database.dart`

```dart
class Products extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  // ... other columns
  IntColumn get createdAt => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

**Key Features:**
- Primary key on `id`
- JSON storage for arrays (tags, images)
- Timestamp for sorting (newest first)

---

## UI Components

### ProductsPage

- **AppBar**: Title "Products"
- **Body**: ProductsList widget
- **Provider**: BlocProvider for ProductsCubit

### ProductsList

- **Loading**: AppShimmerGrid (shimmer effect)
- **Error**: Error widget with retry button
- **Empty**: Empty state message
- **Success**: GridView with RefreshIndicator

### ProductCard

- **Image**: Network image from thumbnail URL
- **Title**: Product title
- **Price**: Discounted price (computed)
- **Rating**: Star rating display
- **Stock**: Stock availability

---

## Usage Examples

### 1. Navigate to Products Page

```dart
// From Examples page
context.push(AppRoutes.path(AppRoutes.products));
```

### 2. Access ProductsCubit

```dart
// Read state
final state = context.read<ProductsCubit>().state;

// Call methods
context.read<ProductsCubit>().refreshProducts();
context.read<ProductsCubit>().loadMoreProducts();
```

### 3. Listen to State Changes

```dart
BlocBuilder<ProductsCubit, ProductsState>(
  builder: (context, state) {
    if (state.isLoading) return LoadingWidget();
    if (state.errorMessage != null) return ErrorWidget();
    return ProductsGrid(products: state.products);
  },
)
```

### 4. Use BlocSelector for Specific State

```dart
BlocSelector<ProductsCubit, ProductsState, bool>(
  selector: (state) => state.isLoading,
  builder: (context, isLoading) {
    return isLoading ? CircularProgressIndicator() : SizedBox();
  },
)
```

---

## Adding New Features

### Example: Add Product Search

#### 1. Update Domain Layer

**Add to `GetProductsParams`:**
```dart
class GetProductsParams {
  final int? skip;
  final int? limit;
  final String? searchQuery; // NEW
}
```

**Update `ProductRepository` interface:**
```dart
abstract class ProductRepository {
  Future<Either<ErrorMsg, ProductListEntity>> getProducts({
    required GetProductsParams params,
  });
}
```

#### 2. Update Data Layer

**Update `ProductRemoteDataSourceImpl`:**
```dart
@override
Future<ProductsResponse> getProducts({required GetProductsParams params}) async {
  final queryParams = <String, dynamic>{};
  if (params.skip != null) queryParams['skip'] = params.skip;
  if (params.limit != null) queryParams['limit'] = params.limit;
  if (params.searchQuery != null) queryParams['q'] = params.searchQuery; // NEW

  final response = await apiClient.get('/products/search', queryParameters: queryParams);
  return ProductsResponse.fromJson(response);
}
```

**Update `ProductLocalDataSourceImpl`:**
```dart
@override
Future<ProductsResponse> getProducts({int? skip, int? limit, String? searchQuery}) async {
  var query = database.select(database.products);
  
  if (searchQuery != null) {
    query = query.where((t) => t.title.like('%$searchQuery%'));
  }
  
  // ... rest of implementation
}
```

#### 3. Update Presentation Layer

**Add to `ProductsState`:**
```dart
class ProductsState extends Equatable {
  // ... existing fields
  final String? searchQuery; // NEW
}
```

**Add to `ProductsCubit`:**
```dart
Future<void> searchProducts(String query) async {
  emit(state.copyWith(searchQuery: query, skip: 0, products: []));
  await loadProducts(refresh: true);
}
```

**Update UI:**
```dart
// Add search field in ProductsPage
TextField(
  onChanged: (value) {
    context.read<ProductsCubit>().searchProducts(value);
  },
)
```

#### 4. Update Dependency Injection

No changes needed if using existing dependencies.

---

## Best Practices

### 1. Offline-First Strategy

✅ **DO:**
- Always check connectivity before API calls
- Save remote data to local database
- Use local data as fallback
- Show appropriate messages for offline state

❌ **DON'T:**
- Block UI while checking connectivity
- Show errors for offline mode (use local data)
- Forget to sync data when online

### 2. Pagination

✅ **DO:**
- Use skip/limit for pagination
- Track `hasMore` to prevent unnecessary calls
- Reset pagination on refresh
- Show loading indicator for load more

❌ **DON'T:**
- Load all data at once
- Call API if `hasMore` is false
- Forget to update skip after loading

### 3. State Management

✅ **DO:**
- Use factory registration for Cubit (new instance per page)
- Emit loading state before async operations
- Handle errors gracefully
- Reset state on refresh

❌ **DON'T:**
- Use singleton for page-level Cubits
- Forget to handle loading/error states
- Emit state without mounted check (if needed)

### 4. Error Handling

✅ **DO:**
- Use Either type for error handling
- Show user-friendly error messages
- Provide retry mechanism
- Log errors for debugging

❌ **DON'T:**
- Show technical error messages to users
- Ignore errors silently
- Forget to reset error state

### 5. Performance

✅ **DO:**
- Use pagination to limit data
- Cache images properly
- Use lazy loading for lists
- Optimize database queries

❌ **DON'T:**
- Load all products at once
- Fetch data on every build
- Forget to dispose resources

---

## Summary

The Products feature demonstrates:

1. **Clean Architecture**: Clear separation of concerns
2. **Offline-First**: Seamless offline experience
3. **State Management**: Reactive UI with Cubit
4. **Error Handling**: Robust error management
5. **Pagination**: Efficient data loading
6. **User Experience**: Loading states, pull-to-refresh, infinite scroll

This implementation serves as a template for other features requiring offline support and pagination.
