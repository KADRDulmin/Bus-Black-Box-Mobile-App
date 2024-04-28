import 'package:flutter/material.dart';
import 'package:BBBS/Models/Utils/Colors.dart';

class CustomTextFormField extends StatelessWidget {
  double height = 5.0;
  String hint;
  IconData icon;
  TextInputType textInputType;
  Color backgroundColor;
  Color iconColor;
  bool isIconAvailable;
  var validation;
  bool obscureText;
  TextEditingController controller;
  var label;

  CustomTextFormField(
      {Key? key,
      required this.height,
      required this.hint,
      required this.icon,
      required this.textInputType,
      required this.backgroundColor,
      required this.iconColor,
      required this.isIconAvailable,
      required this.validation,
      this.label,
      required this.controller,
      required this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        (label != null)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: color11),
                ),
              )
            : const SizedBox.shrink(),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: colorPrimary),
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20.0)),
          padding: EdgeInsets.symmetric(vertical: height, horizontal: 10.0),
          child: Row(
            children: [
              (isIconAvailable == true)
                  ? Icon(
                      icon,
                      color: iconColor,
                    )
                  : const SizedBox.shrink(),
              Flexible(
                  child: TextFormField(
                minLines: 1,
                maxLines: textInputType == TextInputType.multiline ? 10 : 1,
                controller: controller,
                obscureText: obscureText,
                cursorColor: colorPrimary,
                keyboardType: textInputType,
                validator: validation,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: color8),
                    label: Text(hint),
                    labelStyle: TextStyle(
                        color: color8, fontFamily: 'Raleway-SemiBold'),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15)),
              ))
            ],
          ),
        )
      ],
    );
  }
}
