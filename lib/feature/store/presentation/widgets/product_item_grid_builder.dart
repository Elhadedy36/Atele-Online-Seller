import 'package:atele_seller/core/models/product_model.dart';
import 'package:atele_seller/feature/store/presentation/widgets/product_item.dart';
import 'package:flutter/material.dart';


class ProductItemGridBuilder extends StatelessWidget {
  const ProductItemGridBuilder({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        mainAxisExtent: 350,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductItem(product: product);
      },
    );
  }
}
