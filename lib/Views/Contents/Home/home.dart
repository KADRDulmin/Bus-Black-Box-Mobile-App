import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:BBBS/Models/Strings/app.dart';
import 'package:BBBS/Models/Utils/Colors.dart';
import 'package:BBBS/Models/Utils/Common.dart';
import 'package:BBBS/Models/Utils/FirebaseStructure.dart';
import 'package:BBBS/Models/Utils/Images.dart';
import 'package:BBBS/Views/Contents/Home/drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  dynamic dataLive = null;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
      initNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color7,
        drawer: HomeDrawer(),
        body: SafeArea(
          child: SizedBox(
              width: displaySize.width,
              height: displaySize.height,
              child: Column(
                children: [
                  Expanded(
                      flex: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => (_scaffoldKey
                                        .currentState!.isDrawerOpen)
                                    ? _scaffoldKey.currentState!.openEndDrawer()
                                    : _scaffoldKey.currentState!.openDrawer(),
                                child: Icon(
                                  Icons.menu_rounded,
                                  color: colorWhite,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(20.0)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: displaySize.width * 0.08,
                                      child: Image.asset(logo),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        app_name,
                                        style: TextStyle(
                                            fontSize: 16.0, color: colorBlack),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  getData();
                                },
                                child: Icon(
                                  Icons.refresh,
                                  color: colorWhite,
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  if (dataLive != null)
                    getLiveTile(
                        Icons.stop_circle_outlined,
                        "Acceleration Spike",
                        dataLive['acceleration_spike']
                            ? 'Detected'
                            : 'Not Detected',
                        colorBackground: dataLive['acceleration_spike']
                            ? colorRed.withOpacity(0.1)
                            : null),
                  if (dataLive != null)
                    getLiveTile(Icons.sunny_snowing, "Temperature",
                        dataLive['bus_temperature'] ?? '',
                        symbol: '°C'),
                  if (dataLive != null)
                    getLiveTile(
                        Icons.speed_outlined, "Speed", dataLive['speed'] ?? ''),
                  if (dataLive != null)
                    Expanded(
                        flex: 4,
                        child: SizedBox(
                          height: displaySize.width * 0.8,
                          width: double.infinity,
                          child: GoogleMap(
                            markers: {
                              Marker(
                                  markerId: const MarkerId("-1"),
                                  position:
                                      LatLng(dataLive['lat'], dataLive['lng']))
                            },
                            mapType: MapType.satellite,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(dataLive['lat'], dataLive['lng']),
                              zoom: 17,
                            ),
                          ),
                        ))
                ],
              )),
        ));
  }

  void getData() {
    _databaseReference
        .child(FirebaseStructure.BLACKBOX)
        .onValue
        .listen((DatabaseEvent data) async {
      setState(() {
        dataLive = data.snapshot.value;
      });
    });
  }

  void initNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        _databaseReference
            .child(FirebaseStructure.NOTIFICATION)
            .onValue
            .listen((DatabaseEvent data) async {
          dynamic noti = data.snapshot.value;
          if (noti['istrue'] == true) {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: -1,
                    channelKey: 'emergency_BBBS',
                    title: noti['message'].toString(),
                    largeIcon: 'resource://drawable/logo',
                    body: 'Bus Blakbox System'));

            await _databaseReference
                .child(FirebaseStructure.NOTIFICATION)
                .child('istrue')
                .set(false);
          }
        });
      }
    });
  }

  Widget getLiveTile(IconData icon, String title, dynamic value,
      {String? symbol, int expandedFlex = 1, Color? colorBackground}) {
    return Expanded(
        flex: expandedFlex,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Card(
            color: colorBackground ?? color7,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                  leading: Icon(
                    icon,
                    color: colorPrimary,
                    size: displaySize.width * 0.08,
                  ),
                  title: Text(
                    title.toString(),
                    style: TextStyle(
                        color: color15,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0),
                  ),
                  trailing: Text(
                    '$value ${symbol ?? ''}',
                    style: TextStyle(
                        color: color15,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0),
                  )),
            ),
          ),
        ));
  }
}
