import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:tv/domain/entities/tv.dart';


abstract class SearchTvsEvent extends Equatable {
  const SearchTvsEvent();
  @override
  List<Object> get props => [];
}
class FetchSearchTvs extends SearchTvsEvent {
  final String query;
  const FetchSearchTvs(this.query);
  @override
  List<Object> get props => [query];
}

abstract class SearchTvsState extends Equatable {
  const SearchTvsState();
  @override
  List<Object> get props => [];
}

class SearchTvsEmpty extends SearchTvsState {}
class SearchTvsLoading extends SearchTvsState {}
class SearchTvsError extends SearchTvsState {
  final String message;
  const SearchTvsError(this.message);
  @override
  List<Object> get props => [message];
}
class SearchTvsHasData extends SearchTvsState {
  final List<Tv> result;
  const SearchTvsHasData(this.result);
  @override
  List<Object> get props => [result];
}

class SearchTvsBloc extends Bloc<SearchTvsEvent, SearchTvsState> {
  final SearchTvs usecase;
  SearchTvsBloc(this.usecase) : super(SearchTvsEmpty()) {
    on<FetchSearchTvs>((event, emit) async {
      emit(SearchTvsLoading());
      final result = await usecase.execute(event.query);
      result.fold(
        (failure) => emit(SearchTvsError(failure.message)),
        (data) => emit(SearchTvsHasData(data)),
      );
    });
  }
}
