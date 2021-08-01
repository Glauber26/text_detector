import 'package:flutter/material.dart';

Widget botaoPadrao({
  Function onTap,
  String bt_nome,
  Color bt_color,
  double largura,
  Color fonte_color,
  EdgeInsets padding,
  EdgeInsets margin,
  double fontSize,
  FontWeight fontWeight,
}) =>
    largura == null
        ? RaisedButton(
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      padding: padding,
      color: bt_color,
      child: Text(
        '$bt_nome',
        textAlign: TextAlign.center,
        style: TextStyle(color: fonte_color, fontWeight: fontWeight == null ? fontWeight : FontWeight.bold, fontSize: fontSize),
      ),
    )
        : ButtonTheme(
      minWidth: largura,
      child: RaisedButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: padding,
        color: bt_color,
        child: Text(
          '$bt_nome',
          textAlign: TextAlign.center,
          style: TextStyle(color: fonte_color, fontWeight: fontWeight == null ? fontWeight : FontWeight.bold, fontSize: fontSize),
        ),
      ),
    );
