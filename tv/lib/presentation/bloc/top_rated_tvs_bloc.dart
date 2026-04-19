import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/entities/tv.dart';


abstract class TopRatedTvsEvent extends Equatable {
  const TopRatedTvsEvent();
  @override
  List<Object> get props => [];
}
class FetchTopRatedTvs extends TopRatedTvsEvent {
}

abstract class TopRatedTvsState extends Equatable {
  const TopRatedTvsState();
  @override
  List<Object> get props => [];
}

class TopRatedTvsEmpty extends TopRatedTvsState {}
class TopRatedTvsLoading extends TopRatedTvsState {}
class TopRatedTvsError extends TopRatedTvsState {
  final String message;
  const TopRatedTvsError(this.message);
  @override
  List<Object> get props => [message];
}
class TopRatedTvsHasData extends TopRatedTvsState {
  final List<Tv> result;
  const TopRatedTvsHasData(this.result);
  @override
  List<Object> get props => [result];
}

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs usecase;
  TopRatedTvsBloc(this.usecase) : super(TopRatedTvsEmpty()) {
    on<FetchTopRatedTvs>((event, emit) async {
      emit(TopRatedTvsLoading());
      final result = await usecase.execute();
      result.fold(
        (failure) => emit(TopRatedTvsError(failure.message)),
        (data) => emit(TopRatedTvsHasData(data)),
      );
    });
  }
}
