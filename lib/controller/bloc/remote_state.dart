import 'package:equatable/equatable.dart';

abstract class RemoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RemoteIdle extends RemoteState {}

class RemoteLoading extends RemoteState {}

class RemoteSuccess extends RemoteState {
  final String message;

  RemoteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RemoteError extends RemoteState {
  final String error;

  RemoteError(this.error);

  @override
  List<Object?> get props => [error];
}
