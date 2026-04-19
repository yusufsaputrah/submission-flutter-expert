import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/search_movies_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/pages/search_page.dart';

class MockSearchMoviesBloc extends MockBloc<SearchMoviesEvent, SearchMoviesState> implements SearchMoviesBloc {}

void main() {
  late MockSearchMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockSearchMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth43uS2uzv03nmbQYQZ2olmG.jpg',
    genreIds: [14, 28],
    id: 531219,
    originalTitle: 'Roald Dahl\'s The Witches',
    overview:
        'Official synopsis currently unavailable. Roald Dahl\'s The Witches is a movie starring Anne Hathaway, Octavia Spencer, and Stanley Tucci.',
    popularity: 47.92,
    posterPath: '/betExiwszqvZ1uGqy4wnUR9ZpC5.jpg',
    releaseDate: '2020-10-25',
    title: 'Roald Dahl\'s The Witches',
    video: false,
    voteAverage: 6.8,
    voteCount: 176,
  );
  final tMovieList = [tMovieModel];

  testWidgets('Page should display center progress indicator when loading', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchMoviesLoading());

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchMoviesHasData(tMovieList));

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchMoviesError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display empty container when state is empty', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchMoviesEmpty());

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.byType(Container), findsWidgets);
  });
}
