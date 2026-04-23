// import 'package:flutter/material.dart';

// import 'location_permission_service.dart';

// /// Widget guard that ensures GPS/High Accuracy is enabled before showing child.
// ///
// /// This guard wraps screens that require GPS (Branch Selection, Order Tracking, Live Delivery Map).
// /// - If GPS is enabled: Shows the child widget normally
// /// - If GPS is disabled: Requests location which triggers Android's "Location Accuracy" system dialog
// /// - Keeps requesting until GPS is enabled (back button doesn't bypass)
// ///
// /// Usage:
// /// ```dart
// /// LocationGpsGuard(
// ///   child: BranchSelectionScreen(),
// /// )
// /// ```
// class LocationGpsGuard extends StatefulWidget {
//   const LocationGpsGuard({super.key, required this.child});

//   final Widget child;

//   @override
//   State<LocationGpsGuard> createState() => _LocationGpsGuardState();
// }

// class _LocationGpsGuardState extends State<LocationGpsGuard>
//     with WidgetsBindingObserver {
//   bool _isGpsEnabled = false;
//   bool _isChecking = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _checkGpsStatus();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   /// Checks GPS status and requests location if needed.
//   ///
//   /// Requesting location with geolocator will automatically trigger
//   /// Android's "Location Accuracy" system dialog if GPS is disabled.
//   Future<void> _checkGpsStatus() async {
//     // Check if GPS is enabled
//     final isEnabled = await LocationPermissionService.isGpsEnabled();

//     if (isEnabled) {
//       // GPS is enabled - allow screen to show
//       if (mounted) {
//         setState(() {
//           _isGpsEnabled = true;
//           _isChecking = false;
//         });
//       }
//       return;
//     }

//     // GPS is disabled - request location to trigger system dialog
//     try {
//       // This will trigger Android's "Location Accuracy" system dialog
//       await LocationPermissionService.requestCurrentLocation();

//       // If we get here, GPS was enabled (user tapped "Turn on")
//       if (mounted) {
//         setState(() {
//           _isGpsEnabled = true;
//           _isChecking = false;
//         });
//       }
//     } catch (e) {
//       // Location request failed - GPS still disabled
//       // Re-check after a short delay
//       if (mounted) {
//         await Future.delayed(const Duration(milliseconds: 500));
//         _checkGpsStatus(); // Recursive call to keep checking
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // If GPS is enabled, show the child widget
//     if (_isGpsEnabled) {
//       return widget.child;
//     }

//     // If still checking, show loading indicator
//     if (_isChecking) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     // GPS is disabled - show empty scaffold while waiting for system dialog
//     // The system dialog will appear automatically when we request location
//     return const Scaffold(body: Center(child: CircularProgressIndicator()));
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     // When app resumes (user returns from settings), re-check GPS
//     if (state == AppLifecycleState.resumed) {
//       _checkGpsStatus();
//     }
//   }
// }
