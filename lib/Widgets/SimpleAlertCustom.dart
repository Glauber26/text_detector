import 'package:flutter/material.dart';
import 'package:flutter/src/material/dialog.dart';

Future showDialogCustom(BuildContext context, {Color backgroundColor, Color foregroundColor, double height, Widget widget, Function onPressedButtonClose}) => showDialog(
  barrierDismissible: true,
  context: context,
  builder: (context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: backgroundColor == null ? Color(0xffC7A040) : backgroundColor,
              titlePadding: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: foregroundColor == null ? Colors.white : foregroundColor),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: widget,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      onPressed: onPressedButtonClose == null
                          ? () {
                        Navigator.pop(context);
                      }
                          : onPressedButtonClose,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },
);
