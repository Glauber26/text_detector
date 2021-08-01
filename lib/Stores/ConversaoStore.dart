import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:text_detector/ImageText.dart';
import 'package:text_detector/Stores/HistoricoScanStore.dart';
import 'package:text_detector/global.dart' as glob;
import 'package:mobx/mobx.dart';
import 'package:intl/intl.dart';
part 'ConversaoStore.g.dart';

class ConversaoStore = _ConversaoStoreBase with _$ConversaoStore;

abstract class _ConversaoStoreBase with Store {

  @observable
  int statusConversao = 0;


  @observable
  String textoReconhecido;

  HistoricoScanStore historicoScanStore = HistoricoScanStore();


  void converteImagemToText(File file, bool compressao)async{
    statusConversao = 1;
    try{
      textoReconhecido = '';
      Uint8List bytes;

      String extensaoFile = file.path.substring(file.path.toString().length-8, file.path.length).split('.')[1];

      if(compressao){
        print('COM COMPRESSÃO');
        List<int> novaImagem = await testCompressFile(file);
        String dir = (await getTemporaryDirectory()).path;
        Uint8List novaImg = Uint8List.fromList(novaImagem);
        File newFileImg = await File('$dir/${DateTime.now().microsecondsSinceEpoch.toString()}.$extensaoFile').writeAsBytes(novaImg);
        bytes = new File(newFileImg.path).readAsBytesSync();

      }else{
        print('SEM COMPRESSÃO');
        bytes = new File(file.path).readAsBytesSync();
      }

      Uri uri = Uri.dataFromBytes(bytes, mimeType: "image/jpg");

      var headers = {
        'apikey': '${glob.apikey}'
      };

      var request = http.MultipartRequest('POST', Uri.parse('https://api.ocr.space/parse/image'));
      request.fields.addAll({
        'language': 'por',
        'isOverlayRequired': 'false',
        'base64Image': '$uri',
        "filetype": "$extensaoFile",
        'iscreatesearchablepdf': 'false',
        'issearchablepdfhidetextlayer': 'false'
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        var resp = await response.stream.bytesToString();
        dynamic decode = json.decode(resp);

        print(decode);
        ImageText texto = ImageText.fromJson(decode);

        textoReconhecido = texto.parsedResults[0].parsedText;

        historicoScanStore.insertScan(
          HistoricoScanner(
            dtCadastro: DateTime.now().toString(),
            txScan: texto.parsedResults[0].parsedText,
          ),
        );

        statusConversao = 2;

      } else {
        print(response.reasonPhrase);
        statusConversao = 3;
      }
    }catch(e){
      statusConversao = 3;
    }
  }

  Future<List<int>> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 70,
    );
    print(file.lengthSync());
    print(result.length);


    return result;
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

}