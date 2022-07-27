import 'package:flutter/material.dart';
class text_widget extends StatelessWidget {
  final String text, font;
  final int color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const text_widget(
      {Key? key,
      required this.text,
      required this.font,
      required this.color,
      required this.fontSize,
      required this.fontWeight,
      required this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: Color(color),
        fontSize: fontSize,
        fontWeight: fontWeight,),
    );
  }

}
extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
