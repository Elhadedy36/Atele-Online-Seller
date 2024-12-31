import 'package:atele_seller/core/cubits/cubit/shared_data_cubit.dart';
import 'package:atele_seller/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Atele_Seller extends StatelessWidget {
  const Atele_Seller({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocProvider(
            create: (context) => SharedDataCubit(),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: router,
            ),
          );
        });
  }
}
