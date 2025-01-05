
import 'package:atele_seller/core/functions/custom_appbar.dart';
import 'package:atele_seller/core/models/product_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

class ItemView extends StatelessWidget {
  const ItemView({super.key, required this.product});
final ProductModel product;
  @override
  Widget build(BuildContext context) {
        if (product == null) {
          return Scaffold(
            appBar: customAppBar(title: 'Product Details',),
            body: Center(
              child: Text(
                'No product data available',
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          );
        }

        return Scaffold(
          endDrawer: const Drawer(),
          appBar: customAppBar(title: 'Product Details',),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      items: product.productImages.map((imageUrl) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: PhotoView(
                                  imageProvider: NetworkImage(imageUrl),
                                  backgroundDecoration: const BoxDecoration(
                                      color: Colors.transparent),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(imageUrl),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 280.h,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    Positioned(
                      bottom: 20.h,
                      left: 16.w,
                      child: Text(
                        product.productName,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(2, 2),
                                blurRadius: 6)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Description',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.blueGrey.shade200),
                        ),
                        child: Text(
                          product.productDescription,
                          style: TextStyle(
                              fontSize: 16.sp,
                              height: 1.5,
                              color: Colors.grey[800]),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stock Available:',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      Text(
                        product.stock > 0
                            ? '${product.stock} items'
                            : 'Out of Stock',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                product.stock > 0 ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4))
                    ],
                  ),
                 
                ),
              ],
            ),
          ),
        );
     
  }
}
