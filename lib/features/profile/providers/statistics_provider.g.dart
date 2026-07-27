// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileStatistics)
final profileStatisticsProvider = ProfileStatisticsProvider._();

final class ProfileStatisticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileStatistics>,
          ProfileStatistics,
          FutureOr<ProfileStatistics>
        >
    with
        $FutureModifier<ProfileStatistics>,
        $FutureProvider<ProfileStatistics> {
  ProfileStatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileStatisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileStatisticsHash();

  @$internal
  @override
  $FutureProviderElement<ProfileStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProfileStatistics> create(Ref ref) {
    return profileStatistics(ref);
  }
}

String _$profileStatisticsHash() => r'e809105bcfc02eb5f2f32221242bc81f719cbf8f';
