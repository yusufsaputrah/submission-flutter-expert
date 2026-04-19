import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';


import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';

import 'top_rated_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late TopRatedTvsBloc bloc;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TopRatedTvsBloc(mockGetTopRatedTvs);
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
    expect(bloc.state, TopRatedTvsEmpty());
  });

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tData));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [
      TopRatedTvsLoading(),
      TopRatedTvsHasData(tData),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [
      TopRatedTvsLoading(),
      const TopRatedTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );
}
