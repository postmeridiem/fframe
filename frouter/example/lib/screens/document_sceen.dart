import 'package:example/pages/document_body.dart';
import 'package:example/pages/document_list.dart';
import 'package:example/pages/empty_page.dart';
import 'package:flutter/material.dart';
import 'package:frouter/frouter.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Rebuild DocumentScreen");
    final GlobalKey<FormState> formState = GlobalKey<FormState>();

    return Form(
      key: formState,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Consumer(
              builder: (context, ref, child) {
                TargetState targetState = ref.watch(targetStateProvider);
                debugPrint("ReSpawn DocumentList for ${targetState.navigationTarget.path}");
                // NavigationNotifier navigationNotifier = ref.read(navigationProvider);
                TargetState targetContext = ref.read(targetStateProvider);
                return AnimatedSwitcher(
                  key: ValueKey("path_${key.toString()}"),
                  duration: const Duration(seconds: 2),
                  child: DocumentList(
                    key: ValueKey(targetState.navigationTarget.path),
                    navigationTarget: targetContext.navigationTarget,
                  ),
                );
              },
            ),
          ),
          const VerticalDivider(
            color: Colors.blueGrey,
          ),
          Flexible(
            flex: 2,
            child: Consumer(
              builder: (context, ref, child) {
                TargetState targetState = ref.watch(targetStateProvider);
                QueryState queryState = ref.watch(queryStateProvider);
                debugPrint("ReSpawn DocumentBody for ${targetState.navigationTarget.title} ${queryState.queryString} ");
                Widget returnWidget = queryState.queryString.isEmpty
                    ? const EmptyPage(
                        key: ValueKey("MT"),
                      )
                    : DocumentBody(
                        key: ValueKey(queryState.queryString),
                        queryState: queryState,
                      );
                // return returnWidget;
                return AnimatedSwitcher(
                  key: ValueKey("query_${key.toString()}"),
                  duration: const Duration(milliseconds: 250),
                  child: returnWidget,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
