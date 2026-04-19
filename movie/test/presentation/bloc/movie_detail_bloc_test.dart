import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    bloc = MovieDetailBloc(mockGetMovieDetail);
  });

  const tData = MovieDetail(
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
    expect(bloc.state, MovieDetailEmpty());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => const Right(tData));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(1)),
    expect: () => [
      MovieDetailLoading(),
      const MovieDetailHasData(tData),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(1));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(1)),
    expect: () => [
      MovieDetailLoading(),
      const MovieDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(1));
    },
  );
}
