import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/entities/tv.dart';


abstract class PopularTvsEvent extends Equatable {
  const PopularTvsEvent();
  @override
  List<Object> get props => [];
}
class FetchPopularTvs extends PopularTvsEvent {
}

abstract class PopularTvsState extends Equatable {
  const PopularTvsState();
  @override
  List<Object> get props => [];
}

class PopularTvsEmpty extends PopularTvsState {}
class PopularTvsLoading extends PopularTvsState {}
class PopularTvsError extends PopularTvsState {
  final String message;
  const PopularTvsError(this.message);
  @override
  List<Object> get props => [message];
}
class PopularTvsHasData extends PopularTvsState {
  final List<Tv> result;
  const PopularTvsHasData(this.result);
  @override
  List<Object> get props => [result];
}

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs usecase;
  PopularTvsBloc(this.usecase) : super(PopularTvsEmpty()) {
    on<FetchPopularTvs>((event, emit) async {
      emit(PopularTvsLoading());
      final result = await usecase.execute();
      result.fold(
        (failure) => emit(PopularTvsError(failure.message)),
        (data) => emit(PopularTvsHasData(data)),
      );
    });
  }
}
