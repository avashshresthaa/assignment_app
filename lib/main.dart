import 'package:assignment_app/bloc/post/post_bloc.dart';
import 'package:assignment_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/post_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => PostRepository(),
      child: BlocProvider(
        create: (context) =>
            PostBloc(postRepository: context.read<PostRepository>()),
        child: MaterialApp(
          title: 'Assignment App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ), // Input focus border
              ),
              border: OutlineInputBorder(),
            ),
            iconTheme: const IconThemeData(color: Colors.blue),
          ),
          initialRoute: AppRoutes.home,
          routes: AppRoutes.getRoutes(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
