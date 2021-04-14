import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:studily/models/event_info.dart';
import 'package:studily/pages/create_screen.dart';
import 'package:studily/pages/edit_screen.dart';
import 'package:studily/resources/color.dart';
import 'package:studily/storage.dart';

// import 'package:googleapis/calendar/v3.dart' as cal;

GoogleSignIn _googleSignIn = GoogleSignIn(
  // clientId:
  //     "457849596697-cpjr29ppcdgct89g5ct8c1lv0vcfkfb6.apps.googleusercontent.com",
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    // 'https://www.googleapis.com/auth/calendar',
  ],
);

class HomePageBackground extends StatefulWidget {
  HomePageBackground({Key key, this.title = ''}) : super(key: key);
  final String title;

  @override
  _HomePageBackgroundState createState() => _HomePageBackgroundState();
}

class _HomePageBackgroundState extends State<HomePageBackground> {
  List<bool> isSelected = [true, false]; // used for toggles buttons
  Storage storage = Storage();

  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  CalendarCarousel _calendarCarouselNoHeader;

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2020, 2, 10): [
        new Event(
          date: new DateTime(2020, 2, 14),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Color(0xff9891FF),
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2020, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2020, 2, 15),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    _markedDateMap.add(
        new DateTime(2020, 2, 25),
        new Event(
          date: new DateTime(2020, 2, 25),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        new DateTime(2020, 2, 10),
        new Event(
          date: new DateTime(2020, 2, 10),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(new DateTime(2019, 2, 11), [
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);

    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      // if (_currentUser != null) {
      //   _handleGetContact();
      // }
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      // todayBorderColor: Color(0xff9891FF),
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.black,
      ),
      // thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder: CircleBorder(
        side: BorderSide(
          color: Color(0xffFF0031),
        ),
      ),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.white,
      ),
      weekdayTextStyle: TextStyle(
        color: Color(0xff6159E6),
      ),
      selectedDayBorderColor: Color(0xff6159E6),
      selectedDayButtonColor: Color(0xff6159E6),
      todayButtonColor: Color(0xff6159E6),
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 60,
            left: 20,
            child: Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff6159E6),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 25,
            child: Text(
              'Hello,',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xff32338C),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 25,
            child: Text(
              _currentUser.displayName,
              // 'User',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xff32338C),
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 200,
            child: Image(
              image: AssetImage('assets/hand-wave.png'),
              height: 40,
              width: 40,
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: GoogleUserCircleAvatar(identity: _currentUser),
            // child: Image(
            //   image: AssetImage('assets/avatar (1).png'),
            //   height: 60,
            //   width: 60,
            // ),
          ),
          Positioned(
            top: 80,
            right: 100,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Stack(
                      children: <Widget>[
                        Center(
                          child: new Container(
                            // width: double.infinity,
                            width: size.width / 1.1,
                            height: size.height / 1.7,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              // width: size.width / 1.1,
                              // height: size.height / 1.7,
                              decoration: BoxDecoration(
                                // Box shadow for container
                                boxShadow: [
                                  BoxShadow(
                                    // color: Colors.grey,
                                    color: Color(0xff9891FF),
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 10.0,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    topLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(50),
                                  ),
                                ),
                                child: new Scaffold(
                                  body: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        //custom icon

                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 30.0,
                                            bottom: 16.0,
                                            left: 16.0,
                                            right: 16.0,
                                          ),
                                          child: new Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                _currentMonth,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24.0,
                                                ),
                                              )),
                                              GestureDetector(
                                                child: Icon(Icons.arrow_back),
                                                onTap: () {
                                                  setState(() {
                                                    _targetDateTime = DateTime(
                                                        _targetDateTime.year,
                                                        _targetDateTime.month -
                                                            1);
                                                    _currentMonth = DateFormat
                                                            .yMMM()
                                                        .format(
                                                            _targetDateTime);
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              GestureDetector(
                                                child:
                                                    Icon(Icons.arrow_forward),
                                                onTap: () {
                                                  setState(() {
                                                    _targetDateTime = DateTime(
                                                        _targetDateTime.year,
                                                        _targetDateTime.month +
                                                            1);
                                                    _currentMonth = DateFormat
                                                            .yMMM()
                                                        .format(
                                                            _targetDateTime);
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50),
                                              topLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                              bottomLeft: Radius.circular(50),
                                            ),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: _calendarCarouselNoHeader,
                                        ), //
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Image(
                image: AssetImage('assets/calendar (1).png'),
                height: 28,
                width: 28,
              ),
            ),
          ),
          Positioned(
            top: 280,
            left: size.width / 2.5,
            child: ToggleButtons(
              children: <Widget>[
                // RichText(
                //   text: TextSpan(
                //     children: [
                //       TextSpan(
                //         text: "Schedule ",
                //         style: TextStyle(
                //             color: Colors.black, fontWeight: FontWeight.bold),
                //       ),
                //       WidgetSpan(
                //         child: Icon(Icons.calendar_today, size: 14),
                //       ),
                //     ],
                //   ),
                // ),
                // RichText(
                //   text: TextSpan(
                //     children: [
                //       TextSpan(
                //         text: "Tasks ",
                //         style: TextStyle(
                //             color: Colors.black, fontWeight: FontWeight.bold),
                //       ),
                //       WidgetSpan(
                //         child: Icon(Icons.book_outlined, size: 14),
                //       ),
                //     ],
                //   ),
                // ),
                Icon(Icons.calendar_today),
                Icon(Icons.book_outlined),
              ],
              isSelected: isSelected,
              color: Color(0xff9891FF),
              selectedColor: Colors.white,
              fillColor: Color(0xff32338C),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              onPressed: (int index) {
                setState(() {
                  isSelected[index] = !isSelected[index];
                });
              },
              renderBorder: false,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width / 1,
              height: size.height / 1.6,
              child: Stack(
                children: <Widget>[
                  // Positioned(
                  //   top: 0,
                  //   left: 80,
                  //   right: 80,
                  //   child: GestureDetector(
                  //     child: Icon(
                  //       Icons.add,
                  //       color: Colors.black,
                  //     ),
                  //     onTap: () {
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (context) => CreateScreen(),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0),
                    color: Colors.transparent,
                    child: StreamBuilder(
                      stream: storage.retrieveEvents(),
                      // builder: (context, snapshot)
                      // ignore: non_constant_identifier_names
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.length > 0) {
                            // changed from documents to document to docs
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.docs
                                  .length, // changed from documents to document to docs
                              itemBuilder: (context, index) {
                                Map<String, dynamic> eventInfo = snapshot
                                    .data.docs[index]
                                    .data(); // changed from documents to document to docs

                                EventInfo event = EventInfo.fromMap(eventInfo);

                                DateTime startTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        event.startTimeInEpoch);
                                DateTime endTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        event.endTimeInEpoch);

                                String startTimeString =
                                    DateFormat.jm().format(startTime);
                                String endTimeString =
                                    DateFormat.jm().format(endTime);
                                String dateString =
                                    DateFormat.yMMMMd().format(startTime);

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditScreen(event: event),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: size.width / 1.05,
                                          padding: EdgeInsets.only(
                                            bottom: 16.0,
                                            top: 16.0,
                                            left: 16.0,
                                            right: 16.0,
                                          ),
                                          decoration: BoxDecoration(
                                            // color: CustomColor.neon_green
                                            //     .withOpacity(0.3),
                                            color: Color(0xff9891FF)
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event.name ?? '',
                                                style: TextStyle(
                                                  color: CustomColor.dark_blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                event.description ?? '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 8.0),
                                                // event.link had TEXT error *data != null
                                                child: Text(
                                                  event.link ?? '',
                                                  style: TextStyle(
                                                    color: CustomColor.dark_blue
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 5,
                                                    // color:
                                                    //     CustomColor.neon_green,
                                                    color: Color(0xff32338C),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        dateString,
                                                        style: TextStyle(
                                                          color: CustomColor
                                                              .dark_cyan,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          letterSpacing: 1.5,
                                                        ),
                                                      ),
                                                      Text(
                                                        '$startTimeString - $endTimeString',
                                                        style: TextStyle(
                                                          color: CustomColor
                                                              .dark_cyan,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          letterSpacing: 1.5,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                'No Events',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            );
                          }
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                CustomColor.sea_blue),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: new Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                backgroundColor: CustomColor.dark_cyan,
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
