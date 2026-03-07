import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/core/network/api_service.dart';
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

  late Animation<Offset> _topImageAnimation;
  late Animation<Offset> _bottomImageAnimation;

  AuthRepo authRepo = AuthRepo(apiService: ApiService());

  bool _isChecking = false;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Root()),
        );
      } else if (AuthRepo.isGuest) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Root()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _topImageAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _bottomImageAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    if (!_isChecking) {
      _isChecking = true;
      Future.delayed(
        const Duration(seconds: 3),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SlideTransition(
                position: _topImageAnimation,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 120,
                ),
              ),

              const Gap(20),

              SlideTransition(
                position: _bottomImageAnimation,
                child: Image.asset(
                  'assets/images/splash.png',
                  height: 220,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}