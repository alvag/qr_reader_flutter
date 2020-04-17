import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:qr_reader_flutter/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapCtrl = new MapController();
  String mapType = 'streets';
  int mapTypeIndex = 0;
  List<String> mapTypes = ['streets', 'dark', 'light', 'outdoors', 'satellite'];

  @override
  Widget build(BuildContext context) {
    final ScanModel scanModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              mapCtrl.move(scanModel.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _map(scanModel),
      floatingActionButton: _floatButton(context),
    );
  }

  Widget _map(ScanModel scanModel) {
    return FlutterMap(
      mapController: mapCtrl,
      options: MapOptions(
        center: scanModel.getLatLng(),
        zoom: 15.0,
      ),
      layers: [
        _createMap(),
        _createMarker(scanModel),
      ],
    );
  }

  _createMap() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
          '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken':
            'pk.eyJ1IjoiYWx2YTg1IiwiYSI6ImNrN2k2aDk0aTBpMjIzbG5rYTBtdXd5ZDYifQ.ZiY4qp3j3xfn8KlNJg4cZQ',
        'id': 'mapbox.$mapType',
      },
    );
  }

  _createMarker(ScanModel scanModel) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scanModel.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
              size: 40.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _floatButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        setState(() {
          mapTypeIndex++;
          if (mapTypeIndex >= mapTypes.length) mapTypeIndex = 0;
          mapType = mapTypes[mapTypeIndex];
        });
      },
    );
  }
}
