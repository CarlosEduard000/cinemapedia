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
      limit: 10,
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

  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await localStorageRepository.isFavoriteMovie(movie.id);
    await localStorageRepository.toggleFavoriteMovie(movie);

    // if (isFavorite) {
    //   state.remove(movie.id);
    //   state = {...state};
    //   return;
    // }

    // state = {...state, movie.id: movie};
    
     if (isFavorite) {
      // --- INICIO DE LA CORRECCIÓN ---
      final newState = {...state}; // 1. Crea una copia del mapa actual.
      newState.remove(movie.id);   // 2. Elimina el elemento de la COPIA.
      state = newState;            // 3. Asigna la copia modificada como el nuevo estado.
      // --- FIN DE LA CORRECCIÓN ---
    } else {
      // Esta parte ya estaba bien, porque crea un nuevo mapa.
      state = {...state, movie.id: movie};
    }
  }
}
