import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/components/chat_bubble.dart';
import 'package:event_planner/components/my_text_field.dart';
import 'package:event_planner/services/auth/auth_service.dart';
import 'package:event_planner/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //controllers - textEditing
  final TextEditingController _messageController = TextEditingController();

  //dependencies - chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
      super.initState();

    // add listener to focus node
      myFocusNode.addListener(() { 
      if(myFocusNode.hasFocus){
        // cause a delay so that the keyboard has time to show up
        // then scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
   });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
     myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(milliseconds: 500), 
      curve: Curves.fastOutSlowIn,);
  }

  // method - send message
  void sendMessage() async {
    // if there is somethig inside the textfield
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      //clear text contoller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
         backgroundColor: Colors.transparent,
       foregroundColor: Colors.grey,
       elevation: 0,
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(
            child: _buildMessageList(),
          ),
          //user input text
          _buildUserInput(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          //if has error
          if (snapshot.hasError) {
            return const Text("Error");
          }
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("carregando mensagens...");
          }

          //return list view
          return ListView(
            controller: _scrollController,
            children:
                snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        });
  }

  //build  messge item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  // is current user
  bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

  // align message to the rigth if sender is the current user, otherwise left
  var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment, 
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
      ],
      ),
    );
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //textfield should take up most of the space
          Expanded(
              child: MyTextField(
            controller: _messageController,
            hintText: "Escreva sua mensagem",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
      
          //send Button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
