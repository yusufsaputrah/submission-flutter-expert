import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState> implements MovieDetailBloc {}
class MockMovieRecommendationsBloc extends MockBloc<MovieRecommendationsEvent, MovieRecommendationsState> implements MovieRecommendationsBloc {}
class MockWatchlistMovieBloc extends MockBloc<WatchlistMovieEvent, WatchlistMovieState> implements WatchlistMovieBloc {}
class MockPopularMoviesBloc extends MockBloc<PopularMoviesEvent, PopularMoviesState> implements PopularMoviesBloc {}
class MockTopRatedMoviesBloc extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState> implements TopRatedMoviesBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}
class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockPopularMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress indicator when loading', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularMoviesLoading());

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
