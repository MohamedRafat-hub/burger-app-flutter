import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/core/network/api_service.dart';
import 'package:food_app/features/auth/data/managers/login_cubit/login_cubit.dart';
import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:food_app/features/auth/presentation/views/signup_view.dart';
import 'package:food_app/features/auth/presentation/views/widgets/custom_material_button.dart';
import 'package:food_app/root.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:gap/gap.dart';

import '../../../../shared/custom_text_form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  final AuthRepo authRepo = AuthRepo(apiService: ApiService());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider(
        create: (context) =>
            LoginCubit(authRepo: AuthRepo(apiService: ApiService())),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  Gap(100),
                  SvgPicture.asset('assets/images/logo.svg',
                      color: AppColors.primaryColor),
                  CustomText(
                      text: 'Welcome back , Login to continue',
                      color: AppColors.primaryColor,
                      size: 16,
                      fontWeight: FontWeight.w600),
                  Gap(70),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Gap(30),
                            CustomTextFormField(
                              controller: _emailController,
                              hint: 'Email Address',
                              isPassword: false,
                            ),
                            Gap(20),
                            CustomTextFormField(
                              controller: _passwordController,
                              hint: 'password',
                              isPassword: true,
                            ),
                            Gap(30),
                            BlocConsumer<LoginCubit, LoginState>(
                              listener: (context, state) {
                                if (state is LoginSuccess) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Root()));
                                } else if (state is LoginFailure) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Center(
                                              child: Text(
                                            state.apiError.message,
                                            style:
                                                TextStyle(color: Colors.white , fontSize: 16 ),
                                          ))));
                                }
                              },
                              builder: (context, state) {
                                return state is LoginLoading
                                    ? CupertinoActivityIndicator(
                                        color: Colors.white,
                                        radius: 15,
                                      )
                                    : CustomMaterialButton(
                                        textColor: AppColors.primaryColor,
                                        buttonName: 'Login',
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<LoginCubit>().login(
                                                email: _emailController.text
                                                    .trim(),
                                                password: _passwordController
                                                    .text
                                                    .trim());
                                          }
                                        },
                                      );
                              },
                            ),
                            Gap(15),
                            CustomMaterialButton(
                              textColor: AppColors.primaryColor,
                              buttonName: 'Go to Signup',
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupView()));
                              },
                            ),
                            Gap(20),
                            GestureDetector(
                              onTap: ()async {
                                await authRepo.continueAsGuest();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Root()));
                              },
                              child: Text(
                                'Continue as a guest',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.54,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
