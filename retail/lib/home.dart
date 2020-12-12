import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:splashscreen/splashscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';

import 'package:barcode_scan/barcode_scan.dart';

final firebasedatabase = FirebaseDatabase.instance;
final ref = firebasedatabase.reference();
String apple = '0';
String banana = '0';
String orange = '0';

int selectedIndex = 0;

class MainPage extends StatefulWidget {
  @override
  final String uid;

  MainPage({Key key, this.uid}) : super(key: key);
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  final String title = "Home";
  String qrResult = 'Not Yet Scanned';

  final PageStorageBucket bucket = PageStorageBucket();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cart.jpg'),
                fit: BoxFit.none,
                alignment: Alignment.center,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.all(20),
            height: double.infinity,
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.all(15),
                  onPressed: () async {
                    String codeScanner = await BarcodeScanner.scan();
                    setState(() {
                      qrResult = codeScanner;
                      apple = qrResult[0];
                      banana = qrResult[3];
                      orange = qrResult[6];
                      selectedIndex = 1;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(),
                          ));
                    });
                  },
                  height: 40,
                  minWidth: 200,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.pink[400],
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Scan QR Code',
                    style: TextStyle(
                        color: Colors.pink[400],
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  @override
  CartPage({Key key}) : super(key: key);
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    int total = (int.parse(apple) * 2) +
        (int.parse(banana) * 2) +
        (int.parse(orange) * 2);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipPath(
                  child: Container(
                    padding: EdgeInsets.all(40),
                    height: 150,
                    width: double.infinity,
                    color: Colors.orangeAccent[700],
                    child: Text(
                      'Shopping Cart',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  clipper: CustomClipPath(),
                ),
                Apple(),
                Banana(),
                Orange(),
              ],
            )
          ]),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.amber,
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(15),
                child: Text('TOTAL : RM ${total}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ))),
            SizedBox(
              width: 10,
            ),
            FlatButton(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              onPressed: () => null,
              child: Text(
                'CheckOut',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Apple() {
    if (apple != '0') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: ExactAssetImage('assets/images/apple.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.2),
                  child: Text(
                    "Apple",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: 90,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.orange[900],
                        Colors.orange[800],
                        Colors.orange[700],
                        Colors.orange[600],
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    )),
                child: Text('Amount: ' + apple,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: 120,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange[900],
                          Colors.orange[800],
                          Colors.orange[700],
                          Colors.orange[600],
                        ])),
                child: Text('Unit Price : RM2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 80,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange[900],
                          Colors.orange[800],
                          Colors.orange[700],
                          Colors.orange[600],
                        ])),
                child: Text('RM ${int.parse(apple) * 2}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget Banana() {
    if (banana != '0') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: ExactAssetImage('assets/images/banana.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.2),
                  child: Text(
                    "Banana",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: 90,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.orange[900],
                        Colors.orange[800],
                        Colors.orange[700],
                        Colors.orange[600],
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    )),
                child: Text('Amount: ' + banana,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: 120,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange[900],
                          Colors.orange[800],
                          Colors.orange[700],
                          Colors.orange[600],
                        ])),
                child: Text('Unit Price : RM1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 80,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange[900],
                          Colors.orange[800],
                          Colors.orange[700],
                          Colors.orange[600],
                        ])),
                child: Text('RM ${int.parse(banana) * 2}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

Widget Orange() {
  if (orange != '0') {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              alignment: Alignment.centerLeft,
              image: ExactAssetImage('assets/images/orange.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.2),
                child: Text(
                  "Orange",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 90,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange[900],
                      Colors.orange[800],
                      Colors.orange[700],
                      Colors.orange[600],
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  )),
              child: Text('Amount: ' + orange,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: 120,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.orange[900],
                        Colors.orange[800],
                        Colors.orange[700],
                        Colors.orange[600],
                      ])),
              child: Text('Unit Price : RM2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 80,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.orange[900],
                        Colors.orange[800],
                        Colors.orange[700],
                        Colors.orange[600],
                      ])),
              child: Text('RM ${int.parse(orange) * 2}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  } else {
    return SizedBox.shrink();
  }
}

class CustomClipPath extends CustomClipper<Path> {
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HomePage extends StatefulWidget {
  final String uid;

  HomePage({Key key, this.uid}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pageList = List<Widget>();
  void initState() {
    pageList.add(MainPage());
    pageList.add(CartPage());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedIndex == 0
          ? AppBar(
              title: Text(
                'Home Page',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.pink[100],
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut().then((res) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false);
                    });
                  },
                ),
              ],
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.green,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Cart",
              icon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              label: "Check Out",
              icon: Icon(Icons.exit_to_app_sharp),
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          }),
      body: IndexedStack(
        index: selectedIndex,
        children: pageList,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: FutureBuilder(
                  future: FirebaseDatabase.instance
                      .reference()
                      .child('Users')
                      .child(widget.uid)
                      .once(),
                  builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.value['email']);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              accountName: FutureBuilder(
                  future: FirebaseDatabase.instance
                      .reference()
                      .child('Users')
                      .child(widget.uid)
                      .once(),
                  builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.value['Username']);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: new IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                onPressed: () => null,
              ),
              title: Text('Home'),
              onTap: () {
                print(widget.uid);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(
                              uid: widget.uid,
                            )));
              },
            ),
            ListTile(
              leading: new IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                onPressed: () => null,
              ),
              title: Text('Setting'),
              onTap: () {
                print(widget.uid);
              },
            ),
          ],
        ),
      ),
    );
  }
}
