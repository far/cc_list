import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coincap_list/src/features/coincap/data/coincap_assets_repository.dart';
import 'package:coincap_list/src/features/coincap/presentation/coincap_assets/coincap_asset_list_tile.dart';
import 'package:coincap_list/src/features/coincap/presentation/coincap_assets/coincap_asset_list_tile_shimmer.dart';

class AssetsSearchScreen extends ConsumerWidget {
  const AssetsSearchScreen({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AssetsSearchScreen());
  }

  static const pageSize = 15;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // dispose all pages previously fetched
                // next read will refresh them
                ref.invalidate(fetchAssetsProvider);
                try {
                  await ref.read(
                    fetchAssetsProvider(
                      queryData: (page: 1, pageSize: pageSize),
                    ).future,
                  );
                } catch (e) {
                  // provider error state handled inside ListView
                }
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final page = index ~/ pageSize + 1;
                  final indexInPage = index % pageSize;
                  final responseAsync = ref.watch(
                    fetchAssetsProvider(
                      queryData: (page: page, pageSize: pageSize),
                    ),
                  );

                  return responseAsync.when(
                    error: (err, stack) => AssetListTileError(
                      page: page,
                      pageSize: pageSize,
                      indexInPage: indexInPage,
                      error: err.toString(),
                      isLoading: responseAsync.isLoading,
                    ),
                    loading: () => const AssetListTileShimmer(),
                    data: (response) {
                      if (indexInPage >= response.data.length) {
                        return null;
                      }
                      final asset = response.data[indexInPage];

                      return AssetListTile(
                        asset: asset,
                        color: Color(
                          int.parse(
                            // opacity (00..FF)
                            '24' +
                                // use asset.symbol instead of asset if
                                // you want constant color
                                asset.hashCode
                                    .toRadixString(16)
                                    .padRight(6, '0')
                                    .substring(0, 6),
                            radix: 16,
                          ),
                        ),
                      );
                      //color: Color(color_s.hashCode));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssetListTileError extends ConsumerWidget {
  const AssetListTileError({
    super.key,
    required this.page,
    required this.pageSize,
    required this.indexInPage,
    required this.isLoading,
    required this.error,
  });
  final int page;
  final int pageSize;
  final int indexInPage;
  final bool isLoading;
  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return indexInPage == 0
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 14.0,
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(error),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // invalidate provider for the errored page
                          ref.invalidate(
                            fetchAssetsProvider(
                              queryData: (page: page, pageSize: pageSize),
                            ),
                          );
                          // wait until the page is loaded again
                          return ref.read(
                            fetchAssetsProvider(
                              queryData: (page: page, pageSize: pageSize),
                            ).future,
                          );
                        },
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
