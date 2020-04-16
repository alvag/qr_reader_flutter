import 'package:flutter/material.dart';

import 'package:qr_reader_flutter/src/models/scan_model.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanModel scanModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => {},
          )
        ],
      ),
      body: Center(
        child: Text(scanModel.valor),
      ),
    );
  }
}
