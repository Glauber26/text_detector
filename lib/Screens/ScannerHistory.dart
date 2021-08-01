import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:text_detector/Stores/HistoricoScanStore.dart';
import 'package:text_detector/Widgets/BotaoPadrao.dart';
import 'package:text_detector/Widgets/SimpleAlertCustom.dart';
import 'package:text_detector/Widgets/toast.dart';

class ScannerHistory extends StatefulWidget {
  @override
  _ScannerHistoryState createState() => _ScannerHistoryState();
}

class _ScannerHistoryState extends State<ScannerHistory> {
  HistoricoScanStore historicoScanStore = HistoricoScanStore();
  bool atualizaHistorico = false;
  List<HistoricoScanner> historicoScanList;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    historicoScanList = await historicoScanStore.buscaTodoHistorico();

    setState(() {
      atualizaHistorico = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "Histórico de Scans",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                atualizaHistorico == false
                    ? Text(
                        'Nenhum histórico encontrado',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )
                    : historicoScanList == null
                        ? Text(
                            'Nenhum histórico encontrado',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: historicoScanList
                                .where((element) => historicoScanList.length <= historicoScanList.length)
                                .map<Widget>(
                                  (scan) => GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    scan.txScan,
                                                    maxLines: 7,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  IconButton(
                                                    tooltip: 'Visualizar',
                                                    icon: Icon(
                                                      Icons.preview,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      exibirAlertaToast('Visualizar todo o texto', context);
                                                      widgetVieweTexto(scan.dtCadastro, scan.txScan);
                                                    },
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Copiar',
                                                    icon: Icon(
                                                      Icons.copy,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      exibirAlertaToast('Texto copiado para a área de transferência', context);
                                                      Clipboard.setData(
                                                        ClipboardData(text: scan.txScan),
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Copiar',
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      exibirAlertaToast('Item apagado', context);
                                                      historicoScanList.remove(scan);
                                                      historicoScanStore.deletaItemHistorico(scan.cdScan);
                                                      if(historicoScanList.length == 0){
                                                        setState(() {
                                                          atualizaHistorico = false;
                                                        });
                                                      }else{
                                                        setState(() {});
                                                      }
                                                    },
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          Text(
                                            formataData(data: scan.dtCadastro),
                                            style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: GestureDetector(
            onTap: () {
              historicoScanStore.deletaTodoHistorico();
              setState(() {
                atualizaHistorico = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Limpar histórico',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<dynamic> widgetVieweTexto(String txDtScan, String txTextoScan)=>showDialogCustom(
    context,
    foregroundColor: Colors.white,
    backgroundColor: Colors.red,
    widget: Container(
      child: Column(
        children: [
          Text(
            'Texto escaneado dia: ${formataData(data: txDtScan)}',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '$txTextoScan',
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
                bt_nome: 'sair',
                fonte_color: Colors.white,
                fontSize: 14,
                onTap: (){
                  Navigator.canPop(context) ? Navigator.pop(context) : print('');
                },
              ),
              SizedBox(width: 8,),
              botaoPadrao(
                bt_color: Color(0xff449200),
                bt_nome: 'copiar texto',
                fonte_color: Colors.white,
                fontSize: 14,
                onTap: (){
                  exibirAlertaToast('Texto copiado para a área de transferência', context);
                  Clipboard.setData(
                    ClipboardData(text: txTextoScan),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );

  DateFormat dateFormat1 = new DateFormat('dd/MM/yyyy HH:mm:ss');

  String formataData({String data}) {
    return dateFormat1.format(DateTime.parse(data)).toString();
  }
}
