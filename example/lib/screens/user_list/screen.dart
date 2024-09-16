// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:fframe/components/advanced_data_table/advanced_data_table.dart';
import 'user_data.dart';

import 'package:example/models/appuser.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool isAscending = false;

  TUser user = TUser();

  @override
  Widget build(BuildContext context) {
    return AdvancedDataTable<AppUser>(
        headerSticky: true,
        columnWidths: const [100, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200],
        headerWidgets: const [
          Text("index"),
          Text("name"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
          Text("email"),
        ],
        footerWidgets: const [Text("index"), Text("name"), Text("email")],
        data: [
          AppUser(uid: '123', displayName: 'Je moeder', active: true, customClaims: null, creationDate: null, email: 'a@a.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
          AppUser(uid: '456', displayName: 'Je oma', active: true, customClaims: null, creationDate: null, email: 'b@b.nl'),
        ],
        cellsForRowAtIndex: <int, AppUser>(index, user) => [
              Text("${user.uid}"),
              Text("${user.displayName}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              Text("${user.email}"),
              // Text("$index  ${user!.uid}"),
              // Text("$index  ${user!.email}"),
            ]);

    // user.initData(100);
    // return HorizontalDataTable(
    //     leftHandSideColumnWidth: 200,
    //     rightHandSideColumnWidth: 31*200,
    //     isFixedHeader: true,
    //     headerWidgets: _getTitleWidget(),
    //     isFixedFooter: true,
    //     footerWidgets: _getTitleWidget(),
    //     leftSideItemBuilder: _generateFirstColumnRow,
    //     rightSideItemBuilder: _generateRightHandSideColumnRow,
    //     itemCount: user.userInfo.length,
    //     rowSeparatorWidget: const Divider(
    //       color: Colors.black38,
    //       height: 1.0,
    //       thickness: 0.0,
    //     ),
    //     leftHandSideColBackgroundColor: Theme.of(context).colorScheme.onPrimary,
    //     rightHandSideColBackgroundColor: Theme.of(context).colorScheme.onPrimary,
    // );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Column1', 200),
      _getTitleItemWidget('Column2', 200),
      _getTitleItemWidget('Column3', 200),
      _getTitleItemWidget('Column4', 200),
      _getTitleItemWidget('Column5', 200),
      _getTitleItemWidget('Column6', 200),
      _getTitleItemWidget('Column7', 200),
      _getTitleItemWidget('Column8', 200),
      _getTitleItemWidget('Column9', 200),
      _getTitleItemWidget('Column10', 200),
      _getTitleItemWidget('Column11', 200),
      _getTitleItemWidget('Column12', 200),
      _getTitleItemWidget('Column13', 200),
      _getTitleItemWidget('Column14', 200),
      _getTitleItemWidget('Column15', 200),
      _getTitleItemWidget('Column16', 200),
      _getTitleItemWidget('Column17', 200),
      _getTitleItemWidget('Column18', 200),
      _getTitleItemWidget('Column19', 200),
      _getTitleItemWidget('Column20', 200),
      _getTitleItemWidget('Column21', 200),
      _getTitleItemWidget('Column22', 200),
      _getTitleItemWidget('Column23', 200),
      _getTitleItemWidget('Column24', 200),
      _getTitleItemWidget('Column25', 200),
      _getTitleItemWidget('Column26', 200),
      _getTitleItemWidget('Column27', 200),
      _getTitleItemWidget('Column28', 200),
      _getTitleItemWidget('Column29', 200),
      _getTitleItemWidget('Column30', 200),
      _getTitleItemWidget('Column31', 200),
      _getTitleItemWidget('Column32', 200),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 200,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: const Text("Cell1"), // user.userInfo[index].name
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text("Cell2"),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell3'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell4'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell5'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell6'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell7'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell8'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell9'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell10'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell11'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell12'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell13'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell14'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell15'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell16'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell17'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell18'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell19'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell20'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell21'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell22'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell23'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell24'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell25'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell26'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell27'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell28'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell29'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell30'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell31'),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const Text('Cell32'),
        ),
      ],
    );
  }
}
