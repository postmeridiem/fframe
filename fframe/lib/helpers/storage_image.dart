import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// StorageImage is a custom widget that allows to get a image from firebase storage
class StorageImage extends StatelessWidget {
  const StorageImage({
    super.key,
    required this.bucketName,
    required this.filePath,
  });

  final String bucketName;
  final String filePath;
  @override
  Widget build(BuildContext context) {
    final gsReference =
        FirebaseStorage.instance.refFromURL("gs://$bucketName/$filePath");
    return FutureBuilder(
      future: gsReference.getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Icon(Icons.warning,
                  color: Theme.of(context).colorScheme.error),
            );
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  Text(snapshot.error!.toString()),
                ],
              );
            }
            try {
              final Uint8List data = snapshot.data;
              return Image.memory(data);
            } catch (error) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  Text(error.toString()),
                ],
              );
            }
        }
      },
    );
  }
}
