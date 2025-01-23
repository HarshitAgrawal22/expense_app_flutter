import 'package:expense_app/database/expenseData.dart';
import 'package:expense_app/pages/homePage.dart';
import 'package:expense_app/utilities/noti_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open the hive box
  await Hive.openBox("expenseDB");
  await Hive.openBox("creditDB");
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  NotificationService().requestExactAlarmPermission();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // this is what we are adding to our code to make the data available to all the child elements
    return ChangeNotifierProvider(
        create: (context) => ExpenseData(),
        builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: homePage(),
            ));
  }
}

// Shreyanshi gets angry when she is sleeping
