import 'package:assignment_app/models/post_models.dart';
import 'package:assignment_app/repositories/post_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  List<PostModel> _allPosts = [];

  PostBloc({required this.postRepository}) : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      // Fetch once and reuse full list for filtering
      if (_allPosts.isEmpty) {
        _allPosts = await postRepository.fetchPosts();
      }

      if (event.filterUserId == null) {
        emit(PostLoaded(_allPosts));
      } else {
        final filtered = _allPosts
            .where((post) => post.userId == event.filterUserId)
            .toList();
        emit(PostLoaded(filtered));
      }
    } catch (e) {
      emit(PostError('Failed to load posts. Please try again.'));
    }
  }
}
