import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_app/features/auth/data/managers/profile_cubit/profile_cubit.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/custom_text.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({
    super.key,
    this.image,
  });

  final String? image;

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  @override
  void initState() {
    context.read<ProfileCubit>().getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return state is ProfileLoading
            ? Center(
                child: CupertinoActivityIndicator(
                radius: 20,
                color: AppColors.primaryColor,
              ))
            : state is ProfileSuccess
                ? Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/images/logo.svg',
                            color: AppColors.primaryColor,
                            height: 35,
                          ),
                          Gap(5),
                          CustomText(
                              text:
                                  'Hello , ${state.userModel?.name ?? 'User'}',
                              color: Color(0xFF6A6A6A),
                              size: 18,
                              fontWeight: FontWeight.w500)
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              radius: 30,
                              child: Icon(
                                CupertinoIcons.person,
                                color: Colors.white,
                              ),
                            ),
                    ],
                  )
                : Center(
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      color: AppColors.primaryColor,
                      height: 35,
                    ),
                  );
      },
    );
  }
}
