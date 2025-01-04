import 'package:atele_seller/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:atele_seller/feature/auth/presentation/views/signin_view.dart';
import 'package:atele_seller/feature/auth/presentation/views/signup_view.dart';
import 'package:atele_seller/feature/home/presentation/views/home_view.dart';
import 'package:atele_seller/feature/home/presentation/widgets/custom_hoom_nav_bar.dart';
import 'package:atele_seller/feature/splash_screen/presentation/view/spalsh_view.dart';
import 'package:atele_seller/feature/store/presentation/views/StoreView.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(routes: [
   GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
            create: (context) => AuthCubit(),
            child: SpalshView(),
          )),
  GoRoute(
      path: '/signin',
      builder: (context, state) => BlocProvider(
            create: (context) => AuthCubit(),
            child: SigninView(),
          )),
           GoRoute(
      path: '/home',
      builder: (context, state) => BlocProvider(
            create: (context) => AuthCubit(),
            child: HomeNavBarWidget(),
          )),

           GoRoute(
    path: '/signup',
    builder: (context, state) => BlocProvider(
      create: (context) => AuthCubit(),
      child: const SignUpView(),
    ),
  ),
         
]);
