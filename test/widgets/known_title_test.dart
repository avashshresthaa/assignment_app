import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import 'package:assignment_app/bloc/post/post_bloc.dart';
import 'package:assignment_app/models/post_models.dart';
import 'package:assignment_app/screens/home_screen.dart';

import '../mocks.mocks.dart';

void main() {
  testWidgets('shows known post title when data loads', (
    WidgetTester tester,
  ) async {
    // Arrange
    final mockRepo = MockPostRepository();
    final mockPosts = [
      PostModel(
        userId: 1,
        id: 1,
        title: 'This is a known post title',
        body: '...',
      ),
    ];

    when(mockRepo.fetchPosts()).thenAnswer((_) async => mockPosts);

    // Build UI
    await tester.pumpWidget(
      MaterialApp(
        home: RepositoryProvider.value(
          value: mockRepo,
          child: BlocProvider(
            create: (_) =>
                PostBloc(postRepository: mockRepo)..add(const LoadPosts()),
            child: const HomeScreen(),
          ),
        ),
      ),
    );

    await tester.pump(); // Frame 1
    await tester.pump(const Duration(seconds: 1)); // Wait for async load

    // Assert that known title is shown
    expect(find.text('This is a known post title'), findsOneWidget);
  });
}
