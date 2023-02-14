import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:new_driver/global_utils.dart';

import 'post_list_utils.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});
  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('post').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar:AppBar(
      centerTitle: true,
      title: const Text(
        'Passenger Posts',
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        IconButton(
          icon: CircleAvatar(foregroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL.toString()),
          onForegroundImageError: (_, __) {},
          backgroundImage: const AssetImage('assets/GIFs/unknown.gif'),),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<ProfileScreen>(
                builder: (context) => ProfileScreen(
                  appBar: AppBar(
                    centerTitle: true,
                    title: const Text('User Profile'),
                  ),
                  actions: [
                    SignedOutAction((context) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    })
                  ],
                  children: const [
                    Divider(),
                  ],
                ),
              ),
            );
          },
        ),
      ],
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

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const Center(child: Text('No Posts Yet'));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: snapshot.data!.docs
                .map<dynamic>((document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return MyListTile(
                    showDeleteButton: false,
                    onTapEnabled: true,
                    userDetails: UserData(
                      destination: data['destination'].toString(),
                      passengerID: data['passengerId'].toString(),
                      shared: data['shared'],
                      time: data['time'].toString(),
                      phoneNo: data['phoneNo'].toString(),
                      photoURL: data['photoURL'].toString(),
                    ),
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
