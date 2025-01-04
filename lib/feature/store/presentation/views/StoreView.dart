import 'package:atele_seller/core/models/product_model.dart';
import 'package:atele_seller/feature/store/presentation/cubit/cubit/products_cubit.dart';
import 'package:atele_seller/feature/store/presentation/widgets/product_item_grid_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';class StoreView extends StatelessWidget {
  const StoreView({
    super.key,
    required this.categoryName,
    required this.isForRent,
  });

  final String categoryName;
  final bool isForRent;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductModel>>(
      stream: context
          .read<ProductsCubit>()
          .getProductStream(categoryName, isForRent),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.black,
          ));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No products available"));
        }

        final products = snapshot.data!;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProductItemGridBuilder(products: products),
            ),
          ],
        );
      },
    );
  }
}
