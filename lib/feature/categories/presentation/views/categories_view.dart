import 'package:atele_seller/core/functions/custom_appbar.dart';
import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:atele_seller/feature/categories/presentation/widgets/category_item_builder.dart';
import 'package:flutter/material.dart';
class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
   
      appBar: customAppBar(title: AppStrings.categories, ),
      body: const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CategoryItemBuilder(),
          )
        ],
      ),
    );
  }
}
