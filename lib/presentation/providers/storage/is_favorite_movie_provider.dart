import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isFavoriteMovieProvider = FutureProvider.family<bool, int>((
  ref,
  movieId,
) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isFavoriteMovie(movieId);
});
