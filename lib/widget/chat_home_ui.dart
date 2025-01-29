import 'package:ai_app/widget/cubit/theme_cubit.dart';
import 'package:ai_app/widget/theme_dark_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ChatHomeUi extends StatefulWidget {
  const ChatHomeUi({super.key});

  @override
  State<ChatHomeUi> createState() => _ChatHomeUiState();
}

class _ChatHomeUiState extends State<ChatHomeUi> {
  @override
  Widget build(BuildContext context) {
    final themeCubit = BlocProvider.of<ThemeCubit>(context);
    final isDarkMode = themeCubit.state.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kero AI'),
        actions: [
          GestureDetector(
            onTap: () {
              themeCubit.toggleTheme();
            },
            child: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        ],
      ),
    );
  }
}
