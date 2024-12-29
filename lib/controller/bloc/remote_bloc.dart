import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'remote_event.dart';
import 'remote_state.dart';

class RemoteBloc extends Bloc<RemoteEvent, RemoteState> {
  RemoteBloc() : super(RemoteIdle());

  Stream<RemoteState> mapEventToState(RemoteEvent event) async* {
    if (event is SendCommandEvent) {
      yield RemoteLoading();
      try {
        final response = await http.get(
          Uri.parse('http://3.84.187.74:3000/${event.command}'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          yield RemoteSuccess(data['message']);
        } else {
          yield RemoteError('Error: ${response.statusCode}');
        }
      } catch (e) {
        yield RemoteError(e.toString());
      }
    }
  }
}
