import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/legacy.dart';

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
      final actorsRepository = ref.watch(actorsRepositoryProvider);

      return ActorsByMovieNotifier(
        getActors: actorsRepository.getActorsByMovie,
      );
    });

/*
  {
    '50555': <Actor>[],
    '50556': <Actor>[],
    '50557': <Actor>[],
    '50558': <Actor>[],
    '50559': <Actor>[],
    '50560': <Actor>[],
  }
 */

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;

    final List<Actor> actors = await getActors(movieId);

    state = {...state, movieId: actors};
  }
}
