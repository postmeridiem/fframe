part of '../../fframe.dart';

/// Opens a document by id in the [DocumentScreen] on screen, without a page load.
///
/// An app asks through [FRouter.openDocument]. The request runs after the current
/// frame. So when the app rebuilds its screen just before the call (for example with
/// another query, other rights or other statuses), the document opens with the config
/// of that new build.
///
/// While a [DocumentScreen] is mounted, it registers a reader here. Embedded
/// DocumentScreens do not. The reader reads the document with the config of the
/// screen's latest build, and hands back a callback that opens it as a list or lane
/// click does: `preOpen` runs and the link gets the id. If more than one screen is
/// mounted, the one mounted last is used.
///
/// One request is kept at a time, and a new request replaces an older one. A request
/// made while no DocumentScreen is mounted waits for the next screen that mounts. A
/// request runs once: when the read finds no document, has no access or fails, the
/// request is dropped, and no later build tries it again.
class DocumentOpener {
  DocumentOpener._();

  static final List<_DocumentOpenerReader> _readers = [];
  static String? _pendingId;
  static Completer<bool>? _pendingResult;
  static int _latestRequest = 0;
  static bool _scheduled = false;

  /// Asks to open document [id] in the DocumentScreen on screen.
  ///
  /// The future completes with true when the document has opened. It completes with
  /// false when the document does not exist, cannot be read, or a newer request
  /// replaced this one.
  static Future<bool> open(String id) {
    Console.log("Open document $id in the DocumentScreen on screen", scope: "fframeLog.DocumentOpener.open", level: LogLevel.fframe);
    _latestRequest++;
    _pendingResult?.complete(false);
    _pendingId = id;
    final Completer<bool> result = _pendingResult = Completer<bool>();
    // A page-load link that no DocumentScreen has opened yet is older than this
    // request. Without this, a loader that starts later would open that link too.
    SelectionState.instance.pendingUri = null;
    _schedule();
    return result.future;
  }

  /// Called by a [DocumentScreen] when it mounts. An app does not need to call this.
  ///
  /// [read] reads the document with the config of the screen's latest build. It
  /// returns a callback that opens the document, or null when there is no document.
  /// The registration stays until [unregister] is called with the same [owner].
  static void register(Object owner, Future<VoidCallback?> Function(String id) read) {
    _readers.add(_DocumentOpenerReader(owner: owner, read: read));
    if (_pendingId != null) _schedule();
  }

  /// Removes the reader of [owner] only. A screen that a rebuild replaces is
  /// disposed after the new screen has registered, and must not remove that one.
  static void unregister(Object owner) {
    _readers.removeWhere((_DocumentOpenerReader reader) => identical(reader.owner, owner));
  }

  @visibleForTesting
  static void reset() {
    _readers.clear();
    _pendingId = null;
    _pendingResult = null;
    _latestRequest = 0;
    _scheduled = false;
  }

  static void _schedule() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      _run();
    });
    // Without this, no frame comes when nothing else changed.
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  static Future<void> _run() async {
    final String? id = _pendingId;
    // With no screen mounted, the request waits. register() schedules it again.
    if (id == null || _readers.isEmpty) return;
    final Completer<bool> result = _pendingResult!;
    final int request = _latestRequest;
    _pendingId = null;
    _pendingResult = null;

    VoidCallback? openDocument;
    try {
      openDocument = await _readers.last.read(id);
    } catch (error) {
      Console.log("Document $id could not be read: $error", scope: "fframeLog.DocumentOpener", level: LogLevel.dev);
    }

    if (request != _latestRequest) {
      // A newer request came in during the read.
      result.complete(false);
      return;
    }
    if (openDocument == null) {
      Console.log("Document $id was not opened", scope: "fframeLog.DocumentOpener", level: LogLevel.dev);
      result.complete(false);
      return;
    }
    openDocument();
    result.complete(true);
  }
}

class _DocumentOpenerReader {
  const _DocumentOpenerReader({required this.owner, required this.read});

  final Object owner;
  final Future<VoidCallback?> Function(String id) read;
}
