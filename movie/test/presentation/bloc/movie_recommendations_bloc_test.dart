import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';


import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/presentation/bloc/movie_recommendations_bloc.dart';

import 'movie_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationsBloc bloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    bloc = MovieRecommendationsBloc(mockGetMovieRecommendations);
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
  final tData = <Movie>[tMovie];

  test('initial state should be empty', () {
    expect(bloc.state, MovieRecommendationsEmpty());
  });

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Right(tData));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMovieRecommendations(1)),
    expect: () => [
      MovieRecommendationsLoading(),
      MovieRecommendationsHasData(tData),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(1));
    },
  );

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMovieRecommendations(1)),
    expect: () => [
      MovieRecommendationsLoading(),
      const MovieRecommendationsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(1));
    },
  );
}
