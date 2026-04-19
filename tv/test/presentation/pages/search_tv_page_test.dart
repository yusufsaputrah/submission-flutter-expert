import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/search_tvs_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';

class MockSearchTvsBloc extends MockBloc<SearchTvsEvent, SearchTvsState> implements SearchTvsBloc {}

void main() {
  late MockSearchTvsBloc mockBloc;

  setUp(() {
    mockBloc = MockSearchTvsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvsBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tTv = Tv(
    backdropPath: '/muth43uS2uzv03nmbQYQZ2olmG.jpg',
    genreIds: [14, 28],
    id: 531219,
    originalName: 'The Witches',
    overview: 'Overview',
    popularity: 47.92,
    posterPath: '/betExiwszqvZ1uGqy4wnUR9ZpC5.jpg',
    firstAirDate: '2020-10-25',
    name: 'The Witches',
    voteAverage: 6.8,
    voteCount: 176,
  );
  final tTvList = [tTv];

  testWidgets('Page should display center progress indicator when loading', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchTvsLoading());

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchTvsHasData(tTvList));

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchTvsError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display empty container when state is empty', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchTvsEmpty());

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(find.byType(Container), findsWidgets);
  });
}
