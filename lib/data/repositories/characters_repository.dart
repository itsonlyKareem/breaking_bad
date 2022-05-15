import 'package:breaking_bad_flutter/data/models/characters.dart';
import 'package:breaking_bad_flutter/data/models/quotes.dart';
import 'package:breaking_bad_flutter/data/web_services/characters_web_services.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;

  //A constructor must be made to retrieve the response from the web services class.

  CharactersRepository(this.charactersWebServices);

  //This method retrieves the response from the network call
  // and casts it to the Character model we created and makes it into a list.

  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebServices.getAllCharacters();
    return characters.map((e) => Character.fromJson(e)).toList();
  }

  Future<List<Quotes>> getCharacterQuotes(String charName) async {
    final quotes = await charactersWebServices.getCharacterQuotes(charName);
    return quotes.map((e) => Quotes.fromJson(e)).toList();
  }
}