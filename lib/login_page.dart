/*
 * ===== Part 1: super.key (Keys) =====
 * super.key forwards the optional `key` argument up to the parent class
 * (StatefulWidget / StatelessWidget). Flutter uses keys to decide whether
 * an existing widget in the tree can be reused or must be replaced during a
 * rebuild. The key goes in the constructor parameter list:
 *     const LoginPage({super.key});
 *
 * The `key` passed through super.key is a widget identity key: it tells
 * Flutter which widget in the tree is "the same one" across rebuilds.
 * GlobalKey<FormState> _keyForm is something else. It is a key we create
 * ourselves, and it gives us a handle to the Form's State object so we can
 * call _keyForm.currentState!.validate(). It doesn't affect how Flutter
 * matches widgets; it gives our code access to a State.
 *
 * ===== Part 2: const usage =====
 * A const widget is created once at compile time, and Flutter reuses that
 * same instance whenever its parent rebuilds. Flutter sees that the instance
 * is identical to the previous one and skips rebuilding that subtree. Fewer
 * rebuilds means less work and a faster UI. const only works when every value
 * is known at compile time, so Text(username) can't be const, but Text("go back")
 * can.
 *
 * ===== Part 3: private State =====
 * In Dart, a name that starts with _ is library-private: it is visible only
 * inside the file that declares it. State classes should be private because
 * the State is an implementation detail of the widget. Other files should only
 * use the public widget (LoginPage) and never reach into its State. Keeping
 * State private hides internals and lets us change them without breaking other
 * files.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _inputCheck() {
    if (_keyForm.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      if (username == Database.username && password == Database.password) {
        Database.isLoggedIn = true;
        context.go("/home");
      } else {
        _usernameController.clear();
        _passwordController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong info")));
      }
    }
  }

  @override
  void initState() {
    print(" start Login");
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    print(" finish Login");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please enter valid username ";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (((value?.length) ?? 0) < 6) {
                    return "please enter valid password";
                  }
                  return null;
                },
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _inputCheck,
                child: const Text("go to home "),
              ),
              TextButton(
                onPressed: () => context.push("/signup"),
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
