import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:breaking_bad_flutter/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad_flutter/constants/colors/my_colors.dart';
import 'package:breaking_bad_flutter/data/models/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({Key? key, required this.character})
      : super(key: key);

  Widget buildSliverAppBar(double sliverAppBarHeight) {
    return SliverAppBar(
      expandedHeight: sliverAppBarHeight * 0.75,
      stretch: true,
      pinned: true,
      backgroundColor: MyColors.grey,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          character.nickname,
          style: const TextStyle(
            color: MyColors.white,
          ),
          textAlign: TextAlign.start,
        ),
        background: Hero(
          tag: '${character.char_id}',
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: title,
            style: const TextStyle(
              color: MyColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        TextSpan(
            text: value,
            style: const TextStyle(
              color: MyColors.white,
              fontSize: 18,
            )),
      ]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildDivider() {
    return const Center(
      child: Divider(
        color: MyColors.yellow,
        height: 30,
        thickness: 2,
        indent: 50,
        endIndent: 50,
      ),
    );
  }

  Widget checkIfQuotesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return DisplayRandomQuoteOrEmptySpace(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget DisplayRandomQuoteOrEmptySpace(state) {
    var quotes = (state).quotes;
    if (quotes.length != 0) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, color: MyColors.white, shadows: [
            Shadow(
              blurRadius: 7,
              color: MyColors.yellow,
              offset: Offset(0, 0),
            )
          ]),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [FlickerAnimatedText(quotes[randomQuoteIndex].quote)],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.yellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    BlocProvider.of<CharactersCubit>(context).getCharacterQuotes(character.name);
    
    double sliverAppBarHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.grey,
        body: CustomScrollView(
          slivers: [
            buildSliverAppBar(sliverAppBarHeight),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    characterInfo('Job: ', character.jobs.join(' / ')),
                    buildDivider(),
                    characterInfo(
                        'Appeared in: ', character.categoryForTwoSeries),
                    buildDivider(),
                    characterInfo(
                        'Seasons: ', character.appearanceOfSeasons.join(' / ')),
                    buildDivider(),
                    characterInfo('Status: ', character.statusIfDeadOrAlive),
                    buildDivider(),
                    character.betterCallSaulAppearance.isEmpty
                        ? Container()
                        : characterInfo('Better Call Saul Seasons: ',
                            character.betterCallSaulAppearance.join(' / ')),
                    character.betterCallSaulAppearance.isEmpty
                        ? Container()
                        : buildDivider(),
                    characterInfo('Actor: ', character.actorName),
                    buildDivider(),
                    BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state) {
                      return checkIfQuotesAreLoaded(state);
                    }),
                    SizedBox(
                      height: sliverAppBarHeight * 0.5,
                    ),
                  ],
                ),
              ),
            ])),
          ],
        ),
      ),
    );
  }
}
