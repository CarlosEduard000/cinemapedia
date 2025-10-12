import 'package:cinemapedia/domain/domain.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MoviesMasonry extends StatefulWidget {
  final List<Movie> movies;
  final Future<List<Movie>> Function()? loadNextPage;

  const MoviesMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MoviesMasonry> createState() => _MoviesMasonryState();
}

class _MoviesMasonryState extends State<MoviesMasonry> {
  bool isLastPage = false;
  bool isLoading = false;
  final scroollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scroollController.addListener(() {
      // if (widget.loadNextPage == null) return;
      //Si el scroll esta al final o cerca de unos 200px, aqui llamar al loadNextPage

      if (scroollController.position.pixels + 200 >=
          scroollController.position.maxScrollExtent) {
        loadNextPageMovies();
      }
    });
  }

  @override
  void dispose() {
    scroollController.dispose();
    super.dispose();
  }

  void loadNextPageMovies() async {
    if (isLoading || isLastPage) return;
    if (widget.loadNextPage == null) return;

    isLoading = true;
    final movies = await widget.loadNextPage!();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scroollController,
        crossAxisCount: 3,
        itemCount: widget.movies.length,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 30),
                MoviePosterLink(movie: widget.movies[index]),
              ],
            );
          }
          return MoviePosterLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}
