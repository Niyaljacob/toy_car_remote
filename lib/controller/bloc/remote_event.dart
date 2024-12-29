
import 'package:equatable/equatable.dart';

abstract class RemoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendCommandEvent extends RemoteEvent {
  final String command;

  SendCommandEvent(this.command);

  @override
  List<Object?> get props => [command];
}
