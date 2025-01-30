import 'package:ai_app/widget/Chat_Home_Ai.dart';
import 'package:ai_app/widget/cubit/theme_cubit.dart';
import 'package:ai_app/widget/theme_dark_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

const apiKey = 'Your_API_Key';

void main() {
  Gemini.init(apiKey: apiKey);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, themeData) {
          return MaterialApp(
            theme: themeData,
            debugShowCheckedModeBanner: false,
            home: ChatHomeAi(),
          );
        },
      ),
    );
  }
}
