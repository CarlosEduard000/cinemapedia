/*
{
  1:Movie,
  2:Movie,
  3:Movie,
  4:Movie
}
*/

import 'package:cinemapedia/domain/domain.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/legacy.dart';

final favoriteMoviesProvider = StateNotifierProvider((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadFavoriteMovies(
      limit: 20,
      offset: page * 10,
    );

    final tempMovies = <int, Movie>{};

    page++;
    for (final movie in movies) {
      tempMovies[movie.id] = movie;
    }

    state = {...state, ...tempMovies};

    return movies;
  }

  Future<void> toggleFavorite( Movie movie ) async { 
    await localStorageRepository.toggleFavoriteMovie(movie);
    final bool isMovieInFavorites = state[movie.id] != null;

    if ( isMovieInFavorites ) {
      state.remove(movie.id);
      state = { ...state };
    } else {
      state = { ...state, movie.id: movie };
    }

  }
}
