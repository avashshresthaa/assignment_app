import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import 'package:assignment_app/bloc/post/post_bloc.dart';
import 'package:assignment_app/models/post_models.dart';
import 'package:assignment_app/screens/home_screen.dart';

import '../mocks.mocks.dart';

void main() {
  testWidgets('filters posts by userId == 1 when "1" is entered', (
    WidgetTester tester,
  ) async {
    final mockRepo = MockPostRepository();
    final mockPosts = [
      PostModel(userId: 1, id: 1, title: 'Post by user 1', body: '...'),
      PostModel(userId: 2, id: 2, title: 'Post by user 2', body: '...'),
    ];

    when(mockRepo.fetchPosts()).thenAnswer((_) async => mockPosts);

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

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final inputField = find.byType(TextField);
    await tester.enterText(inputField, '1');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Post by user 1'), findsOneWidget);
    expect(find.text('Post by user 2'), findsNothing);
  });
}
