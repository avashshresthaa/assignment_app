part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPosts extends PostEvent {
  final int? filterUserId;

  const LoadPosts({this.filterUserId});

  @override
  List<Object> get props => [?filterUserId];
}
