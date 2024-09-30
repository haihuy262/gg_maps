part of 'key_word_bloc.dart';

abstract class KeyWordEvent {}

class FocusTextField extends KeyWordEvent {}

class UnfocusTextField extends KeyWordEvent {}

class TextChange extends KeyWordEvent {
  final String keyWorld;

  TextChange({required this.keyWorld});
}
