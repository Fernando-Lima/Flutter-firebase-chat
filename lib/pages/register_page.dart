import 'package:event_planner/services/auth/auth_service.dart';
import 'package:event_planner/components/my_text_field.dart';
import 'package:event_planner/pages/my_button.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _pwdConfirmController = TextEditingController();
  final void Function()?onTap;

  RegisterPage({super.key, required this.onTap});

  // register method
  void register(BuildContext context){
    final _auth = AuthService();

    if(_pwdController.text == _pwdConfirmController.text){
      try {
        _auth.signUpWithEmailAndPassword(
          _emailController.text,
          _pwdController.text,
        );
      } catch (e) {
        showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.toString()),
        ),
      );
      }
    }
    //password don't match -> tell user to fix
    else{
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
           "Senhas não são iguais"),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50,),
            //bem vindo
            Text(
              "Vamos criar uma conta para você",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 50,),
            //email
            MyTextField(
              obscureText: false,
              hintText: "Email",
              controller: _emailController,
            ),
            const SizedBox(height: 10,),
            //senha
            MyTextField(
              hintText: "Senha",
              obscureText: true,
              controller: _pwdController ,
            ),
             const SizedBox(height: 10,),
            // Confirmar senha
            MyTextField(
              hintText: "Confirmar senha",
              obscureText: true,
              controller: _pwdConfirmController ,
            ),
             const SizedBox(height: 10,),
            //register button
            MyButton(
              onTap: () => register(context),
              text: "Registrar",
            ),
                  
            const SizedBox(height: 10,),
            //registrar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Já possui uma conta? ", 
                  style:
                      TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Faça login agora",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                       color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}