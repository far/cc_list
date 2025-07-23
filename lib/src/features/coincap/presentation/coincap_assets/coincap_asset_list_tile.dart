import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:coincap_list/src/features/coincap/domain/coincap_asset.dart';

class AssetListTile extends StatelessWidget {
  const AssetListTile({super.key, required this.asset, required this.color});
  final Asset asset;
  final Color color;
  static const textStyle = TextStyle(
    height: 1.4,
    letterSpacing: 0.41,
    fontFamily: 'SFProSemibold',
    fontSize: 17,
    color: Color(0xFF17171A),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Row(
        children: [
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(asset.symbol, style: textStyle)),
          Text(
            NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(
              // removing tail after 2 decimal digits because of rounding
              double.parse(
                asset.priceUsd.substring(0, asset.priceUsd.indexOf('.') + 3),
              ),
            ),
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
