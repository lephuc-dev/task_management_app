import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../resources/resources.dart';
import '../../../widgets/widgets.dart';

class OptionItem extends StatelessWidget {
  final String title;
  final String icon;
  final void Function() onTap;
  final bool isHaveBorder;

  const OptionItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isHaveBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellWrapper(
      paddingChild: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: isHaveBorder ? const Border(bottom: BorderSide(width: 1, color: AppColors.neutral99)) : null,
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            color: AppColors.primaryBlack,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
          )
        ],
      ),
    );
  }
}
