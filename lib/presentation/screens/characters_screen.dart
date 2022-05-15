import 'package:breaking_bad_flutter/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad_flutter/constants/colors/my_colors.dart';
import 'package:breaking_bad_flutter/data/models/characters.dart';
import 'package:breaking_bad_flutter/presentation/widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  List<Character> filteredCharacters = [];
  bool isSearching = false;
  final TextEditingController searchTextController = TextEditingController();

  Widget buildSearchField() {
    return TextField(
      controller: searchTextController,
      cursorColor: const Color(0xFF3B3B3B),
      decoration: const InputDecoration(
        hintText: 'Find a Character',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: MyColors.grey,
          fontSize: 18,
        ),
      ),
      style: const TextStyle(
        color: MyColors.grey,
        fontSize: 18,
      ),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
      autofocus: true,
    );
  }

  void addSearchedForItemsToSearchedList(String searchedCharacter) {
    //How is allCharacters populated? the blocBuilder does that when it updates its state.
    filteredCharacters = allCharacters
        .where((character) =>
            character.name.toLowerCase().startsWith(searchedCharacter))
        .toList();
    setState(() {});
  }

  List<Widget> buildAppBarActions() {
    if (isSearching) {
      return [
        IconButton(
          onPressed: () {
            clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.clear,
            color: MyColors.grey,
          ),
        )
      ];
    } else {
      return [
        IconButton(
          onPressed: () {
            startSearch();
          },
          icon: const Icon(
            Icons.search,
            color: MyColors.grey,
          ),
        )
      ];
    }
  }

  void startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));
    setState(() {
      isSearching = true;
    });
  }

  void stopSearching() {
    clearSearch();
    setState(() {
      isSearching = false;
    });
  }

  void clearSearch() {
    setState(() {
      searchTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    //gets the empty list that is referenced by the Cubit;
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocWidget() {
    //check if the list is loaded or not.
    //if loaded, it updates only its state from the CharactersState

    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
      if (state is CharactersLoaded) {
        allCharacters = (state.characters);
        return buildLoadedListWidgets();
      } else {
        return showLoadingIndicator();
      }
    });
  }

  //Builds a column of Widgets.

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.grey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  //Builds the grid view with the list retrieved as its building block.
  //each item is a widget.

  Widget buildCharactersList() {
    return GridView.builder(
      //This is the grid view's configurations.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: searchTextController.text.isEmpty
          ? allCharacters.length
          : filteredCharacters.length,
      itemBuilder: (context, index) {
        return CharacterItem(
            character: searchTextController.text.isEmpty
                ? allCharacters[index]
                : filteredCharacters[index]);
      },
    );
  }

  //A Progress Bar in case the list is not loaded.

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.yellow,
      ),
    );
  }

  Widget buildAppBarTitle() {
    return const Text(
      'Characters',
      style: TextStyle(color: MyColors.grey),
    );
  }

  Widget noInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Can\'t connect .. check internet',
              style: TextStyle(
                fontSize: 22,
                color: MyColors.grey,
              ),
            ),
            Image.asset('assets/images/no_internet.png'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.grey,
        appBar: AppBar(
          backgroundColor: MyColors.yellow,
          title: isSearching ? buildSearchField() : buildAppBarTitle(),
          actions: buildAppBarActions(),
          leading: isSearching
              ? const BackButton(
                  color: MyColors.grey,
                )
              : Container(),
        ),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return buildBlocWidget();
            } else {
              return noInternetWidget();
            }
          },
          child: Center(child: showLoadingIndicator()),
        ),
      ),
    );
  }
}
