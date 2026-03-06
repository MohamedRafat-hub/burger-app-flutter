import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/features/product/presentation/widgets/topping_card.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/managers/topping_cubit/get_toppings_cubit.dart';

class DisplayToppings extends StatefulWidget {
   DisplayToppings({
    super.key,
  });
  final List<int> selectedToppings = [];
  @override
  State<DisplayToppings> createState() => _DisplayToppingsState();
}

class _DisplayToppingsState extends State<DisplayToppings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetToppingsCubit, GetToppingsState>(
      builder: (context, state) {
        if (state is GetToppingsSuccess) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: List.generate(
                  state.toppings.length,
                  (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.selectedToppings.contains(index+1)) {
                              widget.selectedToppings.remove(index+1);
                            } else {
                              widget.selectedToppings.add(index+1);
                            }
                          });
                        },
                        child: ToppingCard(
                          selected:
                              widget.selectedToppings.contains(index+1) ? true : false,
                          color: widget.selectedToppings.contains(index+1)
                              ? Color(0xFFD9ECD9)
                              : Colors.white,
                          toppingModel: state.toppings[index],
                        ),
                      )),
            ),
          );
        } else if (state is GetToppingsLoading) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ));
        } else if (state is GetToppingsFailure) {
          return Text(
            textAlign: TextAlign.center,
            '${state.apiError.message}',
            style: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.w700),
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
