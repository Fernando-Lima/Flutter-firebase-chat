import 'package:event_planner/services/auth/auth_service.dart';
import 'package:event_planner/components/my_text_field.dart';
import 'package:event_planner/pages/my_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  //tap to go to register page
  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

  //login method
  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // try login
    try{
      await authService.signInWithEmailPassword(_emailController.text, _pwdController.text);
    }

    //catch any errors
    catch(e){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.toString()),
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
              "Bem vindo, sentimos a sua falta",
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
            //login button
            MyButton(
              onTap: () => login(context),
              text: "Entrar",
            ),
                  
            const SizedBox(height: 10,),
            //registrar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Não é um membro? ", 
                  style:
                      TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Registre-se agora",
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