import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/features/auth/data/models/user_model.dart';
import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:food_app/features/auth/presentation/views/login_view.dart';
import 'package:food_app/features/auth/presentation/views/signup_view.dart';
import 'package:food_app/features/auth/presentation/views/widgets/custom_material_button.dart';
import 'package:food_app/features/auth/presentation/views/widgets/text_field_profile.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/utils/pref_helper.dart';
import '../managers/profile_cubit/profile_cubit.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController visaController = TextEditingController();
  String? selectedImagePath;
  bool isLogout = false;

  Future pickImage() async {
    final pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      setState(() {
        selectedImagePath = pickImage.path;
      });
    }
  }

  @override
  void initState() {
    nameController.text = 'Not found';
    emailController.text = 'Not found';
    addressController.text = 'Not found';
    visaController.text = 'Not found';

    context.read<ProfileCubit>().getProfileData();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    visaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Center(
                  child: Text(
                'Unable to get your profile data because ${state.apiError.message}',
                style: TextStyle(color: Colors.white),
              ))));
          log('ProfileFailure');
          log(state.apiError.message);
          nameController.text = 'Not Found';
          emailController.text = 'Not Found';
          addressController.text = 'Not Found';
          visaController.text = 'Not Found';
        } else if (state is ProfileSuccess) {
          if (state.userModel?.image != null) {
            setState(() {
              selectedImagePath = state.userModel?.secureImageUrl;
            });
          }
          nameController.text = state.userModel?.name ?? '';
          emailController.text = state.userModel?.email ?? '';
          addressController.text = state.userModel?.address ?? '';
          visaController.text = state.userModel?.visa ?? '';
        } else if (state is ProfileLoading) {
          log('Profile Loading ...');
        }
      },
      builder: (context, state) {
        return Skeletonizer(
          enabled: state is ProfileLoading,
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: () {
              return context.read<ProfileCubit>().getProfileData();
            },
            child: Scaffold(
              backgroundColor: AppColors.primaryColor,
              appBar: AppBar(
                automaticallyImplyActions: false,
                backgroundColor: AppColors.primaryColor,
              ),

              ///body
              body: AuthRepo.isGuest == false
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: 20,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await pickImage();
                                  onTap();
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                  child: selectedImagePath != null
                                      ? ClipOval(
                                          child: selectedImagePath!
                                                  .startsWith('http')
                                              ? Image.network(
                                                  selectedImagePath!,
                                                  fit: BoxFit.cover,
                                                  width: 100,
                                                  height: 100,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Icon(
                                                      CupertinoIcons
                                                          .profile_circled,
                                                      color: Colors.white,
                                                      size: 80,
                                                    );
                                                  },
                                                )
                                              : Image.file(
                                                  File(selectedImagePath!),
                                                  fit: BoxFit.cover,
                                                  width: 100,
                                                  height: 100,
                                                ),
                                        )
                                      : Icon(
                                          CupertinoIcons.profile_circled,
                                          color: Colors.white,
                                          size: 80,
                                        ),
                                ),
                              ),
                              CustomMaterialButton(
                                buttonName: 'Upload photo',
                                onPressed: () async {
                                  await pickImage();
                                  onTap();
                                  log('image path is $selectedImagePath');
                                },
                                color: Colors.white,
                                textColor: AppColors.primaryColor,
                                width: 140,
                              ),
                              TextFieldProfile(
                                labelText: ' Name ',
                                controller: nameController,
                              ),
                              TextFieldProfile(
                                labelText: ' Email ',
                                controller: emailController,
                              ),
                              TextFieldProfile(
                                labelText: 'Address',
                                controller: addressController,
                              ),
                              TextFieldProfile(
                                labelText: ' Visa number',
                                controller: visaController,
                              ),
                              Divider(),
                              ListTile(
                                  minTileHeight: 70,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  tileColor: Colors.white,
                                  leading: Image.asset(
                                    'assets/images/visa_profile1x.png',
                                    width: 50,
                                  ),
                                  title: Text(
                                    'Debit card',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    visaController.text.isEmpty
                                        ? 'No visa added'
                                        : visaController.text,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  trailing: Text(
                                    'default',
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 16),
                                  )),
                              Gap(50),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomMaterialButton(
                          buttonName: 'Go to Signup',
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return SignupView();
                            }));
                          },
                          color: Colors.white,
                          textColor: AppColors.primaryColor,
                        ),
                      ),
                    ),

              ///bottom sheet
              bottomSheet: AuthRepo.isGuest == false
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        color: Colors.white,
                      ),
                      height: 70,
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: GestureDetector(
                              onTap: onTap,
                              child: Row(
                                children: [
                                  Text(
                                    'Edit profile ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Icon(CupertinoIcons.pencil,
                                      color: Colors.white, size: 23),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.primaryColor, width: 2),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                context.read<ProfileCubit>().logout();
                                final token = PrefHelper.getToken();
                                if (state is ProfileSuccess ||
                                    token == 'guest') {
                                  await PrefHelper.removeToken();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginView();
                                  }));
                                } else if (state is ProfileFailure) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Center(
                                              child: Text(
                                            'Logout failure please try again',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))));
                                }
                              },
                              child: state is ProfileLoading
                                  ? CupertinoActivityIndicator()
                                  : Row(
                                      children: [
                                        Text(
                                          'Sign out ',
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Icon(Icons.exit_to_app_outlined,
                                            color: AppColors.primaryColor,
                                            size: 23),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        );
      },
    );
  }

  void Function()? onTap() {
    final updatedUser = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      visa: visaController.text.trim(),
      image: selectedImagePath,
    );
    context.read<ProfileCubit>().updateProfile(user: updatedUser);
  }
}
