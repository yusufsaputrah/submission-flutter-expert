import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';


import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:tv/presentation/bloc/search_tvs_bloc.dart';

import 'search_tvs_bloc_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late SearchTvsBloc bloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    bloc = SearchTvsBloc(mockSearchTvs);
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
    expect(bloc.state, SearchTvsEmpty());
  });

  blocTest<SearchTvsBloc, SearchTvsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvs.execute('spiderman'))
          .thenAnswer((_) async => Right(tData));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchSearchTvs('spiderman')),
    expect: () => [
      SearchTvsLoading(),
      SearchTvsHasData(tData),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute('spiderman'));
    },
  );

  blocTest<SearchTvsBloc, SearchTvsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockSearchTvs.execute('spiderman'))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchSearchTvs('spiderman')),
    expect: () => [
      SearchTvsLoading(),
      SearchTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute('spiderman'));
    },
  );
}
