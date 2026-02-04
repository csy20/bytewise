import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to handle Google Play in-app updates.
/// Supports hybrid mode: immediate for critical updates, flexible for others.
class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  /// Set this to true to force immediate update (for critical releases)
  /// You can change this value based on your release strategy
  static const bool isCriticalUpdate = false;

  AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateStarted = false;

  /// Check for updates and handle appropriately
  Future<void> checkForUpdate(BuildContext context) async {
    // Only works on Android
    if (!Platform.isAndroid) return;

    try {
      // Check connectivity first
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) {
        return;
      }

      _updateInfo = await InAppUpdate.checkForUpdate();

      if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
        if (isCriticalUpdate && _updateInfo!.immediateUpdateAllowed) {
          // Critical update: Force immediate update
          await _performImmediateUpdate();
        } else if (_updateInfo!.flexibleUpdateAllowed) {
          // Non-critical: Use flexible update
          if (context.mounted) {
            await _performFlexibleUpdate(context);
          }
        } else if (_updateInfo!.immediateUpdateAllowed) {
          // Fallback to immediate if flexible not allowed
          await _performImmediateUpdate();
        }
      }
      
      // Check if a flexible update was downloaded and ready to install
      if (_updateInfo?.installStatus == InstallStatus.downloaded) {
        if (context.mounted) {
          _showUpdateReadySnackbar(context);
        }
      }
    } catch (e) {
      // Fail silently - Play API or connectivity might not be available
      debugPrint('UpdateService: Error checking for update: $e');
    }
  }

  /// Perform immediate update (blocks app until updated)
  Future<void> _performImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      debugPrint('UpdateService: Immediate update failed: $e');
    }
  }

  /// Perform flexible update (download in background)
  Future<void> _performFlexibleUpdate(BuildContext context) async {
    if (_flexibleUpdateStarted) return;
    
    try {
      _flexibleUpdateStarted = true;
      final result = await InAppUpdate.startFlexibleUpdate();
      
      if (result == AppUpdateResult.success) {
        // Download completed, show snackbar to restart
        if (context.mounted) {
          _showUpdateReadySnackbar(context);
        }
      }
    } catch (e) {
      debugPrint('UpdateService: Flexible update failed: $e');
      _flexibleUpdateStarted = false;
    }
  }

  /// Complete the flexible update (restart app)
  Future<void> completeUpdate() async {
    try {
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e) {
      debugPrint('UpdateService: Complete update failed: $e');
    }
  }

  /// Show snackbar when update is downloaded
  void _showUpdateReadySnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Update downloaded! Restart to finish.'),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'RESTART',
          onPressed: () {
            completeUpdate();
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Reset state (for testing)
  void reset() {
    _flexibleUpdateStarted = false;
    _updateInfo = null;
  }
}
