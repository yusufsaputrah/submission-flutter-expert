import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';


import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';

import 'popular_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late PopularTvsBloc bloc;
  late MockGetPopularTvs mockGetPopularTvs;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    bloc = PopularTvsBloc(mockGetPopularTvs);
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
  final tData = <Tv>[tTv];

  test('initial state should be empty', () {
    expect(bloc.state, PopularTvsEmpty());
  });

  blocTest<PopularTvsBloc, PopularTvsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(tData));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvs()),
    expect: () => [
      PopularTvsLoading(),
      PopularTvsHasData(tData),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );

  blocTest<PopularTvsBloc, PopularTvsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvs()),
    expect: () => [
      PopularTvsLoading(),
      const PopularTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );
}
