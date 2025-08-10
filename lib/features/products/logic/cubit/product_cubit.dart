import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_catalog/core/utils/app_result.dart';
import 'package:product_catalog/features/products/data/models/product_model.dart';
import 'package:product_catalog/features/products/data/repositories/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repo;
  ProductCubit(this._repo) : super(const ProductState.initial());

  Future<void> fetchProducts() async {
    emit(const ProductState.loading());
    final res = await _repo.getProducts();
    switch (res) {
      case AppSuccess<List<ProductModel>>(:final data):
        emit(ProductState.success(data));
      case AppFailure(:final message):
        emit(ProductState.error(message));
    }
  }

  Future<void> fetchProduct(String id) async {
    emit(const ProductState.loading());
    final res = await _repo.getProductById(id);
    switch (res) {
      case AppSuccess<ProductModel>(:final data):
        emit(ProductState.detail(data));
      case AppFailure(:final message):
        emit(ProductState.error(message));
    }
  }
}
