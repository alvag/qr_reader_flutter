import 'package:flutter/material.dart';
import 'package:qr_reader_flutter/src/bloc/scans_bloc.dart';
import 'package:qr_reader_flutter/src/models/scan_model.dart';
import 'package:qr_reader_flutter/src/utils/utils.dart' as utils;

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scansBloc = new ScansBloc();

    return StreamBuilder(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final scans = snapshot.data;

        if (scans.isEmpty) {
          return Center(
            child: Text('No hay registros'),
          );
        }

        return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
                  child: ListTile(
                    leading: Icon(
                      Icons.cloud_queue,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(scans[i].valor),
                    subtitle: Text('ID: ${scans[i].id}'),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                    ),
                    onTap: () => utils.launchScan(context, scans[i]),
                  ),
                ));
      },
    );
  }
}
