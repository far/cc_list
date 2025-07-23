import 'package:freezed_annotation/freezed_annotation.dart';

part 'coincap_asset.freezed.dart';
part 'coincap_asset.g.dart';

@freezed
abstract class Asset with _$Asset {
  factory Asset({required String symbol, required String priceUsd}) =
      _AssetBasic;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
