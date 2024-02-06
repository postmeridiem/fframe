// ignore_for_file: depend_on_referenced_packages, unused_import

library fframe;

export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_storage/firebase_storage.dart';
export 'package:flutterfire_ui/firestore.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:clipboard/clipboard.dart';
export 'package:shimmer/shimmer.dart';
export 'package:dotted_border/dotted_border.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:js_interop';
import 'dart:math';

import 'package:fframe/constants/constants.dart';
import 'package:fframe/controllers/query_state_controller.dart';
import 'package:fframe/screens/document_screen/document_search.dart';

import 'package:fframe/services/navigation_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fframe/providers/providers.dart';
import 'package:fframe/routers/navigation_route.dart';
import 'package:fframe/helpers/prompts.dart';
import 'package:fframe/helper_widgets/confirmation_dialog.dart';

import 'package:fframe/controllers/selection_state_controller.dart';
import 'package:fframe/helper_widgets/init_l10n.dart';

import 'package:fframe/helpers/l10n.dart';
import 'package:fframe/helpers/console_logger.dart';
import 'package:fframe/helpers/icons.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import 'package:fframe/screens/screens.dart';
import 'package:fframe/services/database_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:preload_page_view/preload_page_view.dart';
import 'package:uuid/uuid.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fframe/extensions/query.dart';
import "package:fframe/extensions/string.dart";

import 'material/paginated_data_table_extended.dart';
import 'package:dotted_border/dotted_border.dart';

part 'fframe_main.dart';
part 'frouter/frouter.dart';

part 'package:fframe/models/destination.dart';
part 'package:fframe/models/navigation_tab.dart';
part 'package:fframe/models/navigation_target.dart';
part 'package:fframe/models/sign_in_config.dart';
part 'package:fframe/models/router_config.dart';
part 'package:fframe/models/navigation_config.dart';

part 'package:fframe/services/target_state.dart';
part 'package:fframe/services/query_state.dart';

part 'screens/document_screen/models.dart';
part 'screens/document_screen/typedefs.dart';
part 'screens/document_screen/document_context.dart';
part 'screens/document_screen/document_screen.dart';
part 'screens/document_screen/document_body.dart';
part 'screens/document_screen/document_list.dart';
part 'package:fframe/screens/datagrid_screen/datagrid_firestore.dart';
part 'package:fframe/screens/listgrid_screen/listgrid_firestore.dart';
part 'package:fframe/screens/listgrid_screen/listgrid_controller.dart';
part 'package:fframe/screens/listgrid_screen/listgrid_widgets.dart';
part 'package:fframe/screens/listgrid_screen/listgrid_classes.dart';
part 'package:fframe/screens/listgrid_screen/listgrid_document.dart';
part 'package:fframe/screens/swimlanes_screen/swimlanes_firestore.dart';
part 'package:fframe/screens/swimlanes_screen/swimlanes_controller.dart';
part 'package:fframe/screens/swimlanes_screen/swimlanes_document.dart';
part 'package:fframe/screens/swimlanes_screen/swimlanes_widgets.dart';
part 'package:fframe/screens/swimlanes_screen/swimlanes_classes.dart';
part 'screens/router_page.dart';

part 'helpers/validator.dart';
part 'helpers/load_extra_data.dart';
part 'models/app_user.dart';
