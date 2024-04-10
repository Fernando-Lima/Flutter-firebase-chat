import 'package:event_planner/pages/login_page.dart';
import 'package:event_planner/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  //show login page
  bool showLoginPage = true;

  //toogle between login and register page
  void tooglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap: tooglePages,);
    }else{
      return RegisterPage(
        onTap: tooglePages,
      );
    }
  }
}