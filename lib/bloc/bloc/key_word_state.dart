part of 'key_word_bloc.dart';

class KeyWordState extends Equatable {
  final bool showIconClear;
  final List<String> addresses;

  const KeyWordState({required this.showIconClear, required this.addresses});

  KeyWordState copyWith({bool? showIconClear, List<String>? addresses}) {
    return KeyWordState(
      showIconClear: showIconClear ?? this.showIconClear,
      addresses: addresses ?? this.addresses,
    );
  }

  @override
  List<Object> get props => [showIconClear, addresses];
}
