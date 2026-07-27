// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(achievements)
final achievementsProvider = AchievementsProvider._();

final class AchievementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Achievement>>,
          List<Achievement>,
          FutureOr<List<Achievement>>
        >
    with
        $FutureModifier<List<Achievement>>,
        $FutureProvider<List<Achievement>> {
  AchievementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'achievementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$achievementsHash();

  @$internal
  @override
  $FutureProviderElement<List<Achievement>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Achievement>> create(Ref ref) {
    return achievements(ref);
  }
}

String _$achievementsHash() => r'284cba135971ce7c6ec3a2062b1c81a7e97e5737';
