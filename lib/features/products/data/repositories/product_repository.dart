import 'package:product_catalog/core/network/api_client.dart';
import 'package:product_catalog/core/utils/app_result.dart';
import 'package:product_catalog/features/products/data/models/product_model.dart';

class ProductRepository {
  final ApiClient _api;
  ProductRepository(this._api);

  Future<AppResult<List<ProductModel>>> getProducts() async {
    try {
      final res = await _api.get('/products');
      final list = (res.data as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return AppSuccess(list);
    } catch (e) {
      return const AppFailure('Failed to load products');
    }
  }

  Future<AppResult<ProductModel>> getProductById(String id) async {
    try {
      final res = await _api.get('/products/$id');
      final model = ProductModel.fromJson(res.data as Map<String, dynamic>);
      return AppSuccess(model);
    } catch (e) {
      return const AppFailure('Failed to load product details');
    }
  }
}
