import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodxpress/common/color_extension.dart';
import 'package:foodxpress/common_widget/round_button.dart';
import 'package:foodxpress/common_widget/round_textfield.dart';
import 'package:foodxpress/common_widget/round_icon_button.dart';
import 'package:foodxpress/view/on_boarding/on_boarding.dart';
import 'signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isLoading = false;

  bool _obscurePassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: txtEmail.text.trim(),
        password: txtPassword.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        showMessage("✅ Login Successful!");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingView()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMessage("❌ No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showMessage("❌ Wrong password provided.");
      } else if (e.code == 'invalid-email') {
        showMessage("❌ Invalid email address.");
      } else {
        showMessage("❌ Wrong Email or Password. ");
      }
    } catch (e) {
      showMessage("❌ An unexpected error occurred: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/img/splash_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  Text(
                    "Login",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "Add your details to login",
                    style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 25),
                  RoundTextfield(
                    hintText: "Your Email",
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 25),

                  // Password Field with Eye Icon
                  Row(
                    children: [
                      Expanded(
                        child: RoundTextfield(
                          hintText: "Password",
                          controller: txtPassword,
                          obscureText: _obscurePassword,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: TColor.primaryText,  // Customize color as needed
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  RoundButton(
                    title: isLoading ? "Logging in..." : "Login",
                    onPressed: loginUser,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "or Login With",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  RoundIconButton(
                    icon: "assets/img/facebook_logo.png",
                    title: "Login with Facebook",
                    color: const Color(0xff367FC0),
                    onPressed: () {
                      // Facebook login action
                    },
                  ),
                  const SizedBox(height: 25),
                  RoundIconButton(
                    icon: "assets/img/google_logo.png",
                    title: "Login with Google",
                    color: const Color(0xffDD4B39),
                    onPressed: () {
                      // Google login action
                    },
                  ),
                  const SizedBox(height: 80),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpView(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Don't have an Account? ",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
