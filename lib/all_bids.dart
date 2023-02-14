import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_driver/global_utils.dart';
import 'package:new_driver/post_list_screen/post_list_utils.dart';

class AllBidPage extends StatefulWidget {
  const AllBidPage({super.key});
  @override
  State<AllBidPage> createState() => _AllBidPageState();
}

class _AllBidPageState extends State<AllBidPage> {
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
      .collection('bids')
      .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Bids'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong !');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyLoadingIndicator();
          }

          if (snapshot.data!.size == 0) {
            // final String data = snapshot.data!.size.toString();
            return const Center(
              child: Text(
                'No bids yet',
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: snapshot.data!.docs
                .map((document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyListTile(
                        isBidAccepted: data['accepted'],
                        fallbackImg: data['accepted']
                            ? 'assets/accepted.png'
                            : 'assets/GIFs/waiting.gif',
                        tileColor: Colors.transparent,
                        textColor: Colors.black,
                        showDeleteButton: true,
                        onTapEnabled: false,
                        userDetails: UserData(
                            docId: document.id,
                            time: data['time'],
                            shared: data['shared'],
                            destination: data['destination'],
                            passengerID: data['passengerId'],
                            price: data['price']),
                      ),
                      const Divider(),
                    ],
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }
}
