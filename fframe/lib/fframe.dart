library fframe;

import 'dart:async';
import 'dart:math' as math;
import 'package:fframe/controllers/app_user_state_controller.dart';
import 'package:fframe/controllers/navigation_state_controller.dart';
import 'package:fframe/models/navigation_target.dart';

import 'package:fframe/screens/screens.dart';
import 'package:fframe/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fframe/providers/global_providers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:uuid/uuid.dart';

part 'fframe_main.dart';
part 'screens/documentscreen.dart';
part 'screens/document_parts/document_list_item.dart';
part 'screens/document_parts/document_title.dart';
part 'helpers/expandable_fab.dart';
part 'helpers/validator.dart';
part 'models/app_user.dart';
