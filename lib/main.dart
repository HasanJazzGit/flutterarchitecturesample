import 'package:flutter/material.dart';
import 'features/app/presentation/pages/flutter_sample_app.dart';
import 'core/flavor/flavor_setup_helper.dart';
import 'core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor-specific configurations
  FlavorSetupHelper.initialize();
  FlavorSetupHelper.printFlavorConfig();

  // Initialize dependency injection (includes AppPref initialization)
  await initDependencyInjection();

  runApp(const FlutterSampleApp());
}
