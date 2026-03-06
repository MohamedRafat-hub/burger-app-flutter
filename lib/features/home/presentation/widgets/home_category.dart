import 'package:flutter/material.dart';
import 'package:food_app/features/home/data/models/category_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/custom_text.dart';

class HomeCategory extends StatefulWidget {
  HomeCategory(
      {super.key,  this.categories, required this.onCategorySelected});

  final List<CategoryModel>? categories;
   int selectedIndex =-1;
  final Function(int) onCategorySelected;

  @override
  State<HomeCategory> createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.categories!.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedIndex = index;
              });
              widget.onCategorySelected(index);
            },
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 15),
              decoration: BoxDecoration(
                color: index == widget.selectedIndex
                    ? AppColors.primaryColor
                    : Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomText(
                  text: widget.categories![index].categoryName,
                  color: index == widget.selectedIndex
                      ? Colors.white
                      : Colors.grey.shade700,
                  size: 16,
                  fontWeight: FontWeight.w400),
            ),
          );
        }),
      ),
    );
  }
}


