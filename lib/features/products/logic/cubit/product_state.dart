part of 'product_cubit.dart';

class ProductState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<ProductModel> products;
  final ProductModel? selected;

  const ProductState({
    required this.isLoading,
    required this.error,
    required this.products,
    required this.selected,
  });

  const ProductState.initial()
      : isLoading = false,
        error = null,
        products = const [],
        selected = null;

  const ProductState.loading()
      : isLoading = true,
        error = null,
        products = const [],
        selected = null;

  const ProductState.success(List<ProductModel> list)
      : isLoading = false,
        error = null,
        products = list,
        selected = null;

  const ProductState.detail(ProductModel product)
      : isLoading = false,
        error = null,
        products = const [],
        selected = product;

  const ProductState.error(this.error)
      : isLoading = false,
        products = const [],
        selected = null;

  @override
  List<Object?> get props => [isLoading, error, products, selected];
}
