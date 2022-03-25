import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// SIGN UP PAGE CLASS
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// SIGN UP PAGE SCAFFOLD
class _SignUpPageState extends State<SignUpPage> {
  // AUTHENTICATION CONTROLLERS
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  // ERROR CODES
  bool _incompleteForm = false;
  bool _passMismatch = false;
  bool _weakPass = false;
  bool _emailUsed = false;
  bool _emailInvalid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up!'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 320,
            height: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 35),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create an account:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // loginForm('Username', false), // Widget function
                  TextField(
                    controller: emailController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Password',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController2,
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Confirm Password',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () async {
                        _incompleteForm = emailController.text == '' ||
                            passwordController.text == '' ||
                            passwordController2.text == '';
                        _passMismatch =
                            passwordController.text != passwordController2.text;
                        // IF PASSWORDS MATCH
                        if (!_incompleteForm && !_passMismatch) {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                            _weakPass = _emailUsed = _emailInvalid = false;
                            setState(() {});
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              _weakPass = true;
                            } else if (e.code == 'email-already-in-use') {
                              _emailUsed = true;
                            } else if (e.code == 'invalid-email') {
                              _emailInvalid = true;
                            }
                            setState(() {});
                          }
                        } else {
                          // PASSWORD MISMATCH
                          setState(() {});
                        }
                      },
                      child: const Text('Sign Up',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white))
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // ERROR MESSAGES
          if (_incompleteForm) ...[
            const SizedBox(height: 5),
            const Text(
              'Please fill every field',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 15),
          ] else if (_passMismatch) ...[
            const SizedBox(height: 5),
            const Text(
              'Passwords do not match',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 15),
          ] else if (_weakPass) ...[
            const SizedBox(height: 5),
            const Text(
              'Use a stronger password',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 15),
          ] else if (_emailUsed) ...[
            const SizedBox(height: 5),
            const Text(
              'This email is already in use',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 15),
          ] else if (_emailInvalid) ...[
            const SizedBox(height: 5),
            const Text(
              'Enter a valid email',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 15),
          ]
        ]),
      ),
    );
  }
}
