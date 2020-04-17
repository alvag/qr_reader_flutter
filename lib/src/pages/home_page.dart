import 'package:flutter/material.dart';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader_flutter/src/models/scan_model.dart';
import 'package:qr_reader_flutter/src/pages/address_page.dart';
import 'package:qr_reader_flutter/src/pages/maps_page.dart';
import 'package:qr_reader_flutter/src/bloc/scans_bloc.dart';
import 'package:qr_reader_flutter/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Scanner'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: scansBloc.deleteAll,
            ),
          ],
        ),
        body: _callPage(_currentPage),
        bottomNavigationBar: _bottomNavigation(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          onPressed: () => _scanQR(context),
          backgroundColor: Theme.of(context).primaryColor,
        ));
  }

  _scanQR(BuildContext context) async {
    String futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    if (futureString != null) {
      final scanModel = ScanModel(valor: futureString);
      scansBloc.insertScan(scanModel);

      if (Platform.isIOS) {
        Future.delayed(Duration(microseconds: 750), () {
          utils.launchScan(context, scanModel);
        });
      } else {
        utils.launchScan(context, scanModel);
      }
    }
  }

  Widget _bottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones'),
        )
      ],
    );
  }

  Widget _callPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return MapsPage();
      case 1:
        return AddressPage();
      default:
        return MapsPage();
    }
  }
}
