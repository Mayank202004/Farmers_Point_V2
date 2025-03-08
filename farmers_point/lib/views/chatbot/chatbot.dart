import 'package:cropunity/views/utils/env.dart';
import 'package:cropunity/views/utils/helper.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  // Define the Generative Model outside of setState to avoid recreating it every time
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: Env.GoogleGeminiKey,
  );

  // To store messages (initially empty)
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "you");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "FarmAI",profileImage: "assets/images/fpLogo.png");


  @override
  void initState() {
    super.initState();
    // Initialize with a welcome message from geminiUser
    messages = [
      ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Hi, how can I help you today?",
      )
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with AI"),
      ),
      body: DashChat(
        currentUser: currentUser,
        onSend: onSend,
        messages: messages,

      ),
    );
  }

  Future<void> onSend(ChatMessage chatMessage) async {
    FocusScope.of(context).unfocus();
    // Add the user message to the chat
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      // Prepare the prompt and get response from the model
      final prompt = chatMessage.text;
      final response = await model.generateContent([Content.text(prompt)]);

      // Create a new message with the response
      ChatMessage responseMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: response.text ?? "No response text",
      );

      // Update the chat messages
      setState(() {
        messages = [responseMessage, ...messages];
      });

    } catch (error) {
      // Handle errors
      showSnackBar("Error", error.toString());
    }
  }
}
