import 'dart:io';
import 'package:assignment_app/bloc/post/post_bloc.dart';
import 'package:assignment_app/widgets/app_drawer.dart';
import 'package:assignment_app/widgets/post_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _errorText;
  int _visibleCount = 10;
  bool _endReached = false;
  bool _isLoadingMore = false;

  void _onFilterChanged() {
    final input = _controller.text.trim();
    final userId = int.tryParse(input);

    setState(() {
      _visibleCount = 10;
      _endReached = false;
    });

    if (input.isEmpty) {
      setState(() => _errorText = null);
      context.read<PostBloc>().add(const LoadPosts());
    } else if (userId != null && userId >= 1 && userId <= 10) {
      setState(() => _errorText = null);
      context.read<PostBloc>().add(LoadPosts(filterUserId: userId));
    } else {
      setState(() => _errorText = 'Enter a number from 1 to 10');
      context.read<PostBloc>().add(const LoadPosts());
    }
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_endReached &&
          !_isLoadingMore) {
        setState(() => _isLoadingMore = true);

        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;

          final currentState = context.read<PostBloc>().state;
          if (currentState is PostLoaded) {
            final total = currentState.posts.length;
            final newCount = _visibleCount + 10;

            setState(() {
              if (newCount >= total) {
                _visibleCount = total;
                _endReached = true;
              } else {
                _visibleCount = newCount;
              }
              _isLoadingMore = false;
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    context.read<PostBloc>().add(const LoadPosts());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('All Posts', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      backgroundColor: Colors.blue,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildTextField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = Colors.blueAccent;
    final fillColor = isDark ? Colors.grey[900] : Colors.white;

    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: hasFocus
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _onFilterChanged(),
              decoration: InputDecoration(
                hintText: 'Filter by User ID',
                errorText: _errorText,
                prefixIcon: const Icon(Icons.filter_alt_outlined),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onFilterChanged,
                ),
                filled: true,
                fillColor: fillColor,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _buildTextField(),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PostLoaded) {
                  final posts = state.posts.take(_visibleCount).toList();
                  return ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index < posts.length) {
                        return PostTile(post: posts[index]);
                      } else if (_isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (_endReached) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: Text('You’ve reached the end')),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                } else if (state is PostError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PostBloc>().add(const LoadPosts());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FF),
      appBar: _buildAppBar(),
      drawer: const AppDrawer(),
      body: _buildBody(),
    );
  }
}
