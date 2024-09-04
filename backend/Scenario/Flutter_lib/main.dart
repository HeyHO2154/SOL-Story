import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/key_model.dart';
import 'models/owned_cards_model.dart';
import 'story_main.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => KeyModel()),
        ChangeNotifierProvider(create: (context) => OwnedCardsModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoryMain(),
    );
  }
}
