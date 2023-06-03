import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

//...



class DeviceHistoryWidget extends StatefulWidget {
  @override
  _FirebaseRealtimeDatabaseWidgetState createState() => _FirebaseRealtimeDatabaseWidgetState();
}

class _FirebaseRealtimeDatabaseWidgetState extends State<DeviceHistoryWidget> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('history_device_control');

  final DateFormat inputFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z", "en_US");
  final DateFormat outputFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: databaseReference.orderByKey().limitToLast(20).onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic>? data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
          if (data != null) {
            List<Map<String, dynamic>> rows = [];
            data.forEach((key, item) {
              DateTime dateTime = inputFormat.parse(item['time']);
              rows.add({
                'bongden': (item['bongden'] == 0 || item['bongden'] == '0')  ? 'OFF' : 'ON',
                'time': outputFormat.format(dateTime),
                'moto': item['moto'] == '0' ? 'OFF' : 'ON',
                'tudong': item['tudong'] == '0' ? 'OFF' : 'ON',
              });
            });
            rows.sort((a, b) => -a['time'].compareTo(b['time']));
            int index = 0;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
              DataTable(
                columnSpacing: 5.0,
                columns: [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Light')),
                  DataColumn(label: Text('Pump')),
                  DataColumn(label: Text('Auto')),
                ],
                rows: rows.map((row) => DataRow(cells: [
                  DataCell(Text('${++index}')),
                  DataCell(Text(row['time'])),
                  DataCell(Text(row['bongden'].toString())),
                  DataCell(Text(row['moto'])),
                  DataCell(Text(row['tudong'])),
                ])).toList(),
              ),
            );
          } else {
            return Text('No data available');
          }
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }

      },
    );
  }
}
