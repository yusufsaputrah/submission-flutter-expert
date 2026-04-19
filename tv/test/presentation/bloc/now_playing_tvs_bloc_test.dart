import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';


import 'package:tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:tv/presentation/bloc/now_playing_tvs_bloc.dart';

import 'now_playing_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvs])
void main() {
  late NowPlayingTvsBloc bloc;
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    bloc = NowPlayingTvsBloc(mockGetNowPlayingTvs);
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
    expect(bloc.state, NowPlayingTvsEmpty());
  });

  blocTest<NowPlayingTvsBloc, NowPlayingTvsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingTvs.execute())
          .thenAnswer((_) async => Right(tData));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTvs()),
    expect: () => [
      NowPlayingTvsLoading(),
      NowPlayingTvsHasData(tData),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTvs.execute());
    },
  );

  blocTest<NowPlayingTvsBloc, NowPlayingTvsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetNowPlayingTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTvs()),
    expect: () => [
      NowPlayingTvsLoading(),
      NowPlayingTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTvs.execute());
    },
  );
}
