import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rentvehicle_application/screen/forgotpassword.dart';
import 'package:rentvehicle_application/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obsecuretext = true;
  bool visible = false;
  final String sUrl =
      "http://192.168.110.241/rent_car/public/UserAuthentication";

  _cekLogin() async {
    setState(() {
      visible = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var params = "?username=" +
        usernameController.text +
        "&password=" +
        passwordController.text;
    try {
      var res = await http.get(Uri.parse(sUrl + params));
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        prefs.setBool("isLogin", true);
        setState(() {
          visible = false;
        });

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        setState(() {
          visible = false;
        });
        AlertDialog alert = AlertDialog(
          title: Text("Login Gagal"),
          content: Text("Username atau Password Salah"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"))
          ],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
          padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 250,
                  padding: EdgeInsets.all(3),
                  child: Image(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      labelText: "username",
                      icon: Icon(Icons.person_outline),
                      hintText: "Masukan username"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Masukan Email!";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obsecuretext,
                  decoration: InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obsecuretext = !_obsecuretext;
                            });
                          },
                          child: _obsecuretext
                              ? Icon(Icons.remove_red_eye)
                              : Icon(Icons.remove_red_eye_outlined)),
                      hintText: "Masukan Password"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Masukan Password!";
                    } else {
                      return null;
                    }
                  },
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: (() {
                          _cekLogin();
                        }),
                        child: Text("Login"))),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                    },
                    child: Text(
                      "Lupa Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                // WebViewPlus(
                //     javascriptMode: JavascriptMode.unrestricted,
                //     onWebViewCreated: (controller) {
                //       controller.loadUrl("https://www.google.com");
                //     })
              ],
            ),
          ),
        )));
  }
}
