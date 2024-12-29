import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'remote_event.dart';
import 'remote_state.dart';

class RemoteBloc extends Bloc<RemoteEvent, RemoteState> {
  RemoteBloc() : super(RemoteIdle()) {
    
    on<SendCommandEvent>(_onSendCommand);
  }

  Future<void> _onSendCommand(
    SendCommandEvent event,
    Emitter<RemoteState> emit,
  ) async {
    emit(RemoteLoading()); 
    try {
      final response = await http.get(
        Uri.parse('http://3.84.187.74:3000/${event.command}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(RemoteSuccess(data['message'])); 
      } else {
        emit(RemoteError('Error: ${response.statusCode}')); 
      }
    } catch (e) {
      emit(RemoteError(e.toString())); 
    }
  }
}
