import 'package:atele_seller/core/functions/custom_appbar.dart';
import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      appBar: customAppBar(
        title: AppStrings.home,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter()
           ]),
      ),
    );
  }
}
