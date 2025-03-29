import 'package:flutter/cupertino.dart';
import 'package:smart_cane_app/app/AppColors.dart';

class TitleText extends StatelessWidget {
  final String title;

  const TitleText({super.key,required this.title});


  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
      color: AppColors.mainColor,
      fontSize: 48,
      fontWeight: FontWeight.bold
    ),);
  }
}
