import 'package:flutter/material.dart';
import 'package:frouter/frouter.dart';
import 'package:intl/intl.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({
    Key? key,
    required this.navigationTarget,
  }) : super(key: key);
  final NavigationTarget navigationTarget;

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  @override
  Widget build(BuildContext context) {
    debugPrint("Rebuild DocumentList");
    return Column(
      key: ValueKey(widget.navigationTarget.path),
      children: [
        const Text("Path"),
        Text("Last build: ${DateFormat('HH:mm:ss').format(DateTime.now())}"),
        Text(widget.navigationTarget.path),
        Expanded(
          child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 1)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (ConnectionState.done == snapshot.connectionState) {
                  return ListView(
                    children: List.generate(
                      25,
                      (index) => Card(
                        child: ListTile(
                          key: ValueKey("$index"),
                          title: Text("${widget.navigationTarget.path}_$index"),
                          onTap: () {
                            FRouter.of(context).updateQueryString(queryParameters: {"id": "$index"}, resetQueryString: true);
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
        )
      ],
    );
  }
}
