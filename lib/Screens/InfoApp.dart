import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:text_detector/Widgets/BotaoPadrao.dart';
import 'package:text_detector/Widgets/SimpleAlertCustom.dart';

Future<dynamic> InfoGrupoDialog(BuildContext context) => showDialogCustom(
      context,
      foregroundColor: Colors.white,
      backgroundColor: Colors.red,
      widget: Container(
        child: Column(
          children: [
            Text(
              'Sobre este APP',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Aplicativo desenvolvido para o trabalho final da disciplina CIC271 - Processamento digital de Imagens do curso de Ciência da Computação da UNIFEI',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Grupo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Glauber Gomes - 2016014127\nPedro Caetano - 2016013907\n Willian Richard - 2016016417',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
                  bt_nome: 'sair',
                  fonte_color: Colors.white,
                  fontSize: 14,
                  onTap: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : print('');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
