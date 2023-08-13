import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/provider/todo_provider.dart';
import 'package:todo_app/presentation/screen/main_screen.dart';
import 'service_locator.dart' as serviceLocator;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => serviceLocator.sl<TodoChangeNotifier>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo list',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(),
      ),
    );
  }
}
