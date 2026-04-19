import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';

class MockTopRatedTvsBloc extends MockBloc<TopRatedTvsEvent, TopRatedTvsState> implements TopRatedTvsBloc {}

void main() {
  late MockTopRatedTvsBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTvsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvsBloc>.value(
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
    when(() => mockBloc.state).thenReturn(TopRatedTvsLoading());

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTvsHasData(tTvList));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTvsError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(find.text('Error message'), findsOneWidget);
  });
}
