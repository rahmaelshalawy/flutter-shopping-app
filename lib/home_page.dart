import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

/*
 * Why the old "go back" button was a bug (Part 5.4):
 * Login used context.go("/home"), which replaces the whole navigation stack
 * with just /home. There is no earlier page underneath it, so context.pop()
 * has nothing to pop and the button does nothing (or logs an error, depending
 * on the go_router version). The fix is a Logout button: it clears the login
 * flag and uses go() to send the user to /login, which is the right tool for
 * "replace the whole stack".
 */
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print(" start Home");
    super.initState();
  }

  @override
  void dispose() {
    print(" finish Home");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("welcome to Home Page"),
            ElevatedButton(
              onPressed: () {
                Database.isLoggedIn = false;
                context.go("/login");
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
