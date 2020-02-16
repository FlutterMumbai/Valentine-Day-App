import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Valentine"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('days').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            List<Day> days = snapshot.data.documents
                .map((DocumentSnapshot snapshot) => Day.fromSnapshot(snapshot))
                .toList();
            if (days.length == 0) {
              List<Day> newDays = [
                Day(
                    name: "Rose Day",
                    manaya: false,
                    partner: "none",
                    timestamp: Timestamp.now()),
                Day(
                    name: "Propose Day",
                    manaya: false,
                    partner: "none",
                    timestamp: Timestamp.now()),
                Day(
                    name: "Chocolate Day",
                    manaya: false,
                    partner: "none",
                    timestamp: Timestamp.now()),
                Day(
                    name: "Teddy Day",
                    manaya: false,
                    partner: "none",
                    timestamp: Timestamp.now()),
                Day(
                    name: "Promise Day",
                    manaya: false,
                    partner: "none",
                    timestamp: Timestamp.now()),
                Day(
                    name: "Kiss Day",
                    manaya: false,
                    partner: "none",
                    timestamp: Timestamp.now()),
                Day(
                    name: "Valentines Day",
                    manaya: false,
                    partner: "none",
                    timestamp: Timestamp.now()),
              ];

              newDays.forEach((Day day) {
                Firestore.instance.collection('days').add(day.getMap());
              });
            }
            print(days[0].name);
            return ListView.builder(
              itemCount: days.length,
              itemBuilder: (BuildContext context, int index) {
                Day dayItem = days.elementAt(index);

                void changeManaya() {
                  dayItem.ref.updateData({'manaya': !dayItem.manaya});
                }

                return Container(
                  color: dayItem.manaya ? Colors.greenAccent : Colors.redAccent,
                  child: ListTile(
                    title: Text(dayItem.name),
                    subtitle: Text(dayItem.timestamp.toString()),
                    onTap: changeManaya,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Day {
  final String name;
  final bool manaya;
  final String partner;
  final Timestamp timestamp;

  final DocumentReference ref;

  Day({this.name, this.manaya, this.partner, this.timestamp, this.ref});

  factory Day.fromSnapshot(DocumentSnapshot snapshot) {
    return Day(
        name: snapshot.data['day'],
        manaya: snapshot.data['manaya'],
        partner: snapshot.data['partner'],
        timestamp: snapshot.data['timestamp'],
        ref: snapshot.reference);
  }

  Map<String, dynamic> getMap() {
    return {
      'day': this.name,
      'manaya': this.manaya,
      'partner': this.partner,
      'timestamp': this.timestamp
    };
  }
}
