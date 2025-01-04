
import 'package:atele_seller/core/functions/custom_appbar.dart';
import 'package:atele_seller/core/utils/app_colors.dart';
import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:atele_seller/feature/categories/data/model/category_model.dart';
import 'package:atele_seller/feature/store/presentation/views/StoreView.dart';
import 'package:flutter/material.dart';
class StoreTabViewBuilder extends StatelessWidget {
  const StoreTabViewBuilder({super.key, required this.selectedCategory});
final CategoryModel selectedCategory;
  @override
  Widget build(BuildContext context) {
    // Access category from the StoreCubit
   
    if (selectedCategory == null) {
      return Scaffold(
        body: Center(child: Text("No category selected")),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: customAppBar(
          title: AppStrings.weddingDress,
          tabBar: const TabBar(
            indicatorColor: AppColors.primaryColor,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.greyColor,
            tabs: [
              Tab(text: AppStrings.forSale),
              Tab(text: AppStrings.forRent),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // StoreView for Sale
            StoreView(
              isForRent: false,
              categoryName: selectedCategory.categoryName,
            ),
            // StoreView for Rent
            StoreView(
              isForRent: true,
              categoryName: selectedCategory.categoryName,
            ),
          ],
        ),
      ),
    );
  }
}
