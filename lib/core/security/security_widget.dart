import 'package:flutter/material.dart';
import 'security_service.dart';

/// Widget that blocks app access if device is compromised
class SecurityGate extends StatefulWidget {
  final Widget child;
  final Widget? blockedWidget;

  const SecurityGate({super.key, required this.child, this.blockedWidget});

  @override
  State<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends State<SecurityGate> {
  bool _isChecking = true;
  bool _isCompromised = false;
  String? _securityMessage;

  @override
  void initState() {
    super.initState();
    _performSecurityCheck();
  }

  Future<void> _performSecurityCheck() async {
    final isCompromised = await SecurityService.isDeviceCompromised();
    final message = await SecurityService.getSecurityMessage();

    if (mounted) {
      setState(() {
        _isCompromised = isCompromised;
        _securityMessage = message;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (_isCompromised) {
      return widget.blockedWidget ?? _defaultBlockedWidget();
    }

    return widget.child;
  }

  Widget _defaultBlockedWidget() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 64, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  'Access Denied',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  _securityMessage ??
                      'Your device does not meet security requirements.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Retry security check
                    setState(() {
                      _isChecking = true;
                    });
                    _performSecurityCheck();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
