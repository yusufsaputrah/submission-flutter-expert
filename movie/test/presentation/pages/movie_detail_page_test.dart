import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState> implements MovieDetailBloc {}
class MockMovieRecommendationsBloc extends MockBloc<MovieRecommendationsEvent, MovieRecommendationsState> implements MovieRecommendationsBloc {}
class MockWatchlistMovieBloc extends MockBloc<WatchlistMovieEvent, WatchlistMovieState> implements WatchlistMovieBloc {}
class MockPopularMoviesBloc extends MockBloc<PopularMoviesEvent, PopularMoviesState> implements PopularMoviesBloc {}
class MockTopRatedMoviesBloc extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState> implements TopRatedMoviesBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}
class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationsBloc mockMovieRecommendationsBloc;
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationsBloc = MockMovieRecommendationsBloc();
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<MovieRecommendationsBloc>.value(value: mockMovieRecommendationsBloc),
        BlocProvider<WatchlistMovieBloc>.value(value: mockWatchlistMovieBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Watchlist button should display add icon when movie not added to watchlist', (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(() => mockMovieRecommendationsBloc.state).thenReturn(MovieRecommendationsLoading());
    when(() => mockWatchlistMovieBloc.state).thenReturn(WatchlistMovieStatusLoaded(false));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
