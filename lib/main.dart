import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MediopsApp());
}