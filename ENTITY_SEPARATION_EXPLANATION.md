# Entity Separation: ProductEntity vs ProductsResultEntity

## Current Structure

### 1. `ProductEntity` (Single Product)
- **File:** `domain/entities/product_entity.dart`
- **Purpose:** Represents a single product
- **Contains:** Product data (id, title, price, etc.)

### 2. `ProductsResultEntity` (Paginated Result)
- **File:** `domain/entities/products_result_entity.dart`
- **Purpose:** Represents a paginated API response
- **Contains:** List of products + pagination metadata (total, skip, limit)

## Why They're Separate

### ✅ Current Separation (Recommended)

**ProductEntity:**
- Used for individual products
- Reusable across different contexts:
  - Product list items
  - Product detail screen
  - Product search results
  - Favorite products
  - Cart items

**ProductsResultEntity:**
- Used only for API responses
- Contains pagination metadata
- Temporary DTO between repository and use case

### Usage Examples

```dart
// ProductEntity - Individual product
ProductCard(product: ProductEntity(...))  // ✅ Single product
ProductDetailScreen(product: ProductEntity(...))  // ✅ Single product

// ProductsResultEntity - API response
ProductsResultEntity(
  products: [ProductEntity(...), ...],  // List of products
  total: 100,  // Pagination metadata
  skip: 0,
  limit: 30,
)
```

## Analysis

### Current Usage

1. **ProductEntity** is used in:
   - `ProductCard` widget (single product)
   - `ProductsState.products` (list of products)
   - Product mappers

2. **ProductsResultEntity** is used in:
   - Repository return type
   - Use case return type
   - Converted to `ProductsState` (products extracted, pagination stored separately)

### The Question: Do We Need Both?

**Option 1: Keep Separate (Current) ✅**
- **Pros:**
  - Clear separation of concerns
  - `ProductEntity` is reusable
  - `ProductsResultEntity` is API-specific
  - Follows single responsibility principle

- **Cons:**
  - Two files for related entities
  - `ProductsResultEntity` is thin (just a wrapper)

**Option 2: Combine into One File**
- **Pros:**
  - Fewer files
  - Related entities together

- **Cons:**
  - Mixes concerns (single product vs paginated result)
  - Less clear separation

## Recommendation

### ✅ Keep Separate (Current Approach)

**Reasoning:**
1. **Single Responsibility:** Each entity has a clear purpose
2. **Reusability:** `ProductEntity` can be used independently
3. **Clarity:** Clear distinction between single product and paginated result
4. **Future-proof:** If you add product detail screen, you'll use `ProductEntity` directly

### Alternative: Combine in One File

If you prefer fewer files, you could combine them:

```dart
// domain/entities/product_entities.dart
class ProductEntity { ... }
class ProductsResultEntity { ... }
```

But this is less common in Clean Architecture where each entity typically has its own file.

## Conclusion

The current separation is **good practice** and follows Clean Architecture principles. However, if you prefer fewer files, they can be combined into one file while keeping the classes separate.

**Recommendation:** Keep them separate for better organization and clarity.
