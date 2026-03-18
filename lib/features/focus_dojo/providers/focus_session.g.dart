// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FocusSessionNotifier)
final focusSessionProvider = FocusSessionNotifierProvider._();

final class FocusSessionNotifierProvider
    extends $NotifierProvider<FocusSessionNotifier, StatoSchermo> {
  FocusSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusSessionNotifierHash();

  @$internal
  @override
  FocusSessionNotifier create() => FocusSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatoSchermo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatoSchermo>(value),
    );
  }
}

String _$focusSessionNotifierHash() =>
    r'b208f681fda6e6a15f2a7e62b3df8fbc68a39206';

abstract class _$FocusSessionNotifier extends $Notifier<StatoSchermo> {
  StatoSchermo build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StatoSchermo, StatoSchermo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StatoSchermo, StatoSchermo>,
              StatoSchermo,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
