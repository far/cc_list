import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AssetListTileShimmer extends StatelessWidget {
  const AssetListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              width: 56.0,
              height: 56.0,
              color: const Color.fromARGB(50, 0, 0, 0),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 17.0,
                color: const Color.fromARGB(50, 0, 0, 0),
              ),
            ),
            Container(
              width: 50.0,
              height: 17.0,
              color: const Color.fromARGB(50, 0, 0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
