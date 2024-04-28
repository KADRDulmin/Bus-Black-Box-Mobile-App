import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:BBBS/Models/Utils/Colors.dart';
import 'package:BBBS/Models/Utils/Common.dart';
import 'package:BBBS/Models/Utils/FirebaseStructure.dart';
import 'package:BBBS/Models/Utils/Routes.dart';
import 'package:BBBS/Models/Utils/Utils.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:intl/intl.dart';
import '../../Widgets/custom_text_datetime_chooser.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];

  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  bool useFilters = false;
  bool showFilters = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color7,
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
                                onTap: () {
                                  Routes(context: context).back();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: colorWhite,
                                ),
                              ),
                              Text(
                                "History",
                                style: TextStyle(fontSize: 16.0, color: color7),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    showFilters = !showFilters;
                                  });
                                },
                                child: Icon(
                                  (showFilters) ? Icons.menu_open : Icons.menu,
                                  color: colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  (showFilters)
                      ? AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                        fontSize: 16.0, color: colorBlack),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CustomTextDateTimeChooser(
                                        height: 5.0,
                                        controller: start,
                                        backgroundColor: color7,
                                        iconColor: colorPrimary,
                                        isIconAvailable: true,
                                        hint: 'Start',
                                        icon: Icons.calendar_month,
                                        textInputType: TextInputType.text,
                                        validation: (value) {
                                          return null;
                                        },
                                        obscureText: false),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CustomTextDateTimeChooser(
                                        height: 5.0,
                                        controller: end,
                                        backgroundColor: color7,
                                        iconColor: colorPrimary,
                                        isIconAvailable: true,
                                        hint: 'End',
                                        icon: Icons.safety_check,
                                        textInputType: TextInputType.text,
                                        validation: (value) {
                                          return null;
                                        },
                                        obscureText: false),
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 50.0,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorWhite),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorPrimary),
                                        ),
                                        onPressed: () async {
                                          useFilters = true;
                                          getData();
                                        },
                                        child: const Text(
                                          "Filter Records",
                                          style: TextStyle(),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: colorWhite,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5.0, left: 5.0, right: 5.0),
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (var rec in list)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1.0),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5.0),
                                          child: ExpandedTile(
                                            theme: ExpandedTileThemeData(
                                              headerRadius: 24.0,
                                              headerColor: rec['value']
                                                      ['acceleration_spike']
                                                  ? colorRed.withOpacity(0.2)
                                                  : color7,
                                              headerPadding:
                                                  const EdgeInsets.all(24.0),
                                              headerSplashColor: colorSecondary,
                                              contentBackgroundColor:
                                                  rec['value']
                                                          ['acceleration_spike']
                                                      ? colorRed
                                                          .withOpacity(0.2)
                                                      : color7,
                                              contentPadding:
                                                  EdgeInsets.all(24.0),
                                              contentRadius: 12.0,
                                            ),
                                            leading: Icon(
                                              Icons.numbers_outlined,
                                              color: colorPrimary,
                                              size: 35.0,
                                            ),
                                            title: Text(
                                              "${rec['value']['busno']}",
                                              style: TextStyle(
                                                  color: colorPrimary,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15.0),
                                            ),
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getHistoryCard(
                                                    Icons.stop_circle_outlined,
                                                    'Acceleration Spike',
                                                    rec['value'][
                                                            'acceleration_spike']
                                                        ? 'Detected'
                                                        : 'Not Detected'),
                                                getHistoryCard(
                                                    Icons.sunny_snowing,
                                                    'Temperature',
                                                    rec['value']
                                                            ['bus_temperature']
                                                        .toString(),
                                                    symbol: '°C'),
                                                getHistoryCard(
                                                    Icons.speed,
                                                    'Speed',
                                                    rec['value']['speed']
                                                        .toString(),
                                                    symbol: 'KMP/H'),
                                                getHistoryCard(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    'Datetime',
                                                    getDateTime(int.parse(
                                                        rec['value']
                                                                ['timestamp']
                                                            .toString()))),
                                                SizedBox(
                                                  height:
                                                      displaySize.width * 0.8,
                                                  width: double.infinity,
                                                  child: GoogleMap(
                                                    markers: {
                                                      Marker(
                                                          markerId:
                                                              const MarkerId(
                                                                  "-1"),
                                                          position: LatLng(
                                                              rec['value']
                                                                  ['lat'],
                                                              rec['value']
                                                                  ['lng']))
                                                    },
                                                    mapType: MapType.hybrid,
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                      target: LatLng(
                                                          rec['value']['lat'],
                                                          rec['value']['lng']),
                                                      zoom: 16,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            controller: ExpandedTileController(
                                                isExpanded: false),
                                          )),
                                    )
                                ]),
                          ),
                        ),
                      ))
                ],
              )),
        ));
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.HISTORY)
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      for (DataSnapshot element in data.snapshot.children) {
        dynamic dd = element.value;

        if (useFilters == true &&
            start.text.isNotEmpty &&
            end.text.isNotEmpty) {
          DateTime currentDateTime =
              DateTime.fromMillisecondsSinceEpoch(dd['timestamp'] as int);
          if (currentDateTime.isAfter(
                  DateFormat("yyyy/MM/dd hh:mm a").parse(start.text)) &&
              currentDateTime
                  .isBefore(DateFormat("yyyy/MM/dd hh:mm a").parse(end.text))) {
            list.add({'key': element.key, 'value': element.value});
          }
        } else {
          list.add({'key': element.key, 'value': element.value});
        }
      }
      setState(() {
        useFilters = false;
      });
    });
  }

  getHistoryCard(IconData icon, String title, String param, {String? symbol}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: colorGrey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: color15,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                  )
                ],
              )),
          Expanded(
              flex: 0,
              child: Row(
                children: [
                  Text(
                    param,
                    style: TextStyle(
                        color: color15,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0),
                  ),
                  if (symbol != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        symbol,
                        style: TextStyle(
                            color: color15,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0),
                      ),
                    )
                ],
              ))
        ],
      ),
    );
  }
}
