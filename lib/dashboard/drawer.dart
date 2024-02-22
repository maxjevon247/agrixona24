import 'package:agrixona24/account/profile.dart';
import 'package:agrixona24/post/marketplace.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerMenu extends StatefulWidget {
  final String title;

  const DrawerMenu({this.title = 'Demo'});

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  var imagesVisible = true;
  User? currentUser;

  var cardContent = [];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });

    var ran = Random();

    for (var i = 0; i < 5; i++) {
      var heading = '\$${(ran.nextInt(20) + 15).toString()}00 per month';
      var subheading =
          '${(ran.nextInt(3) + 1).toString()} bed, ${(ran.nextInt(2) + 1).toString()} bath, ${(ran.nextInt(10) + 7).toString()}00 sqft';
      var cardImage =
          'https://source.unsplash.com/random/800x600?house&${ran.nextInt(100)}';
      var supportingText =
          'Beautiful home, recently refurbished with modern appliances...';
      var cardData = {
        'heading': heading,
        'subheading': subheading,
        'cardImage': cardImage,
        'supportingText': supportingText,
      };
      cardContent.add(cardData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        drawer: _buildDrawer(context));
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          currentUser == null
              ? const CircularProgressIndicator()
              : UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: currentUser?.photoURL != null
                        ? NetworkImage(currentUser!.photoURL!)
                        : null,
                  ),
                  accountEmail: Text(currentUser!.email ?? ''),
                  accountName: Text(
                    currentUser!.displayName ?? '',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
                  otherAccountsPictures: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Show a dialog or a new screen for selecting a new profile picture
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
          ListTile(
            leading: const Icon(Icons.house),
            title: const Text(
              'Profile',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => ProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.apartment),
            title: const Text(
              'Message',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const DrawerMenu(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.house_outlined),
            title: const Text(
              'MarketPlace',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const Marketplace(),
                ),
              );
            },
          ),
          const Divider(
            height: 10,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(
              'Favorites',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const DrawerMenu(
                    title: 'Favorites',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.black45,
        title: Text(widget.title),
        actions: [
          Switch(
            value: imagesVisible,
            activeColor: Colors.yellowAccent,
            onChanged: (bool switchState) {
              setState(() {
                imagesVisible = switchState;
              });
            },
          ),
        ]);
  }

  Container _buildBody() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children:
                cardContent.map((cardData) => _buildCard(cardData)).toList(),
          )),
    );
  }

  Card _buildCard(Map<String, dynamic> cardData) {
    return Card(
        elevation: 4.0,
        child: Column(
          children: [
            ListTile(
              title: Text(cardData['heading']!),
              subtitle: Text(cardData['subheading']!),
              trailing: const Icon(Icons.favorite_outline),
            ),
            Visibility(
              visible: imagesVisible,
              child: Container(
                height: 200.0,
                child: Ink.image(
                  image: NetworkImage(cardData['cardImage']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(cardData['supportingText']!),
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text('CONTACT AGENT'),
                  onPressed: () {/* ... */},
                ),
                TextButton(
                  child: const Text('LEARN MORE'),
                  onPressed: () {/* ... */},
                )
              ],
            )
          ],
        ));
  }
}
