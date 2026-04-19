import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watchlist_tv_bloc.dart';

import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvs,
  GetWatchlistTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late WatchlistTvBloc bloc;
  late MockGetWatchlistTvs mockGetWatchlistTvs;
  late MockGetWatchlistTvStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    mockGetWatchlistTvStatus = MockGetWatchlistTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    bloc = WatchlistTvBloc(
      getWatchlistTvs: mockGetWatchlistTvs,
      getWatchListStatusTv: mockGetWatchlistTvStatus,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
  });

  const tTv = Tv(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvs = [tTv];

  const tTvDetail = TvDetail(
    backdropPath: 'backdropPath',
    genres: [],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
    seasons: [],
  );

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistTvEmpty());
  });

  group('FetchWatchlistTvs', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Right(tTvs));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvs()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvHasData(tTvs),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvs()),
      expect: () => [
        WatchlistTvLoading(),
        const WatchlistTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      },
    );
  });

  group('LoadWatchlistTvStatus', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [StatusLoaded] when status is loaded',
      build: () {
        when(mockGetWatchlistTvStatus.execute(1)).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistTvStatus(1)),
      expect: () => [
        const WatchlistTvStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvStatus.execute(1));
      },
    );
  });

  group('AddTvToWatchlist', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Message, StatusLoaded] when TV is added successfully',
      build: () {
        when(mockSaveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddTvToWatchlist(tTvDetail)),
      expect: () => [
        const WatchlistTvMessage('Added to Watchlist'),
        const WatchlistTvStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(tTvDetail));
        verify(mockGetWatchlistTvStatus.execute(tTvDetail.id));
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Error, StatusLoaded] when TV adding is unsuccessful',
      build: () {
        when(mockSaveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Add Failed')));
        when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddTvToWatchlist(tTvDetail)),
      expect: () => [
        const WatchlistTvError('Add Failed'),
        const WatchlistTvStatusLoaded(false),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(tTvDetail));
        verify(mockGetWatchlistTvStatus.execute(tTvDetail.id));
      },
    );
  });

  group('RemoveTvFromWatchlist', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Message, StatusLoaded] when TV is removed successfully',
      build: () {
        when(mockRemoveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(const RemoveTvFromWatchlist(tTvDetail)),
      expect: () => [
        const WatchlistTvMessage('Removed from Watchlist'),
        const WatchlistTvStatusLoaded(false),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(tTvDetail));
        verify(mockGetWatchlistTvStatus.execute(tTvDetail.id));
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Error, StatusLoaded] when TV removal is unsuccessful',
      build: () {
        when(mockRemoveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Remove Failed')));
        when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const RemoveTvFromWatchlist(tTvDetail)),
      expect: () => [
        const WatchlistTvError('Remove Failed'),
        const WatchlistTvStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(tTvDetail));
        verify(mockGetWatchlistTvStatus.execute(tTvDetail.id));
      },
    );
  });
}
