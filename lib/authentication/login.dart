import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linepay/authentication/signup.dart';

// LOGIN PAGE CLASS
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

// LOGIN PAGE SCAFFOLD
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _errorLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('PingMe'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 320,
              height: 370,
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
                        'Login:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 20),
                    TextButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                            setState(() {});
                            // Adding user's email to Shared Preferences
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('userEmail', emailController.text);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    //todo: replace with real home page
                                    builder: (context) => const HomePage()));
                          } on FirebaseAuthException {
                            _errorLogin = true;
                            setState(() {});
                          }
                        },
                        child: const Text('Login',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white))
                  ],
                ),
              ),
            ),
            if (_errorLogin) ...[
              const SizedBox(height: 25),
              const Text(
                'Invalid email and/or password.',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              const SizedBox(height: 15),
            ] else ...[
              const SizedBox(height: 40),
            ],
            const Text(
              'Need to create an account?',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            const SizedBox(height: 10),
            // MOVE TO SIGN UP PAGE
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: const Text('Sign up',
                    style: TextStyle(fontSize: 25, color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ))
          ],
        ),
      ),
    );
  }
}
