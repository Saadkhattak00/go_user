import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_user/global/global.dart';
import 'package:go_user/infoHandler/app_info.dart';
import 'package:go_user/widgets/dialog_box.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import 'main_screen.dart';

class ActiveRiderRequestScreen extends StatefulWidget {
  DatabaseReference? referenceRiderRequest;
  ActiveRiderRequestScreen({Key? key, this.referenceRiderRequest})
      : super(key: key);
  @override
  _ActiveRiderRequestScreenState createState() =>
      _ActiveRiderRequestScreenState();
}

class _ActiveRiderRequestScreenState extends State<ActiveRiderRequestScreen> {
  List<Widget> _list = [];
  String fare = "";
  String fareTime = '';
  String fareDistance = '';
  String driverId = "";
  String driverName = '';
  String carModel = '';
  bool request = false;
  driverRequest() async {
    _list.clear();
    final custmerRequestDetail = await FirebaseDatabase.instance
        .ref()
        .child("Customer Ride Request")
        .child(currentFirebaseUser!.uid)
        .get();
    fareTime = custmerRequestDetail.child("fareTime").value.toString();
    fareDistance = custmerRequestDetail.child("fareDistance").value.toString();
    final driverRideRequest = await FirebaseDatabase.instance
        .ref()
        .child("Driver Ride Request")
        .get();
    Map driversDetails = driverRideRequest.value as Map;
    driversDetails.forEach((driverKey, value) async {
      print(" Driver key " + driverKey);
      driverId = driverKey;
      final singleDriverRideRequest = await FirebaseDatabase.instance
          .ref()
          .child("Driver Ride Request")
          .child(driverKey)
          .get();
      Map requestDetail = singleDriverRideRequest.value as Map;
      requestDetail.forEach((key, value) async {
        print(" Customer key " + key);
        print("currrent user key " + currentFirebaseUser!.uid);
        //i = key.toString().compareTo(currentFirebaseUser!.uid.toString());
        print(currentFirebaseUser!.uid != key);
        if (currentFirebaseUser!.uid == key) {
          print("user key match");
          final driverDetail = await FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(driverId)
              .get();
          driverName = driverDetail.child("name").value.toString();
          carModel = driverDetail
              .child("car_details")
              .child('car_model')
              .value
              .toString();
          print(value["fare"]);
          fare = value["fare"];

          var requestCard = Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                    top: 8,
                    left: 8,
                  ),
                  width: 50,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          bottomLeft: Radius.circular(7))),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    child: CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.black54,
                      ),
                      radius: 25,
                      backgroundColor: Colors.grey,
                    ),
                  )),
              Container(
                padding: EdgeInsets.only(top: 3),
                margin: EdgeInsets.only(
                  top: 8,
                  right: 8,
                ),
                height: 100,
                width: 320,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7))),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(carModel), Text("PKR " + fare)],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(driverName), Text(fareTime)],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmoothStarRating(
                            color: Colors.orange,
                            rating: 4,
                            size: 15,
                          ),
                          Text(fareDistance)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              child: Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(
                                "Reject",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
          _list.add(requestCard);
          setState(() {
            request = true;
          });
        }
      });
    });
    setState(() {
      request = true;
    });

    // driverId = driverRideRequest.child("driverId").value.toString();
    // final driverDetail = await FirebaseDatabase.instance
    //     .ref()
    //     .child("drivers")
    //     .child(driverId)
    //     .get();
    // driverName = driverDetail.child("name").value.toString();
    // carModel =
    //     driverDetail.child("car_details").child('car_model').value.toString();
    print(fare);
    print(fareDistance);
    print(driverName);
    print(carModel);
    print(fareTime);
    // var requestCard = Row(
    //   children: [
    //     Container(
    //         margin: EdgeInsets.only(
    //           top: 8,
    //           left: 8,
    //         ),
    //         width: 50,
    //         height: 100,
    //         decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(7),
    //                 bottomLeft: Radius.circular(7))),
    //         child: Container(
    //           margin: EdgeInsets.symmetric(horizontal: 2),
    //           child: CircleAvatar(
    //             child: Icon(
    //               Icons.person,
    //               size: 40,
    //               color: Colors.black54,
    //             ),
    //             radius: 25,
    //             backgroundColor: Colors.grey,
    //           ),
    //         )),
    //     Container(
    //       padding: EdgeInsets.only(top: 3),
    //       margin: EdgeInsets.only(
    //         top: 8,
    //         right: 8,
    //       ),
    //       height: 100,
    //       width: 320,
    //       decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.only(
    //               topRight: Radius.circular(7),
    //               bottomRight: Radius.circular(7))),
    //       child: Column(
    //         children: [
    //           Container(
    //             padding: EdgeInsets.symmetric(horizontal: 5),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [Text(carModel), Text("PKR " + fare)],
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.symmetric(horizontal: 5),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [Text(driverName), Text(fareTime)],
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.symmetric(horizontal: 5),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 SmoothStarRating(
    //                   color: Colors.orange,
    //                   rating: 4,
    //                   size: 15,
    //                 ),
    //                 Text(fareDistance)
    //               ],
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.symmetric(horizontal: 5),
    //             child: Row(
    //               children: [
    //                 Expanded(
    //                   child: TextButton(
    //                     child: Text(
    //                       "Accept",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     style: ButtonStyle(
    //                         backgroundColor:
    //                             MaterialStateProperty.all(Colors.green),
    //                         shape: MaterialStateProperty.all<
    //                             RoundedRectangleBorder>(RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(18.0),
    //                         ))),
    //                     onPressed: () {},
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: 10,
    //                 ),
    //                 Expanded(
    //                   child: TextButton(
    //                     child: Text(
    //                       "Reject",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     style: ButtonStyle(
    //                         backgroundColor:
    //                             MaterialStateProperty.all(Colors.red),
    //                         shape: MaterialStateProperty.all<
    //                             RoundedRectangleBorder>(RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(18.0),
    //                         ))),
    //                     onPressed: () {},
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ],
    // );
    // _list.add(requestCard);
    // setState(() {
    //   request = true;
    // });
  }

  deleteCustomerRequest() async {
    final driverRideRequest = await FirebaseDatabase.instance
        .ref()
        .child("Driver Ride Request")
        .get();
    Map driversDetails = driverRideRequest.value as Map;
    driversDetails.forEach((driverKey, value) async {
      final singleDriverRideRequest = await FirebaseDatabase.instance
          .ref()
          .child("Driver Ride Request")
          .child(driverKey)
          .get();

      DatabaseReference customerRequestRefrence = FirebaseDatabase.instance
          .ref()
          .child("Driver Ride Request")
          .child(driverKey);

      Map requestDetail = singleDriverRideRequest.value as Map;

      requestDetail.forEach((key, value) {
        if (currentFirebaseUser!.uid == key) {
          customerRequestRefrence.child(currentFirebaseUser!.uid).remove();
          print("Request found and deletd");
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    driverRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.referenceRiderRequest!.key);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          centerTitle: true,
          title: const Text(
            "Rider Request",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              //delete/remove the ride request from database

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
              Provider.of<AppInfo>(context, listen: false).userDropOffLocation =
                  null;
              deleteCustomerRequest();
              widget.referenceRiderRequest!.remove();

              //   Navigator.pop(context);
              // SystemNavigator.pop();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: request
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            Column(
                children: request
                    ? _list
                    : [
                        Center(
                            child: dialogBox(
                          message: "processing please wait",
                        ))
                      ]),
            TextButton(
                onPressed: () {
                  setState(() {
                    request = false;
                    driverRequest();
                  });
                },
                child: Center(
                  child: Text(
                    "Refresh",
                    style: TextStyle(color: Colors.black54),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
