// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:garage_guru/main.dart';
import 'package:garage_guru/screens/auth/landing_screen.dart';

void main() {
  testWidgets('GarageGuru opens on the landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GarageGuruApp());
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(LandingScreen), findsOneWidget);
  });
}
