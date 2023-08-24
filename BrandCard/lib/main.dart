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
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState =
        context.watch<MyAppState>(); // Accessing app state using context

    BrandCard randomCard1 = appState.cards[
        Random().nextInt(appState.cards.length)]; // Get the first random card
    BrandCard randomCard2;
    do {
      randomCard2 = appState.cards[Random()
          .nextInt(appState.cards.length)]; // Get the second random card
    } while (
        randomCard2 == randomCard1); // Make sure the second card is distinct

    IconData icon;
    if (appState.favorites.contains(randomCard1)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    // Building the UI using Center and Column widgets
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BrandCard(
            type: randomCard1.type,
            name: randomCard1.name,
            description: randomCard1.description,
          ), // Displaying the BigCard widget with the current displayed card
          SizedBox(height: 10),
          BrandCard(
            type: randomCard2.type,
            name: randomCard2.name,
            description: randomCard2.description,
          ), 
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState
                      .toggleFavorite(); // Toggling the favorite status of the current card
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getRandomCard(); // Generating the next random card
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
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

    return Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Name: $name' 'Description: $description'),
        ));
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
