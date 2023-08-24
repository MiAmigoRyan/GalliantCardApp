// Importing necessary packages and libraries
import 'dart:js';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Entry point of the app
void main() {
  runApp(MyApp());
}

// The root widget of the app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Setting up the ChangeNotifierProvider to manage app state
    return ChangeNotifierProvider(
      create: (context) =>
          MyAppState(), // Creating an instance of MyAppState to manage app state
      child: MaterialApp(
        title: 'Brand Cards',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 81, 137, 28)),
        ),
        home: MyHomePage(), // Setting MyHomePage as the home screen of the app
      ),
    );
  }
}

// S T A T E  M A N A G M E N T
class MyAppState extends ChangeNotifier {
  List<BrandCard> cards = [
    BrandCard(type: 'brand', name: 'adventure', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'leader', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'teacher', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'artist', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'modernist', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'sense', description: 'feefoofuu'),
  ];

  late BrandCard current ;

  BrandCard getRandomCard() {
    final availableCards =
        cards.where((card) => !favorites.contains(card)).toList();

    if (availableCards.isNotEmpty) {
      final randomIndex = Random().nextInt(availableCards.length);
      current = availableCards[randomIndex];
      return current;
    } else {
      if(cards.isNotEmpty){
        final lastCard = cards.removeAt(0);
        favorites.add(lastCard);
        return lastCard;
      }
      if(availableCards.isEmpty){
        navToFavorites(context as BuildContext);
        
      }
      return availableCards.first;
      }
      }

  var favorites = <BrandCard>[]; // Storing favorites

  void navToFavorites(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> FavoritesPage()),
    );
  }

  // Function to toggle the favorite status of a word pair
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners(); // Notifying listeners (UI) that the state has changed
    }
  }


// H O M E  P A G E / L A N D I N G  P A G E
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage(appState: MyAppState());
        break;
      case 1:
        page = FavoritesPage();
        break;
      // case 2:
      //   page = AllCards();
      //   break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

// N A V   B A R
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.rectangle_outlined),
                      label: Text('All Cards')),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            // Expanded container for dynamic content

            Expanded(
              child: Container(
                color: Theme.of(context).canvasColor,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatefulWidget {
 
  final MyAppState appState;

  GeneratorPage({required this.appState});

  @override
  _GeneratorPageState createState() => _GeneratorPageState(appState);
}

class _GeneratorPageState extends State<GeneratorPage> {
  late final MyAppState appState;
  _GeneratorPageState(this.appState);
  late List<BrandCard> cards;
  Iterator<BrandCard> iterator = <BrandCard>[].iterator;
  late BrandCard card1;
  late BrandCard card2;
  bool chooseCard1 = true;
  bool chooseCard2 = true;
  @override
  void initState() {
    super.initState();
    iterator = appState.cards.iterator;
    cards = appState.cards;
    card1 = appState.getRandomCard();
    card2 = appState.getRandomCard();
  }


  Widget buildError(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    bool finalView = false;

    if (finalView == true){
      return Center(
        child: CardZone(card: cards[0]),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    chooseCard1 = true;
                    if (chooseCard1) {
                      cards.remove(card2);
                    }
                    card2 = appState.getRandomCard();
                    while( card1 == card2 ){
                    card2 = appState.getRandomCard();
                    }
              //TERMINAL LOG      
                    print(cards.length);
                    for (var card in cards) {
                      print('${card.name}');
                    }
                  });
                },
                child: CardZone(
                  card: card1,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    chooseCard2 = true;
                    if(chooseCard2){
                      cards.remove(card1);
                    }
                    card1 = appState.getRandomCard();
                    while(card2 == card1){
                      card1 = appState.getRandomCard();
                    }
                    List<BrandCard> availableCards = appState.cards;
                    if(cards.length == 2){
                      finalView = true;
                    }
                  });
                },
                child: CardZone(
                  card: card2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// F A V O R I T E S  P A G E
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No Favorites yet.'),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.name),
          ),
      ],
    );
  }
}

// T O  D O :  c r e a t e  p a g e  f o r  a l l  b r a n d  t y p e s
// Class AllCardsPage extends StatelessWidget {
//   var card = Cards;

//   @override
//   Widget build(BuildContext context){
//     return Center (
//       child: Text('${card.name}'),
//     );
//   }

// B R A N D   C A R D
class BrandCard extends StatelessWidget {
  final String type;
  final String name;
  final String description;

  const BrandCard({
    required this.type,
    required this.name,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 150, // Set a fixed height for the card container
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Name: $name',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Description: $description',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardZone extends StatelessWidget {
  final BrandCard card;

  CardZone({
    required this.card,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Column(
          children: [
            card,
          ],
        ));
  }
}
