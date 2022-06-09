library fframe;

import 'dart:async';
import 'package:fframe/controllers/selection_state_controller.dart';
import 'package:fframe/helper_widgets/init_l10n.dart';
import 'package:fframe/helpers/curved_bottom_navbar.dart';
import 'package:fframe/helpers/documentlist_search.dart';
import 'package:fframe/helper_widgets/init_firebase.dart';
import 'package:fframe/helpers/l10n.dart';

import 'package:fframe/screens/screens.dart';
import 'package:fframe/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fframe/providers/global_providers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:uuid/uuid.dart';
import 'package:frouter/frouter.dart';

export 'package:frouter/frouter.dart';
part 'fframe_main.dart';
part 'screens/documentscreen.dart';
part 'screens/document_parts/document_list_item.dart';
part 'screens/document_parts/document_title.dart';
part 'helpers/validator.dart';
part 'models/app_user.dart';
