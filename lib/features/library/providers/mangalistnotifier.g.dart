// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mangalistnotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MangaListNotifier)
final mangaListProvider = MangaListNotifierProvider._();

final class MangaListNotifierProvider
    extends $AsyncNotifierProvider<MangaListNotifier, List<Manga>> {
  MangaListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mangaListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mangaListNotifierHash();

  @$internal
  @override
  MangaListNotifier create() => MangaListNotifier();
}

String _$mangaListNotifierHash() => r'9a77fe04168c4a5aad536a5e9df5a55c372e3e90';

abstract class _$MangaListNotifier extends $AsyncNotifier<List<Manga>> {
  FutureOr<List<Manga>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Manga>>, List<Manga>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Manga>>, List<Manga>>,
              AsyncValue<List<Manga>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
