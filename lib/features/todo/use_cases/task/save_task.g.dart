// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_task.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saveTaskHash() => r'a06cff29233c84715830942f8d54148d2eeb2c4d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SaveTask extends BuildlessAutoDisposeAsyncNotifier<Task?> {
  late final String title;
  late final String comment;

  FutureOr<Task?> build({
    required String title,
    required String comment,
  });
}

/// See also [SaveTask].
@ProviderFor(SaveTask)
const saveTaskProvider = SaveTaskFamily();

/// See also [SaveTask].
class SaveTaskFamily extends Family<AsyncValue<Task?>> {
  /// See also [SaveTask].
  const SaveTaskFamily();

  /// See also [SaveTask].
  SaveTaskProvider call({
    required String title,
    required String comment,
  }) {
    return SaveTaskProvider(
      title: title,
      comment: comment,
    );
  }

  @override
  SaveTaskProvider getProviderOverride(
    covariant SaveTaskProvider provider,
  ) {
    return call(
      title: provider.title,
      comment: provider.comment,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'saveTaskProvider';
}

/// See also [SaveTask].
class SaveTaskProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SaveTask, Task?> {
  /// See also [SaveTask].
  SaveTaskProvider({
    required String title,
    required String comment,
  }) : this._internal(
          () => SaveTask()
            ..title = title
            ..comment = comment,
          from: saveTaskProvider,
          name: r'saveTaskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saveTaskHash,
          dependencies: SaveTaskFamily._dependencies,
          allTransitiveDependencies: SaveTaskFamily._allTransitiveDependencies,
          title: title,
          comment: comment,
        );

  SaveTaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.title,
    required this.comment,
  }) : super.internal();

  final String title;
  final String comment;

  @override
  FutureOr<Task?> runNotifierBuild(
    covariant SaveTask notifier,
  ) {
    return notifier.build(
      title: title,
      comment: comment,
    );
  }

  @override
  Override overrideWith(SaveTask Function() create) {
    return ProviderOverride(
      origin: this,
      override: SaveTaskProvider._internal(
        () => create()
          ..title = title
          ..comment = comment,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        title: title,
        comment: comment,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SaveTask, Task?> createElement() {
    return _SaveTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveTaskProvider &&
        other.title == title &&
        other.comment == comment;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, comment.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SaveTaskRef on AutoDisposeAsyncNotifierProviderRef<Task?> {
  /// The parameter `title` of this provider.
  String get title;

  /// The parameter `comment` of this provider.
  String get comment;
}

class _SaveTaskProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SaveTask, Task?>
    with SaveTaskRef {
  _SaveTaskProviderElement(super.provider);

  @override
  String get title => (origin as SaveTaskProvider).title;
  @override
  String get comment => (origin as SaveTaskProvider).comment;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
