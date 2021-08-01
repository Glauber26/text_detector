import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void exibirAlertaToast(String msgAlerta, BuildContext context) {
  Toast.show(msgAlerta, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}
