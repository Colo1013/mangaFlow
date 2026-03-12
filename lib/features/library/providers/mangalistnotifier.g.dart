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

String _$mangaListNotifierHash() => r'f14e5146dfb8edf6642a56232fcc01e38810a5ac';

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
