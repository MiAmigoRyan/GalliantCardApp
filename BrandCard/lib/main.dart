// Importing necessary packages and libraries
import 'dart:math';

import 'package:english_words/english_words.dart';
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
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 28, 88, 137)),
        ),
        home: MyHomePage(), // Setting MyHomePage as the home screen of the app
      ),
    );
  }
}

// A class to manage the state of the app
class MyAppState extends ChangeNotifier {
  List<BrandCard> cards = [
    BrandCard(type: 'brand', name: 'adventure', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'leader', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'teacher', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'artist', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'modernist', description: 'feefoofuu'),
    BrandCard(type: 'brand', name: 'sense', description: 'feefoofuu'),
  ];

  BrandCard current =
      BrandCard(type: 'brand', name: 'inital', description: 'desc');

  void getRandomCard() {
    final availableCards =
        cards.where((card) => !favorites.contains(card)).toList();

    if (availableCards.isNotEmpty) {
      final randomIndex = Random().nextInt(availableCards.length);
      current = availableCards[randomIndex];
    } else {
      current = BrandCard(
          type: 'brand', name: 'no more available cards', description: 'n/a');
    }
    notifyListeners();

    // final randomIndex = Random().nextInt(cards.length);
    // current = cards[randomIndex];
  }
  // Function to generate the next random word pair
  // void getNext() {
  //   current = BrandCard.cards.random();
  //   notifyListeners(); // Notifying listeners (UI) that the state has changed

  var favorites = <BrandCard>[]; // Storing favorites

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

// The main home page widget
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
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = AllCards();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            // NavigationRail widget for navigation
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
                      icon: Icon(Icons.deck), label: Text('All Cards')),
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

//Favorites Widget
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

// Widget to display the generated word pairs
class GeneratorPage extends StatefulWidget {
  @override
  _GeneratorPageState createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  late MyAppState appState;

  BrandCard card1 = BrandCard(
    type: 'initial',
    name: 'initial',
    description: 'initial',
  );
  BrandCard card2 = BrandCard(
    type: 'initial',
    name: 'initial',
    description: 'initial',
  );
  bool showCard1 = true; // To track which card to show

  void generateRandomCard1() {
    card1 = appState.cards[Random().nextInt(appState.cards.length)];
  }
  void generateRandomCard2() {
    card2 = appState.cards[Random().nextInt(appState.cards.length)];
    }  


  @override
  Widget build(BuildContext context) {
    appState = context.watch<MyAppState>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showCard1 = true;
                    generateRandomCard2();
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
                    showCard1 = false;
                    generateRandomCard1();
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




// Widget to display a styled card with a word pair
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(42.0),
        child: Text(
          pair.asUpperCase, // Displaying the uppercase version of the word pair
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", // Accessibility label
        ),
      ),
    );
  }
}

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

    return Container(
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

class AllCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('ALL CARDS'),
      ),
      body: ListView.builder(
        itemCount: appState.cards.length,
        itemBuilder: (context, index) {
          var card = appState.cards[index];
          return ListTile(
            title: Text(card.name),
            subtitle: Text(card.description),
          );
        },
      ),
    );
  }
}

class CardZone extends StatelessWidget {
  final BrandCard card;
  // final VoidCallback likeButtonCallback;

  CardZone({
    required this.card,
    // required this.likeButtonCallback,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            card,
            // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // ElevatedButton.icon(
                // onPressed: likeButtonCallback,
                // icon: Icon(Icons.favorite),
                // label: Text('this is me'),
              // )
            // ])
          ],
        ));
  }
}
