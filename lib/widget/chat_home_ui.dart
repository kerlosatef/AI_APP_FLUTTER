import 'dart:io';
import 'dart:typed_data';

import 'package:ai_app/widget/cubit/theme_cubit.dart';
import 'package:ai_app/widget/theme_dark_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatHomeUi extends StatefulWidget {
  const ChatHomeUi({super.key});

  @override
  State<ChatHomeUi> createState() => _ChatHomeUiState();
}

class _ChatHomeUiState extends State<ChatHomeUi> {
  final Gemini gemini = Gemini.instance;
  ChatUser user = ChatUser(
      id: '0',
      firstName: 'User',
      profileImage: "https://i.ibb.co/MyfkF5hC/photo-2022-12-17-21-19-25.jpg");

  ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: 'KERO AI',
  );
  List<ChatMessage> messages = [];
  @override
  Widget build(BuildContext context) {
    final themeCubit = BlocProvider.of<ThemeCubit>(context);
    final isDarkMode = themeCubit.state.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('KERO AI'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                themeCubit.toggleTheme();
              },
              child: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ),
        ],
      ),
      body: _buildChat(),
    );
  }

  Widget _buildChat() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DashChat(
      inputOptions: InputOptions(
        sendButtonBuilder: (Function onSend) {
          return IconButton(
            onPressed: () => onSend(),
            icon: Icon(Icons.send,
                color: isDarkMode
                    ? Colors.white
                    : Colors.black), // لون مختلف حسب الـ Theme
          );
        },
        inputTextStyle:
            TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        cursorStyle:
            CursorStyle(color: isDarkMode ? Colors.white : Colors.black),
        inputDecoration: InputDecoration(
          filled: true,
          fillColor: isDarkMode
              ? Colors.grey[800]
              : Colors.grey[300], // خلفية الـ TextField
          hintText: "Type a message...",
          hintStyle: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // نفس الـ default
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: 12, horizontal: 16), // تحافظ على الحجم الافتراضي
        ),
        trailing: [
          IconButton(
            onPressed: _sendMedia,
            icon: Icon(Icons.image,
                color: isDarkMode ? Colors.white : Colors.black),
          ),
        ],
      ),
      messageOptions: MessageOptions(
        currentUserContainerColor:
            isDarkMode ? Colors.blue[800]! : Colors.grey[300]!,
        containerColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        textColor: isDarkMode ? Colors.white : Colors.black,
        currentUserTextColor: isDarkMode ? Colors.white : Colors.white,
      ),
      currentUser: user,
      onSend: _onSend,
      messages: messages,
    );
  }

  void _onSend(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images = [];
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url!).readAsBytesSync()];
      }

      // ignore: deprecated_member_use
      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  '', (previous, current) => "$previous${current.text}") ??
              '';
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  '', (previous, current) => "$previous${current.text}") ??
              '';
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMedia() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage message = ChatMessage(
        user: user,
        createdAt: DateTime.now(),
        text: "Describe this picture",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image)
        ],
      );

      _onSend(message);
    }
  }
}
