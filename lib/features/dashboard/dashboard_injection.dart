import '../../core/di/dependency_injection.dart';
import 'presentation/manager/dashboard_cubit.dart';

/// Initialize dashboard feature dependencies
void initDashboardInjector() {
  // Register Cubit as singleton so theme/language changes are shared across the app
  sl.registerLazySingleton<DashboardCubit>(() => DashboardCubit());
}
