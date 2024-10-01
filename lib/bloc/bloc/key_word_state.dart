part of 'key_word_bloc.dart';

class KeyWordState extends Equatable {
  final bool showIconClear;
  final List<String> addresses;
  final bool isLoading;

  const KeyWordState({
    required this.showIconClear,
    required this.addresses,
    required this.isLoading,
  });

  KeyWordState copyWith(
      {bool? showIconClear, List<String>? addresses, bool? isLoading}) {
    return KeyWordState(
      showIconClear: showIconClear ?? this.showIconClear,
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [showIconClear, addresses, isLoading];
}
