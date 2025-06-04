import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await di.init();
  
  Bloc.observer = AppBlocObserver();
  
  runApp(const App());
}

class AppBlocObserver extends BlocObserver {
  // ... código del observer
} 