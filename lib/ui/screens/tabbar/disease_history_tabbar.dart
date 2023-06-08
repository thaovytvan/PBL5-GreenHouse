import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class DiseaseHistoryWidget extends StatefulWidget {
  @override
  _FirebaseRealtimeDatabaseWidgetState createState() =>
      _FirebaseRealtimeDatabaseWidgetState();
}

class _FirebaseRealtimeDatabaseWidgetState
    extends State<DiseaseHistoryWidget> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference()
      .child('history_saubo');

  final DateFormat inputFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z", "en_US");
  final DateFormat outputFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss");
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    String deviceToken = await getDeviceToken();
    print("###### PRINT DEVICE TOKEN TO USE FOR PUSH NOTIFCIATION ######");
    print(deviceToken);
    print("############################################################");

    // listen for user to click on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      String? title = remoteMessage.notification!.title;
      String? description = remoteMessage.notification!.body;

      //im gonna have an alertdialog when clicking from push notification
      Alert(
        context: context,
        type: AlertType.error,
        title: title, // title from push notification data
        desc: description, // description from push notifcation data
        buttons: [
          DialogButton(
            child: Text(
              "WARNNING!",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => Navigator.pop(context),
      width: 120,

      )
        ],
      ).show();
    });
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: databaseReference.orderByKey().limitToLast(20).onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic>? data =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
          if (data != null) {
            List<Map<String, dynamic>> rows = [];
            data.forEach((key, item) {
              DateTime dateTime = inputFormat.parse(item['time']);
              rows.add({
                'time': outputFormat.format(dateTime),
                'image': item['image'] ?? '',
              });

            });
            // rows.sort((a, b) => -a['time'].compareTo(b['time']));
            rows.sort((a, b) {
              DateTime dateTimeA = outputFormat.parse(a['time']);
              DateTime dateTimeB = outputFormat.parse(b['time']);

              int dateComparison = -dateTimeA.compareTo(dateTimeB);
              if (dateComparison != 0) {
                return dateComparison;
              } else {
                return -a['time'].compareTo(b['time']);
              }
            });
            int index = 0;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 5.0,
                columns: [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Image')),
                ],
                rows: rows
                    .map((row) => DataRow(cells: [
                  DataCell(Text('${++index}')),
                  DataCell(Text(row['time'])),
                  DataCell(GestureDetector(
                    child: Image.network(row['image'],
                      width: 50,
                      height: 50,),
                    onTap: () {
                      if (row['image'] != '') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text('Image'),
                              ),
                              body: Center(
                                child: Image.network(row['image']),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  )),
                ]))
                    .toList(),
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
  Future getDeviceToken() async {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }

}