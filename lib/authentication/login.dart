import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linepay/preferences/LinePayColors.dart';
import 'package:linepay/business/Host.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linepay/authentication/signup.dart';
import 'package:linepay/main.dart';

// LOGIN PAGE CLASS
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.isBusiness}) : super(key: key);
  final bool isBusiness;

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
        leading: const BackButton(color: text_color),
        backgroundColor: backGround,
        title: const Text(
          'LinePay',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 24,
            color: text_color,
          ),
        ),
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
                color: Theme.of(context).primaryColor,
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (widget.isBusiness) ? 'Business Login:' : 'Login:',
                        style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    //todo: InQueue page navigation info
                                     const HostPage()));
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
                  backgroundColor: Theme.of(context).primaryColor,
                ))
          ],
        ),
      ),
    );
  }
}
