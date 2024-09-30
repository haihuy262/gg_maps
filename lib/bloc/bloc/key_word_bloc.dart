import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

part 'key_word_event.dart';
part 'key_word_state.dart';

class KeyWordBloc extends Bloc<KeyWordEvent, KeyWordState> {
  final apiKey = "e6Da1BDcNVkX8fdSrGPMW3MJbh05Ehm68NNhLWAwo6o";
  final apiUrl = "https://autocomplete.search.hereapi.com/v1/autocomplete";
  KeyWordBloc()
      : super(const KeyWordState(showIconClear: false, addresses: [])) {
    on<FocusTextField>(_onFocusTextField);
    on<UnfocusTextField>(_onUnfocusTextField);
    on<TextChange>(
      _onTextChange,
      transformer: debounce(const Duration(seconds: 1)),
    );
  }

  FutureOr<void> _onFocusTextField(
      FocusTextField event, Emitter<KeyWordState> emit) {
    emit(state.copyWith(showIconClear: true));
  }

  FutureOr<void> _onUnfocusTextField(
      UnfocusTextField event, Emitter<KeyWordState> emit) {
    emit(state.copyWith(showIconClear: false));
  }

  FutureOr<void> _onTextChange(
      TextChange event, Emitter<KeyWordState> emit) async {
    try {
      final response = await Dio().get(apiUrl, queryParameters: {
        "q": event.keyWorld,
        "apiKey": apiKey,
      });
      final result = response.data;
      List items = result["items"];
      List<String> address =
          items.map((item) => item["address"]["label"] as String).toList();
      emit(state.copyWith(addresses: address));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  EventTransformer<Event> debounce<Event>(Duration duration) =>
      (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}
