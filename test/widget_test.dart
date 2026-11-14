import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_game/quations.dart';
import 'package:test_game/question_brain.dart';

void main() {
  testWidgets('Quiz screen displays questions and options', (WidgetTester tester) async {
    // Arrange
    QuestionBrain questionBrain = QuestionBrain();
    await tester.pumpWidget(MaterialApp(home: Quations()));

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(Text), findsWidgets); // Check if there are text widgets
    expect(find.byType(ElevatedButton), findsNWidgets(4)); // Check if there are 4 answer buttons
  });

  testWidgets('Progress indicator updates correctly', (WidgetTester tester) async {
    // Arrange
    QuestionBrain questionBrain = QuestionBrain();
    await tester.pumpWidget(MaterialApp(home: Quations()));

    // Act
    await tester.tap(find.byType(ElevatedButton).first); // Simulate answering the first question
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('السؤال 2 من 12'), findsOneWidget); // Check if the question number updates
  });

  testWidgets('Navigating back to home screen', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(home: Quations()));

    // Act
    await tester.tap(find.byIcon(Icons.home)); // Simulate tapping the home button
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(Home), findsOneWidget); // Check if we are back on the Home screen
  });
}