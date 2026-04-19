import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv_detail.dart';

import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    bloc = TvDetailBloc(mockGetTvDetail);
  });

  const tData = TvDetail(
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
    expect(bloc.state, TvDetailEmpty());
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvDetail.execute(1))
          .thenAnswer((_) async => const Right(tData));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchTvDetail(1)),
    expect: () => [
      TvDetailLoading(),
      const TvDetailHasData(tData),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(1));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetTvDetail.execute(1))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchTvDetail(1)),
    expect: () => [
      TvDetailLoading(),
      const TvDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(1));
    },
  );
}
