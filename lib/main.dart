import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/network/api_service.dart';
import 'package:food_app/core/utils/pref_helper.dart';
import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:food_app/features/cart/data/repos/cart_repo.dart';
import 'package:food_app/features/orderHistory/data/managers/getOrders/get_orders_cubit.dart';
import 'package:food_app/splash.dart';

import 'features/auth/presentation/managers/profile_cubit/profile_cubit.dart';
import 'features/cart/presentation/managers/get_cart_products_cubit/get_cart_products_cubit.dart';
import 'features/home/presentation/managers/getProductsCubit/get_products_cubit.dart';
import 'features/home/presentation/managers/get_categories_cubit/get_categories_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PrefHelper.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  CartRepo cartRepo = CartRepo();
  cartRepo.getCartProducts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ProfileCubit(
                  authRepo: AuthRepo(apiService: ApiService()),
                )),
        BlocProvider(create: (context) => GetProductsCubit()),
        BlocProvider(create: (context) => GetCartProductsCubit()),
        BlocProvider(create: (context) => GetCategoriesCubit()),
        BlocProvider(create: (context) => GetOrdersCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.white),
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashView(),
      ),
    );
  }
}


