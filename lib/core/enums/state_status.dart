enum StateStatus {
  idle,         // Default or initial state
  loading,      // Generic loading
  refreshing,   // Pull-to-refresh or background reload
  success,      // Operation succeeded
  error,        // Operation failed
  empty,        // No data available
  submitting,   // While sending a form or request
  updating,     // While editing or updating existing data
  deleting,     // While deleting an item
  noInternet,   // Network connection issue
  unauthorized, // Token expired or user not logged in
  paginating,   // Loading next page for infinite scroll
}
