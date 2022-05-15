import 'package:bloc/bloc.dart';
import 'package:breaking_bad_flutter/data/models/quotes.dart';
import 'package:breaking_bad_flutter/data/repositories/characters_repository.dart';
import 'package:meta/meta.dart';
import 'package:breaking_bad_flutter/data/models/characters.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {

  final CharactersRepository charactersRepository;
  List<Character> characters = [];
  List<Quotes> quotes = [];

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Character> getAllCharacters () {
    //This takes the list provided from the repository and gives it to the UI.
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });

    return characters;
  }

  void getCharacterQuotes(String charName) {
    charactersRepository.getCharacterQuotes(charName).then((quotes) {
      emit(QuotesLoaded(quotes));
    });
  }
}
