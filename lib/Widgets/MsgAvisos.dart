import 'package:text_detector/Widgets/BotaoPadrao.dart';
import 'package:text_detector/Widgets/SimpleAlertCustom.dart';
import 'package:flutter/material.dart';


Future msgAviso(String txTitulo, String txDescricao, Function onTap, BuildContext context) => showDialogCustom(
  context,
  foregroundColor: Colors.white,
  backgroundColor: Colors.red,
  widget: Container(
    child: Column(
      children: [
        Text(
          '$txTitulo',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '$txDescricao',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            botaoPadrao(
              bt_color: Color(0xffE74C3C),
              bt_nome: 'ok, tentar novamente',
              fonte_color: Colors.white,
              fontSize: 14,
              onTap: onTap,
            ),
          ],
        ),
      ],
    ),
  ),
);

Future alertLoading(BuildContext context) => showDialogCustom(
  context,
  foregroundColor: Colors.white,
  backgroundColor: Colors.red,
  widget: Container(
    child: Column(
      children: [
        Text(
          'Diminuindo o tamanho da imagem',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ],
    ),
  ),
);