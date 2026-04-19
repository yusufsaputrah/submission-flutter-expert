import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/now_playing_tvs_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';

class MockNowPlayingTvsBloc extends MockBloc<NowPlayingTvsEvent, NowPlayingTvsState> implements NowPlayingTvsBloc {}
class MockPopularTvsBloc extends MockBloc<PopularTvsEvent, PopularTvsState> implements PopularTvsBloc {}
class MockTopRatedTvsBloc extends MockBloc<TopRatedTvsEvent, TopRatedTvsState> implements TopRatedTvsBloc {}

void main() {
  late MockNowPlayingTvsBloc mockNowPlayingBloc;
  late MockPopularTvsBloc mockPopularBloc;
  late MockTopRatedTvsBloc mockTopRatedBloc;

  setUp(() {
    mockNowPlayingBloc = MockNowPlayingTvsBloc();
    mockPopularBloc = MockPopularTvsBloc();
    mockTopRatedBloc = MockTopRatedTvsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingTvsBloc>.value(value: mockNowPlayingBloc),
        BlocProvider<PopularTvsBloc>.value(value: mockPopularBloc),
        BlocProvider<TopRatedTvsBloc>.value(value: mockTopRatedBloc),
      ],
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

  testWidgets('Page should display progress indicator when loading', (WidgetTester tester) async {
    when(() => mockNowPlayingBloc.state).thenReturn(NowPlayingTvsLoading());
    when(() => mockPopularBloc.state).thenReturn(PopularTvsLoading());
    when(() => mockTopRatedBloc.state).thenReturn(TopRatedTvsLoading());

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    when(() => mockNowPlayingBloc.state).thenReturn(NowPlayingTvsHasData(tTvList));
    when(() => mockPopularBloc.state).thenReturn(PopularTvsHasData(tTvList));
    when(() => mockTopRatedBloc.state).thenReturn(TopRatedTvsHasData(tTvList));

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('Page should display error message when failed', (WidgetTester tester) async {
    when(() => mockNowPlayingBloc.state).thenReturn(NowPlayingTvsError('Failed'));
    when(() => mockPopularBloc.state).thenReturn(PopularTvsError('Failed'));
    when(() => mockTopRatedBloc.state).thenReturn(TopRatedTvsError('Failed'));

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.text('Failed'), findsWidgets);
  });
}
