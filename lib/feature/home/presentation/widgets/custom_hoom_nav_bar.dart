import 'package:atele_seller/core/utils/app_colors.dart';
import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:atele_seller/feature/addproduct/presentation/cubit/addproduct_cubit.dart';
import 'package:atele_seller/feature/addproduct/presentation/views/add_product_view.dart';
import 'package:atele_seller/feature/categories/presentation/views/categories_view.dart';
import 'package:atele_seller/feature/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

PersistentTabController _controller = PersistentTabController();

class HomeNavBarWidget extends StatelessWidget {
  const HomeNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      items: _navBarsItems(),
      screens: _buildScreens(),
      navBarStyle: NavBarStyle.style12,
      backgroundColor: AppColors.whiteColor,
      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.only(),
      ),
    );
  }
}

List<Widget> _buildScreens() {
  return [
    const HomeView(),
    BlocProvider(
      create: (context) => AddProductCubit(),
      child:  AddProductView(),
    ),
    const CategoriesView()
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: (AppStrings.home),
      activeColorPrimary: AppColors.blackColor,
      inactiveColorPrimary: AppColors.greyColor,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.add,
        size: 35.r,
        color: AppColors.blackColor,
      ),
      title: (AppStrings.home),
      activeColorPrimary: AppColors.blackColor,
      inactiveColorPrimary: AppColors.greyColor,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.category,
        size: 35.r,
        color: AppColors.blackColor,
      ),
      title: (AppStrings.home),
      activeColorPrimary: AppColors.blackColor,
      inactiveColorPrimary: AppColors.greyColor,
    ),
  ];
}
