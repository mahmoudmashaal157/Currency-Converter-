import 'package:bloc/bloc.dart';
import 'package:currency_converter/screens/exchange_rate/exchange_rate_screen.dart';
import 'package:currency_converter/shared/bloc_observer/bloc_observer.dart';
import 'package:currency_converter/shared/cache_helper.dart';
import 'package:currency_converter/shared/dio_helper.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Cache_Helper.sharedPrefernceInstance();
  DioHelper.dioInit();

  BlocOverrides.runZoned (() {

    runApp(MyApp());
  },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home:ExchangeRateScreen(),
    );
  }
}
