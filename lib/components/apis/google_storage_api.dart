import 'dart:async';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/storage/v1.dart';

class GoogleStorageApi {
  GoogleStorageApi();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[StorageApi.cloudPlatformReadOnlyScope],
  );

  Future<List> bucketlist() async {
    var output = [];

    // get a client
    await _googleSignIn.signInSilently();
    final gcpClient = await _googleSignIn.authenticatedClient();
    var storageClient = StorageApi(gcpClient!);

    // access bucket handlers
    print("Accessing storage buckets");
    var projectbuckets = await storageClient.buckets.list('fframe');

    var bucketItems = projectbuckets.items;
    bucketItems!.forEach((bucket) {
      output.add(bucket.name);
    });

    return output;
  }

  Future<List<String>> list(String bucketname, {int limit = 1000, String delimiter = '/', String prefix = ''}) async {
    List<String> output = [];

    // get a client
    await _googleSignIn.signInSilently();
    final gcpClient = await _googleSignIn.authenticatedClient();
    var storageClient = StorageApi(gcpClient!);

    //access bucket handlers
    print("Accessing storage bucket for 'directory' listing");
    var bucket = await storageClient.objects.list(bucketname, prefix: prefix, maxResults: limit, delimiter: delimiter);

    // listing the prefixes (directories) at this level
    bucket.prefixes!.forEach((prefix) {
      output.add(prefix);
    });

    // listing the files at this level
    var itemlist = bucket.items;
    if (itemlist != null) {
      itemlist.forEach((blobject) {
        output.add(blobject.name!);
      });
    } else {
      output.add("no files found.");
    }

    return output;
  }

  Future<List<String>> dirlist(String bucketname, {int limit = 1000, String delimiter = '/', String prefix = ''}) async {
    List<String> output = [];

    // get a client
    await _googleSignIn.signInSilently();
    final gcpClient = await _googleSignIn.authenticatedClient();
    var storageClient = StorageApi(gcpClient!);

    //access bucket handlers
    print("Listing 'directories'");
    var bucket = await storageClient.objects.list(bucketname, prefix: prefix, maxResults: limit, delimiter: delimiter);

    // listing the prefixes (directories) at this level
    bucket.prefixes!.forEach((prefix) {
      output.add(prefix);
    });

    return output;
  }
}
