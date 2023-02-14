import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_driver/global_utils.dart';
import 'package:new_driver/post_list_screen/post_list.dart';

String driverName = '';
String driverLicenceNo = '';
String driverVehicleSeat = '';
String driverTaxyNo = '';
String driverMobileno = '';
String driverUPIId = '';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

CollectionReference drivers = FirebaseFirestore.instance.collection('drivers');

final user = FirebaseAuth.instance.currentUser;
final _formKey = GlobalKey<FormState>();

TextEditingController licenceController = TextEditingController();
TextEditingController seatingCapacityController = TextEditingController();
TextEditingController vehicleNoController = TextEditingController();
TextEditingController phoneNoController = TextEditingController();
TextEditingController upiIdController = TextEditingController();

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  Widget widget1 = const MyLoadingIndicator();

  Future<bool> checkIfDocExists(
      {required String collection, required String docId}) async {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection(collection);

    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('drivers')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong !'));
            }

            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const MyLoadingIndicator();
            }
            if (snapshot.data!.exists) {
              return const PostList();
            }
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                          child: Image.asset(
                            'assets/welcome.gif',
                            height: 120.0,
                            width: 120.0,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(0.0, -85.0, 0.0),
                          child: const Text(
                            'Drivers',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(0.0, -80.0, 0.0),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: licenceController,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Your Driving Licence No',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter DL number';
                                      } else if (value.isNotEmpty) {
                                        value.toUpperCase();
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: seatingCapacityController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Seating Capacity',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter Vehicle Seating Capacity';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: vehicleNoController,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Your Vehicle RC No',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Your Vehicle RC No';
                                      } else if (value.isNotEmpty) {
                                        value.toUpperCase();
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: phoneNoController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Your phone number',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter valid phone number';
                                      } else if (value.length != 10) {
                                        return 'Please enter 10 digit number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: upiIdController,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Your UPI Id',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Your UPI Id';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(0.0, -60.0, 0.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await drivers
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set({
                                  'driverId': user!.uid,
                                  'name': user!.displayName,
                                  'email': user!.email,
                                  'profilePhoto': user!.photoURL,
                                  'DLNo': licenceController.text,
                                  'PhNo': phoneNoController.text,
                                  'Seats': seatingCapacityController.text,
                                  'TaxiNo': vehicleNoController.text,
                                  'UPIid': upiIdController.text,
                                  'rating': 0.0,
                                  'n': 0.0,
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              minimumSize: const Size(250, 40),
                            ),
                            child: const Text(
                              'Upload',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
  }
}
