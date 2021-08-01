import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:text_detector/Stores/ConversaoStore.dart';
import 'package:text_detector/Widgets/BotaoPadrao.dart';
import 'package:text_detector/Widgets/MsgAvisos.dart';
import 'package:text_detector/Widgets/SimpleAlertCustom.dart';
import 'package:text_detector/Widgets/toast.dart';
import 'package:image_picker/image_picker.dart';

class ScannersScreen extends StatefulWidget {
  @override
  _ScannersScreenState createState() => _ScannersScreenState();
}

class _ScannersScreenState extends State<ScannersScreen> {
  ConversaoStore conversaoStore = ConversaoStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      loadTextoConvertido(),
                    ],
                  ),
                ),
              ),
            ),
            Observer(
              builder: (_) {
                if (conversaoStore.statusConversao == 2) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        botaoPadrao(
                          bt_color: Colors.red,
                          largura: MediaQuery.of(context).size.width * .75,
                          bt_nome: 'copiar texto',
                          fonte_color: Colors.white,
                          fontSize: 14,
                          onTap: () {
                            exibirAlertaToast('Texto copiado para a área de transferência', context);
                            Clipboard.setData(
                              ClipboardData(text: conversaoStore.textoReconhecido),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scanButton();
        },
        tooltip: 'Adicionar foto',
        child: Icon(Icons.add_photo_alternate),
      ),
    );
  }

  Widget loadTextoConvertido() => Observer(
        builder: (_) {
          switch (conversaoStore.statusConversao) {
            case 0:
              return Center(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        'Scanner de Texto',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Clique no ícone da imagem para escanear um texto',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
              break;
            case 1:
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'reconhecendo texto',
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
              );
              break;
            case 2:
              return Text(
                conversaoStore.textoReconhecido,
                style: TextStyle(color: Colors.black, fontSize: 13),
              );
              break;
            default:
              return Center(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        'Erro ao scannear o texto da imagem',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'O tamanho da imagem não pode exceder 1mb',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
              break;
          }
        },
      );

  _scanButton() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.camera);

    if (img == null) {
      msgAviso('Ops', 'Imagem não carregada', () {
        Navigator.canPop(context) ? Navigator.pop(context) : print('');
      }, context);
    } else {
      alertLoading(context);

      try {
        String extensaoFile = img.path.substring(img.path.toString().length - 8, img.path.length).split('.')[1];

        print(img.lengthSync());
        var size = await conversaoStore.getFileSize(img.path, 1);
        print('TAMANHO ORIGINAL: ' + size.toString());
        List<int> novaImagem = await conversaoStore.testCompressFile(img);

        String dir = (await getTemporaryDirectory()).path;
        Uint8List novaImg = Uint8List.fromList(novaImagem);
        File newFileImg = await File('$dir/${DateTime.now().microsecondsSinceEpoch.toString()}.$extensaoFile').writeAsBytes(novaImg);

        var size1 = await conversaoStore.getFileSize(newFileImg.path, 1);
        print('TAMANHO MODIFICADO: ' + size1.toString());

        Navigator.canPop(context) ? Navigator.pop(context) : print('');

        switch (size1.toString().split(' ')[1].toString()) {
          case 'B':
            _verFoto(newFileImg, size1.toString(), true, false);
            break;
          case 'KB':
            _verFoto(newFileImg, size1.toString(), true, false);
            break;
          default:
            _verFoto(newFileImg, size1.toString(), true, true);
            break;
        }
      } catch (e) {
        Navigator.canPop(context) ? Navigator.pop(context) : print('');
        _verFoto(img, '', false, true);
      }
    }
  }

  Future _verFoto(File file, String tamanhoImagem, bool compressao, bool exibirAlertaTamanho) => showDialogCustom(
        context,
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        widget: Container(
          child: Column(
            children: [
              Text(
                'Gostou dessa foto?',
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: MediaQuery.of(context).size.height * .6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TransitionToImage(
                    image: FileImage(File(file.path)),
                    loadingWidgetBuilder: (_, double progress, __) => ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: Container(
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'carregando imagem',
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
                    ),
                  ),
                ),
              ),
              Text(
                tamanhoImagem == '' ? 'Tamanho da foto: não calculado' : 'Tamanho da foto: $tamanhoImagem',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              exibirAlertaTamanho == true
                  ? Text(
                      '*Se o tamanho da imagem for superior a 1mb pode haver problemas na conversão para texto',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  botaoPadrao(
                    bt_color: Color(0xffE74C3C),
                    bt_nome: 'não',
                    fonte_color: Colors.white,
                    fontSize: 14,
                    onTap: () {
                      Navigator.canPop(context) ? Navigator.pop(context) : print('');
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  botaoPadrao(
                    bt_color: Color(0xff449200),
                    bt_nome: 'sim',
                    fonte_color: Colors.white,
                    fontSize: 14,
                    onTap: () async {
                      Navigator.canPop(context) ? Navigator.pop(context) : print('');
                      conversaoStore.converteImagemToText(file, compressao);
                      //File newFile = await conversaoStore.converteImagemToText(file);

                      //_verFotoResized(newFile);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
