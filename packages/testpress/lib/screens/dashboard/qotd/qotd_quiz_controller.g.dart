// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qotd_quiz_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$qotdQuizControllerHash() =>
    r'6f826f3efd84550b802cbc15029f3900ff22ebba';

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

abstract class _$QotdQuizController
    extends BuildlessAutoDisposeNotifier<QotdQuizState> {
  late final List<QotdDto> questions;
  late final int initialIndex;

  QotdQuizState build({
    required List<QotdDto> questions,
    required int initialIndex,
  });
}

/// See also [QotdQuizController].
@ProviderFor(QotdQuizController)
const qotdQuizControllerProvider = QotdQuizControllerFamily();

/// See also [QotdQuizController].
class QotdQuizControllerFamily extends Family<QotdQuizState> {
  /// See also [QotdQuizController].
  const QotdQuizControllerFamily();

  /// See also [QotdQuizController].
  QotdQuizControllerProvider call({
    required List<QotdDto> questions,
    required int initialIndex,
  }) {
    return QotdQuizControllerProvider(
      questions: questions,
      initialIndex: initialIndex,
    );
  }

  @override
  QotdQuizControllerProvider getProviderOverride(
    covariant QotdQuizControllerProvider provider,
  ) {
    return call(
      questions: provider.questions,
      initialIndex: provider.initialIndex,
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
  String? get name => r'qotdQuizControllerProvider';
}

/// See also [QotdQuizController].
class QotdQuizControllerProvider
    extends AutoDisposeNotifierProviderImpl<QotdQuizController, QotdQuizState> {
  /// See also [QotdQuizController].
  QotdQuizControllerProvider({
    required List<QotdDto> questions,
    required int initialIndex,
  }) : this._internal(
         () => QotdQuizController()
           ..questions = questions
           ..initialIndex = initialIndex,
         from: qotdQuizControllerProvider,
         name: r'qotdQuizControllerProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$qotdQuizControllerHash,
         dependencies: QotdQuizControllerFamily._dependencies,
         allTransitiveDependencies:
             QotdQuizControllerFamily._allTransitiveDependencies,
         questions: questions,
         initialIndex: initialIndex,
       );

  QotdQuizControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.questions,
    required this.initialIndex,
  }) : super.internal();

  final List<QotdDto> questions;
  final int initialIndex;

  @override
  QotdQuizState runNotifierBuild(covariant QotdQuizController notifier) {
    return notifier.build(questions: questions, initialIndex: initialIndex);
  }

  @override
  Override overrideWith(QotdQuizController Function() create) {
    return ProviderOverride(
      origin: this,
      override: QotdQuizControllerProvider._internal(
        () => create()
          ..questions = questions
          ..initialIndex = initialIndex,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        questions: questions,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<QotdQuizController, QotdQuizState>
  createElement() {
    return _QotdQuizControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QotdQuizControllerProvider &&
        other.questions == questions &&
        other.initialIndex == initialIndex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, questions.hashCode);
    hash = _SystemHash.combine(hash, initialIndex.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QotdQuizControllerRef on AutoDisposeNotifierProviderRef<QotdQuizState> {
  /// The parameter `questions` of this provider.
  List<QotdDto> get questions;

  /// The parameter `initialIndex` of this provider.
  int get initialIndex;
}

class _QotdQuizControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<QotdQuizController, QotdQuizState>
    with QotdQuizControllerRef {
  _QotdQuizControllerProviderElement(super.provider);

  @override
  List<QotdDto> get questions =>
      (origin as QotdQuizControllerProvider).questions;
  @override
  int get initialIndex => (origin as QotdQuizControllerProvider).initialIndex;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
