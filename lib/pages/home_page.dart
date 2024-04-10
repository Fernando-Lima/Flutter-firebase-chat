import 'package:event_planner/components/my_drawer.dart';
import 'package:event_planner/components/user_tile.dart';
import 'package:event_planner/pages/chat_page.dart';
import 'package:event_planner/services/auth/auth_service.dart';
import 'package:event_planner/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

  //chat e auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Home Page"),
       backgroundColor: Colors.transparent,
       foregroundColor: Colors.grey,
       elevation: 0,

      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );

    
  } 

  //build a list of users exept for the current logged in user
    Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot){
        // error
        if(snapshot.hasError){
          return const Text("Erro ao carregar a lista de usuários");
        }
        // loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Carregando lista de usuários...");
        }
        //done
        return ListView(children: snapshot.data!.map<Widget>((userData) => _builUserListItem(userData,context)).toList(),);
      },
    );
    }
    // build individual list tile for user

    Widget _builUserListItem(Map<String, dynamic> userData, BuildContext context){
      //display all users except current user
     if(userData["email"] != _authService.getCurrentUser()!.email){
       return UserTile(
        text: userData['email'],
        onTap: (){
          // tapped on a user -> go to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData['email'],
                receiverID: userData['uid'],
              ),
            ),
          );
        },
      );
     }else{
      return Container();
     }

    }
}