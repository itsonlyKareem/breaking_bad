part of 'characters_cubit.dart';

// import 'package:breaking_bad_flutter/data/models/characters.dart';

@immutable
abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;

  CharactersLoaded(this.characters);

}

class QuotesLoaded extends CharactersState {
  final List<Quotes> quotes;

  QuotesLoaded(this.quotes);

}

