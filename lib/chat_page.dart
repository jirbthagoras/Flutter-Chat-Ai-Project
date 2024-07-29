import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'widgets/chat_bubble.dart';


const apiKey = "***";

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  TextEditingController messageController = TextEditingController();

  bool isLoading = false;

  List<ChatBubble> chatBubbles = [
    const ChatBubble(
      direction: Direction.left,
      message: 'Halo! saya E.L.A.N.G, asisten digital anda!',
      photoUrl: 'https://i.pravatar.cc/150?img=47',
      type: BubbleType.alone,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('E.L.A.N.G Personal Assitant', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              reverse: true,
              padding: const EdgeInsets.all(10),
              children: chatBubbles.reversed.toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [ 
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {

                      setState(() {
                        isLoading = true;
                      });

                      final content = [
                        Content.text(messageController.text)
                      ];

                      final GenerateContentResponse responseAi = 
                        await  model.generateContent(content);

                      
                      chatBubbles = [
                        ...chatBubbles,
                        ChatBubble(
                          direction: Direction.right,
                         message: messageController.text,
                         photoUrl: null,
                         type: BubbleType.alone
                         )
                      ]; //Bubblechat

                      chatBubbles = [
                        ...chatBubbles,
                        ChatBubble(
                          direction: Direction.left,
                         message: responseAi.text ??
                         'Maaf, saay tidak mengerti',
                         photoUrl: 'https://i.pravatar.cc/150?img=47',
                         type: BubbleType.alone
                         )
                      ];

                      messageController.clear();
                      setState(() {
                        isLoading = false;
                      });

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
