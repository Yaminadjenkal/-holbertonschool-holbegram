import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() =>
      _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? userData;
  int postLength = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      User currentUser =
          FirebaseAuth.instance
              .currentUser!;

      DocumentSnapshot userSnap =
          await FirebaseFirestore
              .instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      var posts =
          await FirebaseFirestore
              .instance
              .collection('posts')
              .where(
                'uid',
                isEqualTo:
                    currentUser.uid,
              )
              .get();

      setState(() {
        userData = userSnap.data()
            as Map<String, dynamic>;

        postLength = posts.docs.length;
      });
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance
        .signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          userData!['username'],
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage(
                userData![
                    'photoUrl'],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              userData![
                  'username'],
              style:
                  const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              userData!['bio'],
            ),

            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      postLength
                          .toString(),
                    ),
                    const Text(
                        'Posts'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      userData![
                              'followers']
                          .length
                          .toString(),
                    ),
                    const Text(
                        'Followers'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      userData![
                              'following']
                          .length
                          .toString(),
                    ),
                    const Text(
                        'Following'),
                  ],
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            FutureBuilder(
              future:
                  FirebaseFirestore
                      .instance
                      .collection(
                          'posts')
                      .where(
                        'uid',
                        isEqualTo:
                            FirebaseAuth
                                .instance
                                .currentUser!
                                .uid,
                      )
                      .get(),
              builder:
                  (context, snapshot) {
                if (!snapshot
                    .hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final data =
                    (snapshot.data
                            as QuerySnapshot)
                        .docs;

                return GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        3,
                    crossAxisSpacing:
                        2,
                    mainAxisSpacing:
                        2,
                  ),
                  itemCount:
                      data.length,
                  itemBuilder:
                      (context,
                          index) {
                    return Image
                        .network(
                      data[index]
                          ['postUrl'],
                      fit: BoxFit
                          .cover,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}