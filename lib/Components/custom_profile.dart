import 'package:flutter/material.dart';
import 'package:quick_pay/Theme/colors.dart';

class CustomDrawerTile extends StatelessWidget {
  final String tileName;
  final Widget tileIcon;
  final VoidCallback? onTap;
  const CustomDrawerTile({Key? key, required this.tileName, required this.tileIcon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                 // tileIcon,
                  SizedBox(width: 15,),
                  Text(tileName, style: Theme.of(context).textTheme.bodyLarge,)
                ],
              ),
              Icon(Icons.arrow_forward_ios,size: 12,),
            ],
          ),
        ),
      ),
    );
  }
}
