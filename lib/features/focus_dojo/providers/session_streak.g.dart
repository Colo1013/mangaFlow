// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_streak.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(streakMangas)
final streakMangasProvider = StreakMangasProvider._();

final class StreakMangasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Manga>>,
          List<Manga>,
          FutureOr<List<Manga>>
        >
    with $FutureModifier<List<Manga>>, $FutureProvider<List<Manga>> {
  StreakMangasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakMangasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakMangasHash();

  @$internal
  @override
  $FutureProviderElement<List<Manga>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Manga>> create(Ref ref) {
    return streakMangas(ref);
  }
}

String _$streakMangasHash() => r'1d1ccf3b97a5178960e8dfdc4c52a43eb51f8b1b';
