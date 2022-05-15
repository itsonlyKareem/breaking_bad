import 'package:breaking_bad_flutter/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad_flutter/constants/strings.dart';
import 'package:breaking_bad_flutter/data/models/characters.dart';
import 'package:breaking_bad_flutter/data/repositories/characters_repository.dart';
import 'package:breaking_bad_flutter/data/web_services/characters_web_services.dart';
import 'package:breaking_bad_flutter/presentation/screens/characters_details.dart';
import 'package:breaking_bad_flutter/presentation/screens/characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case allCharactersRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                CharactersCubit(charactersRepository),
            child: CharactersScreen(),
          ),
        );
      case charactersDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                CharactersCubit(charactersRepository),
            child: CharacterDetailsScreen(
              character: character,
            ),
          ),
        );
    }
  }
}
