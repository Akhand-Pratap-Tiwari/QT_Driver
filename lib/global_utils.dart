import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterfire_ui/auth.dart';

import 'all_bids.dart';

class UserData {
  String time;
  bool shared;
  String destination;
  String passengerID;
  String? phoneNo;
  String? photoURL;
  int? price;
  String? docId;

  UserData(
      {required this.time,
      required this.shared,
      required this.destination,
      required this.passengerID,
      this.docId,
      this.price,
      this.phoneNo = 'N/A',
      this.photoURL = 'N/A'});
}

class MyLoadingIndicator extends StatelessWidget {
  const MyLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LoadingIndicator(
        size: 100,
        borderWidth: 5,
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  ListTile underConstruction(
      {required String listTileTxt, required IconData icon}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        listTileTxt,
        style: const TextStyle(color: Colors.black),
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(listTileTxt),
              ),
              body: Center(
                child: Image.asset('assets/under.jpg'),
              ),
            );
          },
        ), (route) => route.isFirst);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      child: Column(
        children: [
          InkResponse(
            onTap: () => Future.delayed(
              const Duration(milliseconds: 200),
              () => Navigator.push(
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
              ),
            ),
            child: SafeArea(
              child: UserAccountsDrawerHeader(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                otherAccountsPictures: [
                  CircleAvatar(
                    child: IconButton(
                        onPressed: () => FlutterFireUIAuth.signOut(
                              context: context,
                              auth: FirebaseAuth.instance,
                            ),
                        icon: const Icon(Icons.logout)),
                  ),
                ],
                accountName: Text(user.displayName.toString()),
                accountEmail: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email.toString()),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('drivers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong !');
                          }
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return const LinearProgressIndicator();
                          }
                          return Row(
                            children: [
                              RatingBar(
                                itemSize: 15,
                                initialRating:
                                    snapshot.data!.data()!['rating'],
                                ignoreGestures: true,
                                allowHalfRating: true,
                                ratingWidget: RatingWidget(
                                  full: const Icon(
                                    Icons.star,
                                    color: Colors.pink,
                                  ),
                                  half: const Icon(
                                    Icons.star_half,
                                    color: Colors.pink,
                                  ),
                                  empty: const Icon(
                                    Icons.star_border,
                                    color: Colors.pink,
                                  ),
                                ),
                                onRatingUpdate: (value) => {},
                              ),
                              Text(' • ${snapshot.data!.data()!['n'].toInt()}')
                            ],
                          );
                        })
                  ],
                ),
                currentAccountPicture: CircleAvatar(
                  foregroundImage: NetworkImage(user.photoURL.toString()),
                  onForegroundImageError: (_, __) {},
                  backgroundImage: const AssetImage('assets/GIFs/unknown.gif'),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.dashboard_customize,
              color: Colors.black,
            ),
            title: const Text(
              'Your Bids',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AllBidPage()),
                  (route) => route.isFirst);
            },
          ),
          underConstruction(
              listTileTxt: 'About Us', icon: Icons.info_outline_rounded),
          underConstruction(
              listTileTxt: 'Share Our App',
              icon: Icons.mobile_screen_share_rounded),
          underConstruction(listTileTxt: 'T&C', icon: Icons.list_alt_rounded),
          underConstruction(
              listTileTxt: 'Privacy Policy', icon: Icons.privacy_tip_outlined),
        ],
      ),
    );
  }
}
