import 'package:atele_seller/feature/categories/data/model/category_model.dart';
import 'package:atele_seller/feature/categories/presentation/widgets/category_item.dart';
import 'package:atele_seller/feature/store/presentation/cubit/cubit/products_cubit.dart';
import 'package:atele_seller/feature/store/presentation/views/StoreView.dart';
import 'package:atele_seller/feature/store/presentation/widgets/Store_Tab_View_Builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryItemBuilder extends StatelessWidget {
  const CategoryItemBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categmodel.length,
      itemBuilder: (context, index) {
        return CategoryItem(
          categmodel: categmodel[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return BlocProvider(
                  create: (context) => ProductsCubit(),
                  child: StoreTabViewBuilder(
                    selectedCategory: categmodel[index],
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}
