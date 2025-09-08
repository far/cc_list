import 'package:freezed_annotation/freezed_annotation.dart';
import 'coincap_asset.dart';

part 'coincap_assets_response.freezed.dart';
part 'coincap_assets_response.g.dart';

@freezed
abstract class CoinCapResponse with _$CoinCapResponse {
  const factory CoinCapResponse({required List<Asset> data}) = _CoinCapResponse;

  factory CoinCapResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinCapResponseFromJson(json);
}
