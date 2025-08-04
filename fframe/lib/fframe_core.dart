// ignore_for_file: depend_on_referenced_packages, unused_import

/// Core fframe services without web-specific dependencies.
/// Use this entry point for:
/// - Unit tests running on VM platform  
/// - Server-side code
/// - Any non-web Flutter platforms
/// 
/// This provides just the service classes needed for dependency injection.
library fframe_core;

// Core Firebase exports (platform-independent)
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';  
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_storage/firebase_storage.dart';

// Export the core services and models
export 'services/database_service.dart';
export 'models/document_config_core.dart';