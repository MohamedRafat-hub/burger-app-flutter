import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/core/network/api_service.dart';
import 'package:food_app/features/auth/data/managers/profile_cubit/profile_cubit.dart';

import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:food_app/features/auth/presentation/views/login_view.dart';
import 'package:food_app/root.dart';
import 'package:gap/gap.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  AuthRepo authRepo = AuthRepo(apiService: ApiService());

  Future<void> checkLogin() async {
    try {
      final user = await authRepo.autoLogin();
      if (!mounted) return;
      if (user != null) {
        log('User exist');
      } else {
        log('User not exist');
      }

      if (user != null) {
        debugPrint('continue as a user');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Root();
        }));
      } else if (AuthRepo.isGuest) {
        debugPrint('continue as a guest');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Root();
        }));
      } else {
        debugPrint('go to login');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginView();
        }));
      }
    } catch (e) {
      debugPrint('catch go to login');
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginView();
        }));
      }
    }
  }

  bool _isChecking = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    if (!_isChecking) {
      _isChecking = true;
      Future.delayed(
          Duration(seconds: 3),
        checkLogin,
      );

    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          children: [
            const Gap(200),

            /// Logo Animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SvgPicture.asset('assets/images/logo.svg'),
              ),
            ),

            const Spacer(),

            /// Bottom Image Animation
            SlideTransition(
              position: _slideAnimation,
              child: Image.asset('assets/images/splash.png'),
            ),
          ],
        ),
      ),
    );
  }
}
