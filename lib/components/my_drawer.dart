import 'package:event_planner/services/auth/auth_service.dart';
import 'package:event_planner/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(){
    //get auth service

    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),
          
              //home list
              ListTile(title: const Text("H O M E"),
                leading: const Icon(Icons.home),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              //setting list
              ListTile(title: const Text("C O N F I G U R A Ç Ã O"),
                leading: const Icon(Icons.settings),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(),),);
                },
              ),
          
              //logout
            ],
          ),
          ListTile(title: const Text("L O G O U T"),
            leading: const Icon(Icons.logout),
            onTap:logout,
          ),
        ],
      ),
    );
  }
}