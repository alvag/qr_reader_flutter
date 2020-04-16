import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader_flutter/src/pages/address_page.dart';
import 'package:qr_reader_flutter/src/pages/maps_page.dart';
import 'package:qr_reader_flutter/src/providers/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Scanner'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {},
            ),
          ],
        ),
        body: _callPage(_currentPage),
        bottomNavigationBar: _bottomNavigation(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          onPressed: _scanQR,
          backgroundColor: Theme.of(context).primaryColor,
        ));
  }

  _scanQR() async {
    // geo:39.70438730218683,-77.54839392220504
    // https://google.com

    String futureString = 'https://google.com';

    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch (e) {
    //   futureString = e.toString();
    // }

    // print('futureString: $futureString');

    if (futureString != null) {
      final scanModel = ScanModel(valor: futureString);
      DBProvider.db.insert(scanModel);
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
