import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customIcon(
    BuildContext context, {
      IconData icon,
      bool isEnable = false,
      double size = 18,
      bool istwitterIcon = true,
      bool isFontAwesomeSolid = false,
      Color iconColor,
      double paddingIcon = 10,
    }) {
  iconColor = iconColor ?? Theme.of(context).textTheme.caption.color;
  return Padding(
    padding: EdgeInsets.only(bottom: istwitterIcon ? paddingIcon : 0),
    child: Icon(
      icon,
      size: size,
      color: isEnable ? Theme.of(context).primaryColor : iconColor,
    ),
  );
}
