// part of fframe;

// class DataGridScreen<T> extends ConsumerStatefulWidget {
//   const DataGridScreen({
//     this.queryStringIdParam = "id",
//     required this.collection,
//     required this.fromFirestore,
//     required this.toFirestore,
//     required this.dataGridConfig,
//     this.initialQuery,
//     Key? key,
//   }) : super(key: key);

//   final String queryStringIdParam;
//   final String collection;
//   final T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore;
//   final Map<String, Object?> Function(T, SetOptions?) toFirestore;
//   final Query<T> Function(Query<T> query)? initialQuery;
//   final DataGridConfig<T> dataGridConfig;
//   @override
//   _DataGridScreenState createState() => _DataGridScreenState<T>();
// }

// class _DataGridScreenState<T> extends ConsumerState<DataGridScreen<T>> {
//   late Query<T> Function(Query<T> query)? queryBuilder;
//   @override
//   void initState() {
//     queryBuilder = widget.initialQuery;
//     super.initState();
//   }

//   // late ProductNotifier ctr;

//   @override
//   Widget build(BuildContext context) {
//     return FirestoreDataGrid<T>(
//       fireStoreQueryState: FireStoreQueryState(
//         collection: widget.collection,
//         fromFirestore: widget.fromFirestore,
//         initialQuery: widget.initialQuery,
//         listQuery: queryBuilder,
//       ),
//       dataGridConfig: widget.dataGridConfig,
//       // columnLabels: _getDataColumn(context),
//       // dataCells: (T data) => _dataCells(data),
//     );
//   }
// }
