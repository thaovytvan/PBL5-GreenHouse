import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final databaseReference = FirebaseDatabase.instance.reference();
  late Query dataRef;

  @override
  void initState() {
    super.initState();
    dataRef = databaseReference.child('history_device_control').limitToLast(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: dataRef.onValue,
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.snapshot.value as Map<String, dynamic>;
              List<dynamic> dataList = data.values.toList();
              return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Bong đen: ${dataList[index]['bongden']}'),
                    subtitle: Text('Thoi gian: ${dataList[index]['time']}\nMo to: ${dataList[index]['moto']}\nTự động: ${dataList[index]['tudong']}'),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
