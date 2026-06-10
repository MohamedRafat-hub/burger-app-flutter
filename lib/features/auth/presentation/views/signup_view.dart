import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/core/network/api_service.dart';
import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:food_app/features/auth/presentation/views/login_view.dart';
import 'package:food_app/features/auth/presentation/views/widgets/custom_material_button.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:gap/gap.dart';

import '../../../../shared/custom_text_form_field.dart';
import '../managers/signup_cubit/signup_cubit.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider(
        create: (context) =>
            SignupCubit(authRepo: AuthRepo(apiService: ApiService())),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  Gap(100),
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    color: AppColors.primaryColor,
                  ),
                  CustomText(
                      text: 'Create your account',
                      color: AppColors.primaryColor,
                      size: 16,
                      fontWeight: FontWeight.w600),
                  Gap(50),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: AppColors.primaryColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: _nameController,
                              hint: 'Name',
                              isPassword: false,
                            ),
                            Gap(20),
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
                            BlocConsumer<SignupCubit, SignupState>(
                              listener: (context, state) {
                                if (state is SignupSuccess) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginView()));
                                } else if (state is SignupFailure) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Center(
                                              child: Text(
                                            state.apiError.message,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))));
                                }
                              },
                              builder: (context, state) {
                                return state is SignupLoading
                                    ? CupertinoActivityIndicator(
                                        radius: 15,
                                        color: Colors.white,
                                      )
                                    : CustomMaterialButton(
                                        textColor: AppColors.primaryColor,
                                        buttonName: 'Sign Up',
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<SignupCubit>().signup(
                                                name:
                                                    _nameController.text.trim(),
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
                            Gap(20),
                            CustomMaterialButton(
                              textColor: AppColors.primaryColor,
                              buttonName: 'Go to Login ?',
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginView()));
                              },
                            ),
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
