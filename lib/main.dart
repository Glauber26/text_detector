import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:text_detector/Screens/InfoApp.dart';
import 'package:text_detector/Screens/ScannerHistory.dart';
import 'package:text_detector/Stores/ConversaoStore.dart';
import 'package:text_detector/Widgets/BotaoPadrao.dart';
import 'package:text_detector/Widgets/SimpleAlertCustom.dart';
import 'package:text_detector/Widgets/toast.dart';

import 'Screens/ScannerScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho CIC271',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Scanner de Texto - CIC271'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'Escanear',
            ),
            Tab(
              text: 'Histórico',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              InfoGrupoDialog(context);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ScannersScreen(),
          ScannerHistory(),
        ],
      ),
    );
  }
}
