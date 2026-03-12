// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottomnavindiexnotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BottomNavIndexNotifier)
final bottomNavIndexProvider = BottomNavIndexNotifierProvider._();

final class BottomNavIndexNotifierProvider
    extends $NotifierProvider<BottomNavIndexNotifier, int> {
  BottomNavIndexNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bottomNavIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bottomNavIndexNotifierHash();

  @$internal
  @override
  BottomNavIndexNotifier create() => BottomNavIndexNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$bottomNavIndexNotifierHash() =>
    r'31500fc17756c42b7c5f68a777f1d9c4aa516f06';

abstract class _$BottomNavIndexNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
