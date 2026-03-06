import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/features/product/data/managers/side_option_cubit/side_options_cubit.dart';
import 'package:food_app/features/product/presentation/widgets/topping_card.dart';
import '../../../../core/constants/app_colors.dart';

class DisplaySideOptions extends StatefulWidget {
   DisplaySideOptions({
    super.key,
  });
  List<int> options = [];
  @override
  State<DisplaySideOptions> createState() => _DisplaySideOptionsState();
}

class _DisplaySideOptionsState extends State<DisplaySideOptions> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SideOptionsCubit, SideOptionsState>(
      builder: (context, state) {
        if (state is SideOptionsSuccess) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: List.generate(
                  state.toppings.length,
                  (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.options.contains(index+1)) {
                              widget.options.remove(index+1);
                            } else {
                              widget.options.add(index+1);
                            }
                          });
                        },
                        child: ToppingCard(
                          selected: widget.options.contains(index+1) ? true : false,
                          color: widget.options.contains(index+1)
                              ? Color(0xFFD9ECD9)
                              : Colors.white,
                          toppingModel: state.toppings[index],
                        ),
                      )),
            ),
          );
        } else if (state is SideOptionsLoading) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ));
        } else if (state is SideOptionsFailure) {
          return Text(
            textAlign: TextAlign.center,
            '${state.apiError.message}',
            style: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
          );
        } else {
          return Text(
            'Sorry unable to display toppings now please try later',
            style: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.w700),
          );
        }
      },
    );
  }
}
