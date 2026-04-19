import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';


import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/tv_recommendations_bloc.dart';

import 'tv_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetTvRecommendations])
void main() {
  late TvRecommendationsBloc bloc;
  late MockGetTvRecommendations mockGetTvRecommendations;

  setUp(() {
    mockGetTvRecommendations = MockGetTvRecommendations();
    bloc = TvRecommendationsBloc(mockGetTvRecommendations);
  });

  final tTv = Tv(
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
  final tData = <Tv>[tTv];

  test('initial state should be empty', () {
    expect(bloc.state, TvRecommendationsEmpty());
  });

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvRecommendations.execute(1))
          .thenAnswer((_) async => Right(tData));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTvRecommendations(1)),
    expect: () => [
      TvRecommendationsLoading(),
      TvRecommendationsHasData(tData),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(1));
    },
  );

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetTvRecommendations.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTvRecommendations(1)),
    expect: () => [
      TvRecommendationsLoading(),
      TvRecommendationsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(1));
    },
  );
}
