import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DiseaseHistoryScreen extends StatefulWidget {
  @override
  _DiseaseHistoryScreenState createState() => _DiseaseHistoryScreenState();
}

class _DiseaseHistoryScreenState extends State<DiseaseHistoryScreen> {
  final diseaseRef = FirebaseDatabase.instance.reference().child('db-pbl5');

  List<Map<String, dynamic>> _diseaseList = [];

  @override
  void initState() {
    super.initState();

    // Lấy dữ liệu từ Firebase và lưu vào _diseaseList
    // diseaseRef.once().then((DataSnapshot snapshot) {
    //   Map<dynamic, dynamic> values = Map.from(snapshot.value!);
    //   values.forEach((key, value) {
    //     _diseaseList.add({
    //       'picture': value['picture'],
    //       'type': value['type'],
    //       'id': value['id'],
    //       'time': value['time'],
    //     });
    //   });
    //   setState(() {});
    // });


  }

  @override
  Widget build(BuildContext context) {
    // return  SingleChildScrollView(
    //     child: DataTable(
    //       columns: <DataColumn>[
    //         DataColumn(label: Text('Picture', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
    //         DataColumn(label: Text('Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
    //         DataColumn(label: Text('ID', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
    //         DataColumn(label: Text('Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
    //       ],
    //       rows: _diseaseList.map((disease) {
    //         return DataRow(cells: [
    //           DataCell(Image.network(disease['picture'])),
    //           DataCell(Text(disease['type'], style: TextStyle(fontSize: 14))),
    //           DataCell(Text(disease['id'], style: TextStyle(fontSize: 14))),
    //           DataCell(Text(disease['time'], style: TextStyle(fontSize: 14))),
    //         ]);
    //       }).toList(),
    //     ),
    //
    // );
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child:
      Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
        child: Column(
          children: [
            const SizedBox(height: 15),
            DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Time',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Light',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Moto',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Auto',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('10:00 AM', style: TextStyle(fontSize: 14))),
                    DataCell(Text('On', style: TextStyle(fontSize: 14))),
                    DataCell(Text('Off', style: TextStyle(fontSize: 14))),
                    DataCell(Text('On', style: TextStyle(fontSize: 14))),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('11:00 AM', style: TextStyle(fontSize: 14))),
                    DataCell(Text('Off', style: TextStyle(fontSize: 14))),
                    DataCell(Text('On', style: TextStyle(fontSize: 14))),
                    DataCell(Text('Off', style: TextStyle(fontSize: 14))),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('12:00 PM', style: TextStyle(fontSize: 14))),
                    DataCell(Text('On', style: TextStyle(fontSize: 14))),
                    DataCell(Text('Off', style: TextStyle(fontSize: 14))),
                    DataCell(Text('On', style: TextStyle(fontSize: 14))),
                  ],
                ),
              ],
            )

          ],
        ),
      ),
    );

  }
}
