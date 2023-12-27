// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$collectionPagingRepositoryHash() =>
    r'cae06586f496bd751e99f461a890e48b4cdc96ee';

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

/// See also [collectionPagingRepository].
@ProviderFor(collectionPagingRepository)
const collectionPagingRepositoryProvider = CollectionPagingRepositoryFamily();

/// See also [collectionPagingRepository].
class CollectionPagingRepositoryFamily
    extends Family<CollectionPagingRepository<Task>> {
  /// See also [collectionPagingRepository].
  const CollectionPagingRepositoryFamily();

  /// See also [collectionPagingRepository].
  CollectionPagingRepositoryProvider call(
    CollectionParam<Task> query,
  ) {
    return CollectionPagingRepositoryProvider(
      query,
    );
  }

  @override
  CollectionPagingRepositoryProvider getProviderOverride(
    covariant CollectionPagingRepositoryProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'collectionPagingRepositoryProvider';
}

/// See also [collectionPagingRepository].
class CollectionPagingRepositoryProvider
    extends AutoDisposeProvider<CollectionPagingRepository<Task>> {
  /// See also [collectionPagingRepository].
  CollectionPagingRepositoryProvider(
    CollectionParam<Task> query,
  ) : this._internal(
          (ref) => collectionPagingRepository(
            ref as CollectionPagingRepositoryRef,
            query,
          ),
          from: collectionPagingRepositoryProvider,
          name: r'collectionPagingRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$collectionPagingRepositoryHash,
          dependencies: CollectionPagingRepositoryFamily._dependencies,
          allTransitiveDependencies:
              CollectionPagingRepositoryFamily._allTransitiveDependencies,
          query: query,
        );

  CollectionPagingRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final CollectionParam<Task> query;

  @override
  Override overrideWith(
    CollectionPagingRepository<Task> Function(
            CollectionPagingRepositoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CollectionPagingRepositoryProvider._internal(
        (ref) => create(ref as CollectionPagingRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<CollectionPagingRepository<Task>> createElement() {
    return _CollectionPagingRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionPagingRepositoryProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CollectionPagingRepositoryRef
    on AutoDisposeProviderRef<CollectionPagingRepository<Task>> {
  /// The parameter `query` of this provider.
  CollectionParam<Task> get query;
}

class _CollectionPagingRepositoryProviderElement
    extends AutoDisposeProviderElement<CollectionPagingRepository<Task>>
    with CollectionPagingRepositoryRef {
  _CollectionPagingRepositoryProviderElement(super.provider);

  @override
  CollectionParam<Task> get query =>
      (origin as CollectionPagingRepositoryProvider).query;
}

String _$taskControllerHash() => r'e905b69a5ab79b9d3b44a2e5b82cbbf08134c8a6';

/// See also [TaskController].
@ProviderFor(TaskController)
final taskControllerProvider =
    AutoDisposeAsyncNotifierProvider<TaskController, List<Task>>.internal(
  TaskController.new,
  name: r'taskControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskController = AutoDisposeAsyncNotifier<List<Task>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
