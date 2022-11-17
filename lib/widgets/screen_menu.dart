import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getGameTitle(),
            getrGameMenu(context),
          ],
        ),
      ),
    );
  }

  Widget getGameTitle() {
    return const Text(
      'Gold Rush',
      style: TextStyle(
        color: Colors.yellow,
        fontSize: 64.0,
      ),
    );
  }

  Widget getrGameMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/game",
                  (route) => false,
                );
              },
              child: const Text(
                'Play Game',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 32.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/settings",
                  (route) => false,
                );
              },
              child: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 32.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                SystemNavigator.pop();
              },
              child: const Text(
                'Exist Game',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 32.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
