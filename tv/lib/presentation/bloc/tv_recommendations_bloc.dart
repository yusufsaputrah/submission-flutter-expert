import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/entities/tv.dart';


abstract class TvRecommendationsEvent extends Equatable {
  const TvRecommendationsEvent();
  @override
  List<Object> get props => [];
}
class FetchTvRecommendations extends TvRecommendationsEvent {
  final int id;
  const FetchTvRecommendations(this.id);
  @override
  List<Object> get props => [id];
}

abstract class TvRecommendationsState extends Equatable {
  const TvRecommendationsState();
  @override
  List<Object> get props => [];
}

class TvRecommendationsEmpty extends TvRecommendationsState {}
class TvRecommendationsLoading extends TvRecommendationsState {}
class TvRecommendationsError extends TvRecommendationsState {
  final String message;
  const TvRecommendationsError(this.message);
  @override
  List<Object> get props => [message];
}
class TvRecommendationsHasData extends TvRecommendationsState {
  final List<Tv> result;
  const TvRecommendationsHasData(this.result);
  @override
  List<Object> get props => [result];
}

class TvRecommendationsBloc extends Bloc<TvRecommendationsEvent, TvRecommendationsState> {
  final GetTvRecommendations usecase;
  TvRecommendationsBloc(this.usecase) : super(TvRecommendationsEmpty()) {
    on<FetchTvRecommendations>((event, emit) async {
      emit(TvRecommendationsLoading());
      final result = await usecase.execute(event.id);
      result.fold(
        (failure) => emit(TvRecommendationsError(failure.message)),
        (data) => emit(TvRecommendationsHasData(data)),
      );
    });
  }
}
