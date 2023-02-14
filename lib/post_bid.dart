import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_driver/all_bids.dart';
import 'package:new_driver/global_utils.dart';
import 'package:new_driver/post_list_screen/post_list_utils.dart';

class PostBidPage extends StatefulWidget {
  final UserData userData;
  const PostBidPage({
    super.key,
    required this.userData,
  });

  @override
  State<PostBidPage> createState() => _PostBidPageState();
}

TextEditingController priceController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _PostBidPageState extends State<PostBidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Enter Bid',
          style: TextStyle(fontSize: 20),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.person,
        //       size: 30.0,
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute<ProfileScreen>(
        //           builder: (context) => ProfileScreen(
        //             appBar: AppBar(
        //               title: const Text('User Profile'),
        //             ),
        //             actions: [
        //               SignedOutAction((context) {
        //                 Navigator.popUntil(context, (route) => route.isFirst);
        //               })
        //             ],
        //             children: const [
        //               Divider(),
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Column(
              children: [
                MyListTile(
                  userDetails: widget.userData,
                  onTapEnabled: false,
                  showDeleteButton: false,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.currency_rupee_rounded),
                      labelText: 'Enter Your Bid Price',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Bid Price';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        int price = int.parse(priceController.text);
                        FirebaseFirestore.instance
                            .collection('drivers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get()
                            .then((value) {
                          return value.data() == null
                              ? ''
                              : value.data()!['PhNo'].toString();
                        }).then((phoneNo) async {
                          await FirebaseFirestore.instance
                              .collection('bids')
                              .add(<String, dynamic>{
                            'driverId': FirebaseAuth.instance.currentUser!.uid,
                            'driverPhoto':
                                FirebaseAuth.instance.currentUser!.photoURL,
                            'driverName':
                                FirebaseAuth.instance.currentUser!.displayName,
                            'driverPhone': phoneNo,
                            'passengerId': widget.userData.passengerID,
                            'price': price,
                            'destination': widget.userData.destination,
                            'shared': widget.userData.shared,
                            'time': widget.userData.time,
                            'accepted': false,
                          });
                        }).then((_) => Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return const AllBidPage();
                                  },
                                ), (route) => route.isFirst));
                      }
                    },
                    // ignore: sort_child_properties_last
                    child: const Text(
                      'Bid',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(250, 40),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
