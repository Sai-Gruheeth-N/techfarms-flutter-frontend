import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget with PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const MainAppBar({super.key});

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  void alertBox() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Instructions'),
          content: const Text('1.\n2.\n3.\n4.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'logo',
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: Image.asset(
                'images/leafLogo.png',
              ),
            ),
          ),
          const SizedBox(width: 15.0),
          const Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: Text(
              'Tech-Farms',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0, right: 5.0),
          child: IconButton(
            icon: Icon(
              Icons.message_outlined,
              color: Colors.lightGreen[600],
            ),
            onPressed: () {
              setState(
                () {
                  alertBox();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
