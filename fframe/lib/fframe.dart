library fframe;

import 'dart:async';
import 'dart:math' as math;
import 'package:fframe/controllers/app_user_state_controller.dart';
import 'package:fframe/controllers/navigation_state_controller.dart';
import 'package:fframe/models/navigation_target.dart';
import 'package:fframe/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fframe/providers/global_providers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/firestore.dart';

part 'main.dart';
part 'screens/documentscreen.dart';
part 'helpers/expandable_fab.dart';
