import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/model/repositories/firestore/document.dart';
import 'package:untitled_2/utils/logger.dart';

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepository(FirebaseFirestore.instance);
});

class DocumentRepository {
  DocumentRepository(this._firestore);

  final FirebaseFirestore _firestore;

  WriteBatch get batch => _firestore.batch();

  ///データの保存
  Future<void> save(
    String documentPath, {
    required Map<String, dynamic> data,
  }) async {
    final doc = _firestore.doc(documentPath);
    await doc.set(
      data,
      SetOptions(merge: true),
    );
  }

  ///データの更新
  Future<void> update(
    String documentPath, {
    required Map<String, dynamic> data,
  }) async {
    final doc = _firestore.doc(documentPath);
    await doc.update(data);
  }

  ///データの取得
  Future<Document<T>> fetch<T extends Object>(
    String documentPath, {
    Source source = Source.serverAndCache,
    void Function(Document<T>?)? fromCache,
    required T Function(Map<String, dynamic>) decode,
  }) async {
    if (fromCache != null) {
      try {
        final cache = await _firestore
            .doc(documentPath)
            .get(const GetOptions(source: Source.cache));
        fromCache(Document(
          ref: cache.reference,
          exists: cache.exists,
          entity: cache.exists == true ? decode(cache.data()!) : null,
        ));
      } on Exception catch (e) {
        logger.info(e);
        fromCache(null);
      }
    }

    final snap =
        await _firestore.doc(documentPath).get(GetOptions(source: source));
    return Document(
      ref: snap.reference,
      exists: snap.exists,
      entity: snap.exists ? decode(snap.data()!) : null,
    );
  }

  ///データの取得をキャッシュを使用して取得している
  Future<Document<T>> fetchCache<T extends Object>(
    String documentPath, {
    required T Function(Map<String, dynamic>) decode,
  }) async {
    final doc = _firestore.doc(documentPath);
    try {
      final cache = await doc.get(const GetOptions(source: Source.cache));
      if (cache.exists) {
        return Document(
          ref: cache.reference,
          exists: cache.exists,
          entity: cache.exists ? decode(cache.data()!) : null,
        );
      }
    } on Exception catch (_) {
      // logger.info(e);
    }
    final snap = await doc.get(const GetOptions(source: Source.serverAndCache));
    return Document(
      ref: snap.reference,
      exists: snap.exists,
      entity: snap.exists ? decode(snap.data()!) : null,
    );
  }

  Future<Document<T>> fetchCacheOnly<T extends Object>(
    String documentPath, {
    required T? Function(Map<String, dynamic>) decode,
  }) async {
    final doc = _firestore.doc(documentPath);
    try {
      final cache = await doc.get(const GetOptions(source: Source.cache));
      if (cache.exists) {
        // logger.info('fetch from cache');
        return Document(
          ref: cache.reference,
          exists: cache.exists,
          entity: cache.exists ? decode(cache.data()!) : null,
        );
      }
    } on Exception catch (_) {
      // logger.info(e);
    }
    return Document(
      ref: doc,
      entity: null,
      exists: false,
    );
  }

  Future<bool> exists(String documentPath) async {
    final doc = _firestore.doc(documentPath);
    final snap = await doc.get(const GetOptions(source: Source.serverAndCache));
    return snap.exists;
  }

  Future<bool> existsCache(String documentPath) async {
    final doc = _firestore.doc(documentPath);
    try {
      final cache = await doc.get(const GetOptions(source: Source.cache));
      return cache.exists;
    } on Exception catch (_) {
      // logger.info(e);
    }
    final snap = await doc.get(const GetOptions(source: Source.serverAndCache));
    return snap.exists;
  }

  Stream<DocumentSnapshot<SnapType>> snapshots(String documentPath) =>
      _firestore.doc(documentPath).snapshots();

  Future<void> remove(String documentPath) =>
      _firestore.doc(documentPath).delete();

  Future<T> transaction<T>(TransactionHandler<T> transactionHandler) =>
      _firestore.runTransaction<T>(transactionHandler);

  String get docId => _firestore.collection('collection').doc().id;
}
