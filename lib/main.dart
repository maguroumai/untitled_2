import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled_2/firebase_options.dart';
import 'package:untitled_2/presentation/pages/account_page.dart';
import 'package:untitled_2/presentation/pages/sign_in_page.dart';
import 'package:untitled_2/presentation/pages/sign_up_page.dart';
import 'package:untitled_2/utils/logger.dart';

import 'presentation/pages/todo/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.configure();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _currentIndex = 0;

  List<Widget> pages = [
    Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blue[100],
      child: const Center(
        child: SingUpPage(),
      ),
    ),
    Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.green[100],
      child: const Center(
        child: SingInPage(),
      ),
    ),
    Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.green[100],
      child: const Center(
        child: AccountPage(),
      ),
    ),
    Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.green[100],
      child: const Center(
        child: TodoPage(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.add_box),
            icon: Icon(Icons.add_box_outlined),
            label: '新規登録',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.login),
            icon: Icon(Icons.login_outlined),
            label: 'ログイン',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'アカウント',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.task_rounded),
            icon: Icon(Icons.task_outlined),
            label: 'TODO',
          ),
        ],
      ),
    );
  }
}
