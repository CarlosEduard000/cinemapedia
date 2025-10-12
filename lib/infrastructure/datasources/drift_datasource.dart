import 'package:cinemapedia/config/database/database.dart';
import 'package:cinemapedia/domain/domain.dart';
import 'package:drift/drift.dart' as drift;

class DriftDatasource extends LocalStorageDatasource {
  final AppDatabase database;

  DriftDatasource([AppDatabase? databaseToUse])
    : database = databaseToUse ?? db;

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    //Construir el query
    final query = database.select(database.favoriteMovies)
      ..where((table) => table.movieId.equals(movieId));

    //Ejecutar el query
    final favoriteMovie = await query.getSingleOrNull();

    //Retonar el query
    return favoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadFavoriteMovies({
    int limit = 10,
    int offset = 0,
  }) async {
    //Query
    final query = database.select(database.favoriteMovies)
      ..limit(limit, offset: offset);

    //Ejecutar el query
    final favoriteMovieRows = await query.get();

    final movies = favoriteMovieRows
        .map(
          (row) => Movie(
            adult: false,
            backdropPath: row.backdropPath,
            genreIds: const [],
            id: row.movieId,
            originalLanguage: '',
            originalTitle: row.originalTitle,
            overview: '',
            popularity: 0,
            posterPath: row.posterPath,
            releaseDate: DateTime.now(),
            title: row.title,
            video: false,
            voteAverage: row.voteAverage,
            voteCount: 0,
          ),
        )
        .toList();

    return movies;
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await isFavoriteMovie(movie.id);

    if (isFavorite) {
      final deleteQuery = database.delete(database.favoriteMovies)
        ..where((table) => table.movieId.equals(movie.id));

      await deleteQuery.go();
      return;
    }

    await database
        .into(database.favoriteMovies)
        .insert(
          FavoriteMoviesCompanion.insert(
            movieId: movie.id,
            backdropPath: movie.backdropPath,
            originalTitle: movie.originalTitle,
            title: movie.title,
            posterPath: movie.posterPath,
            voteAverage: drift.Value(movie.voteAverage),
          ),
        );
  }
}
