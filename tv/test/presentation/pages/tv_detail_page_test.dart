import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_recommendations_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState> implements TvDetailBloc {}
class MockTvRecommendationsBloc extends MockBloc<TvRecommendationsEvent, TvRecommendationsState> implements TvRecommendationsBloc {}
class MockWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState> implements WatchlistTvBloc {}

class FakeTvDetailEvent extends Fake implements TvDetailEvent {}
class FakeTvDetailState extends Fake implements TvDetailState {}

void main() {
  late MockTvDetailBloc mockTvDetailBloc;
  late MockTvRecommendationsBloc mockTvRecommendationsBloc;
  late MockWatchlistTvBloc mockWatchlistTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());
  });

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
    mockTvRecommendationsBloc = MockTvRecommendationsBloc();
    mockWatchlistTvBloc = MockWatchlistTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailBloc>.value(value: mockTvDetailBloc),
        BlocProvider<TvRecommendationsBloc>.value(value: mockTvRecommendationsBloc),
        BlocProvider<WatchlistTvBloc>.value(value: mockWatchlistTvBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Should display center progress indicator when loading', (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailLoading());
    when(() => mockTvRecommendationsBloc.state).thenReturn(TvRecommendationsLoading());
    when(() => mockWatchlistTvBloc.state).thenReturn(WatchlistTvEmpty());

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
