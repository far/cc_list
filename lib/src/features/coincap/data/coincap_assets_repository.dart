import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coincap_list/src/env/env.dart';
import 'package:coincap_list/src/features/coincap/domain/coincap_assets_response.dart';
import 'package:coincap_list/src/utils/dio_provider.dart';

part 'coincap_assets_repository.g.dart';

typedef AssetsQueryData = ({int page, int pageSize});

class AssetsRepository {
  const AssetsRepository({required this.client, required this.apiKey});
  final Dio client;
  final String apiKey;

  Future<CoinCapResponse> getAssets({
    required int page,
    required int pageSize,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'rest.coincap.io',
      path: 'v3/assets',
      queryParameters: {
        'limit': pageSize.toString(),
        'offset': ((page - 1) * pageSize).toString(),
      },
    );
    final response = await client.getUri(
      uri,
      options: Options(headers: {"Authorization": "Bearer $apiKey"}),
      cancelToken: cancelToken,
    );
    return CoinCapResponse.fromJson(response.data);
  }
}

@riverpod
AssetsRepository assetsRepository(Ref ref) =>
    AssetsRepository(client: ref.watch(dioProvider), apiKey: Env.coincapApiKey);

/// Assets provider
@riverpod
Future<CoinCapResponse> fetchAssets(
  Ref ref, {
  required AssetsQueryData queryData,
}) async {
  final assetsRepo = ref.watch(assetsRepositoryProvider);
  // cancel page request if UI no longer needs it
  final cancelToken = CancelToken();
  // when page is no longer used - keep it in the cache
  final link = ref.keepAlive();
  // a timer to be used by the callbacks below
  Timer? timer;
  // cancel http request and the imer when provider is destroyed
  ref.onDispose(() {
    cancelToken.cancel();
    timer?.cancel();
  });
  // when last listener is removed - start timer to dispose the cached data
  ref.onCancel(() {
    timer = Timer(const Duration(seconds: 30), () {
      // dispose on timeout
      link.close();
    });
  });
  // cancel timer on resume
  ref.onResume(() {
    timer?.cancel();
  });
  return assetsRepo.getAssets(
    page: queryData.page,
    pageSize: queryData.pageSize,
    cancelToken: cancelToken,
  );
}
