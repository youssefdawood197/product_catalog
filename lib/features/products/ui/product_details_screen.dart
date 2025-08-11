import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_catalog/features/products/logic/cubit/product_cubit.dart';
import 'package:product_catalog/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.details),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/products');
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text(state.error!));
            }
            final p = state.selected;
            if (p == null) return const SizedBox.shrink();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: 220.h,
                      child: CachedNetworkImage(imageUrl: p.image),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(p.title, style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 8.h),
                  Text(p.category, style: Theme.of(context).textTheme.labelMedium),
                  SizedBox(height: 12.h),
                  Text(p.description),
                  SizedBox(height: 16.h),
                  Text('${loc.price}: ${p.price.toStringAsFixed(2)} ${loc.EGP}', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
