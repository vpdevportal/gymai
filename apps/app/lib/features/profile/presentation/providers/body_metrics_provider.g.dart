// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_metrics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BodyMetricsNotifier)
const bodyMetricsProvider = BodyMetricsNotifierProvider._();

final class BodyMetricsNotifierProvider
    extends $NotifierProvider<BodyMetricsNotifier, BodyMetrics> {
  const BodyMetricsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyMetricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyMetricsNotifierHash();

  @$internal
  @override
  BodyMetricsNotifier create() => BodyMetricsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BodyMetrics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BodyMetrics>(value),
    );
  }
}

String _$bodyMetricsNotifierHash() =>
    r'1a90b8d48daf90a8776e7493160856f8558b1831';

abstract class _$BodyMetricsNotifier extends $Notifier<BodyMetrics> {
  BodyMetrics build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BodyMetrics, BodyMetrics>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BodyMetrics, BodyMetrics>,
              BodyMetrics,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
