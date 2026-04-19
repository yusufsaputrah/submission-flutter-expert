import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';


abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();
  @override
  List<Object> get props => [];
}
class FetchTvDetail extends TvDetailEvent {
  final int id;
  const FetchTvDetail(this.id);
  @override
  List<Object> get props => [id];
}

abstract class TvDetailState extends Equatable {
  const TvDetailState();
  @override
  List<Object> get props => [];
}

class TvDetailEmpty extends TvDetailState {}
class TvDetailLoading extends TvDetailState {}
class TvDetailError extends TvDetailState {
  final String message;
  const TvDetailError(this.message);
  @override
  List<Object> get props => [message];
}
class TvDetailHasData extends TvDetailState {
  final TvDetail result;
  const TvDetailHasData(this.result);
  @override
  List<Object> get props => [result];
}

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail usecase;
  TvDetailBloc(this.usecase) : super(TvDetailEmpty()) {
    on<FetchTvDetail>((event, emit) async {
      emit(TvDetailLoading());
      final result = await usecase.execute(event.id);
      result.fold(
        (failure) => emit(TvDetailError(failure.message)),
        (data) => emit(TvDetailHasData(data)),
      );
    });
  }
}
