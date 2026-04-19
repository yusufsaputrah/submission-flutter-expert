import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/watchlist_movie_bloc.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = WatchlistMovieBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovies = [tMovie];

  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistMovieEmpty());
  });

  group('FetchWatchlistMovies', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieHasData(tMovies),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        const WatchlistMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });

  group('LoadWatchlistMovieStatus', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [StatusLoaded] when status is loaded',
      build: () {
        when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistMovieStatus(1)),
      expect: () => [
        const WatchlistMovieStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(1));
      },
    );
  });

  group('AddMovieToWatchlist', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Message, StatusLoaded] when movie is added successfully',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddMovieToWatchlist(tMovieDetail)),
      expect: () => [
        const WatchlistMovieMessage('Added to Watchlist'),
        const WatchlistMovieStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchListStatus.execute(tMovieDetail.id));
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Error, StatusLoaded] when movie adding is unsuccessful',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Add Failed')));
        when(mockGetWatchListStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddMovieToWatchlist(tMovieDetail)),
      expect: () => [
        const WatchlistMovieError('Add Failed'),
        const WatchlistMovieStatusLoaded(false),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchListStatus.execute(tMovieDetail.id));
      },
    );
  });

  group('RemoveMovieFromWatchlist', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Message, StatusLoaded] when movie is removed successfully',
      build: () {
        when(mockRemoveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(const RemoveMovieFromWatchlist(tMovieDetail)),
      expect: () => [
        const WatchlistMovieMessage('Removed from Watchlist'),
        const WatchlistMovieStatusLoaded(false),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchListStatus.execute(tMovieDetail.id));
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Error, StatusLoaded] when movie removal is unsuccessful',
      build: () {
        when(mockRemoveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Remove Failed')));
        when(mockGetWatchListStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const RemoveMovieFromWatchlist(tMovieDetail)),
      expect: () => [
        const WatchlistMovieError('Remove Failed'),
        const WatchlistMovieStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchListStatus.execute(tMovieDetail.id));
      },
    );
  });
}
