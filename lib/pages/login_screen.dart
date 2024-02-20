import 'package:flutter/material.dart';
import '../components/text_field.dart';
import 'home_screen.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          const Text('Login', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 50),
          const MyTextField(
            hintText: 'Email',
            obscureText: false,
          ),
          const SizedBox(height: 20),
          const MyTextField(
            hintText: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.grey,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width - 55,
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                "Login",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'New User? Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ))));
  }
}
