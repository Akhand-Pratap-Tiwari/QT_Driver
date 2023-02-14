import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_driver/post_bid.dart';

import '../global_utils.dart';

class MyListTile extends StatefulWidget {
  final UserData userDetails;
  final bool onTapEnabled;
  final bool showDeleteButton;
  final Color tileColor, textColor;
  final String fallbackImg;
  final bool isBidAccepted;
  const MyListTile(
      {super.key,
      required this.userDetails,
      required this.onTapEnabled,
      required this.showDeleteButton,
      this.tileColor = Colors.black,
      this.textColor = Colors.white,
      this.fallbackImg = 'assets/GIFs/unknown.gif',
      this.isBidAccepted = false});

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        textColor: widget.textColor,
        tileColor: widget.tileColor,
        trailing: widget.showDeleteButton && !widget.isBidAccepted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkResponse(
                    splashColor: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      size: 40,
                      color: Colors.red,
                    ),
                    onTap: () {
                      Future.delayed(
                          const Duration(milliseconds: 250),
                          () => FirebaseFirestore.instance
                              .collection('bids')
                              .doc(widget.userDetails.docId)
                              .delete());
                    },
                  ),
                ],
              )
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: widget.onTapEnabled
            ? () {
                FirebaseFirestore.instance
                    .collection('bids')
                    .where('driverId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .get()
                    .then((value) {
                  if (value.size < 6) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PostBidPage(userData: widget.userDetails);
                      },
                    ));
                  } else {
                    showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text('You have excceded the bid limit'),
                                  ],
                                ),
                              ),
                            ));
                  }
                });
              }
            : null,
        leading: CircleAvatar(
          radius: 25,
          foregroundImage: NetworkImage(widget.userDetails.photoURL!),
          onForegroundImageError: (_, __) {},
          backgroundImage: AssetImage(widget.fallbackImg),
        ),
        title: Text(
          widget.userDetails.destination,
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
        // dense: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.userDetails.price == null
                ? Container()
                : Text('₹${widget.userDetails.price}'),
            Text('${widget.userDetails.time} • ${widget.userDetails.shared ? 'Shared' : 'Single'}'),
          ],
        ),
      ),
    );
  }
}
