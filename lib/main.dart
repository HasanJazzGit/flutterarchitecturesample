import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'features/app/presentation/pages/flutter_sample_app.dart';
import 'core/flavor/flavor_setup_helper.dart';
import 'core/di/dependency_injection.dart';
import 'core/security/security_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor-specific configurations
  FlavorSetupHelper.initialize();
  FlavorSetupHelper.printFlavorConfig();

  // Initialize dependency injection (includes AppPref initialization)
  // Encryption can be enabled/configured through AppPref methods after initialization
  await initDependencyInjection();

  runApp(
    kDebugMode
        ? FlutterSampleApp()
        : // Wrap app with SecurityGate to block compromised devices
          SecurityGate(child: const FlutterSampleApp()),
  );
}
