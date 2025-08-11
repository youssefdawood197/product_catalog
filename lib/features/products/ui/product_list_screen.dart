import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/features/products/logic/cubit/product_cubit.dart';
import 'package:product_catalog/l10n/app_localizations.dart';

class ProductListScreen extends StatefulWidget {

  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.products)),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.error!),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<ProductCubit>().fetchProducts(),
                      child: Text(loc.retry),
                    )
                  ],
                ),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenUtil().screenWidth > 600 ? 4 : 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final p = state.products[index];
                return InkWell(
                  onTap: () => context.go('/product/${p.id}'),
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: p.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                          SizedBox(height: 4.h),
                          Text("${p.price.toStringAsFixed(2)} ${loc.egp}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
