part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

/// Initial/default state.
class PostInitial extends PostState {}

/// Loading state while fetching data.
class PostLoading extends PostState {}

/// Loaded successfully with a list of posts.
class PostLoaded extends PostState {
  final List<PostModel> posts;

  const PostLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

/// Error state with a message.
class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object> get props => [message];
}
