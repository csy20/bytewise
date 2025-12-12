import 'package:flutter/material.dart';
import '../services/update_service.dart';

/// A wrapper widget that handles app lifecycle for in-app updates.
/// Checks for updates on app start and when app resumes from background.
class UpdateWrapper extends StatefulWidget {
  final Widget child;

  const UpdateWrapper({super.key, required this.child});

  @override
  State<UpdateWrapper> createState() => _UpdateWrapperState();
}

class _UpdateWrapperState extends State<UpdateWrapper> with WidgetsBindingObserver {
  final UpdateService _updateService = UpdateService();
  bool _hasCheckedOnStart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for updates once when app starts
    if (!_hasCheckedOnStart) {
      _hasCheckedOnStart = true;
      // Delay slightly to ensure context is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateService.checkForUpdate(context);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Check for updates when app resumes
    if (state == AppLifecycleState.resumed) {
      _updateService.checkForUpdate(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
