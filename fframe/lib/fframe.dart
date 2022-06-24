library fframe;

export 'package:frouter/frouter.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:flutterfire_ui/firestore.dart';
import 'dart:async';
import 'package:fframe/helper_widgets/confirmation_dialog.dart';
import 'package:fframe/providers/global_providers.dart';
import 'package:flutter/material.dart';

import 'package:fframe/controllers/selection_state_controller.dart';
import 'package:fframe/helper_widgets/init_l10n.dart';
import 'package:fframe/helpers/documentlist_search.dart';
import 'package:fframe/helper_widgets/init_firebase.dart';
import 'package:fframe/helpers/l10n.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import 'package:fframe/screens/screens.dart';
import 'package:fframe/services/database_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:preload_page_view/preload_page_view.dart';
import 'package:frouter/frouter.dart';
import 'package:uuid/uuid.dart';

part 'fframe_main.dart';
part 'screens/document_screen/models.dart';
part 'screens/document_screen/typedefs.dart';
part 'screens/document_screen/document_screen.dart';
part 'screens/document_screen/document_body.dart';
part 'screens/document_screen/document_context.dart';
part 'screens/document_screen/document_list.dart';
part 'helpers/validator.dart';
part 'models/app_user.dart';
