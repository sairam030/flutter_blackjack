import 'package:flutter/material.dart';
import 'package:flutter_blackjack_pkg/widgets/card.dart';
import 'package:flutter_blackjack_pkg/services/game_service.dart';
import 'package:flutter_blackjack_pkg/models/player_model.dart';
import 'package:flutter_blackjack_pkg/services/game_service_impl.dart';
import 'package:playing_cards/playing_cards.dart';

GameService _gameService = GameServiceImpl();

class BlackJackGame extends StatefulWidget {
  const BlackJackGame({super.key});

  @override
  State<BlackJackGame> createState() => _BlackJackGameState();
}

class _BlackJackGameState extends State<BlackJackGame> {
  PlayingCard deckTopCard = PlayingCard(Suit.joker, CardValue.joker_1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            height: 180,
            width: _gameService.getDealer().hand.length * 90,
            child: FlatCardFan(
              children: [
                for (var card in _gameService.getDealer().hand) ...[
                  CardAnimatedWidget(
                      card,
                      (_gameService.getGameState() == GameState.playerActive),
                      3.0)
                ]
              ],
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      if (_gameService.getGameState() ==
                          GameState.playerActive) {
                        _gameService.drawCard();
                        setState(() {});
                      }
                    },
                    child: SizedBox(
                      width: 150,
                      child: FlatCardFan(
                        children: [
                          cardWidget(
                              PlayingCard(Suit.joker, CardValue.joker_1), true),
                          cardWidget(
                              PlayingCard(Suit.joker, CardValue.joker_2), true),
                          cardWidget(
                              PlayingCard(Suit.joker, CardValue.joker_2), true),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(139, 0, 0, 1),
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () {
                            if (_gameService.getGameState() ==
                                GameState.playerActive) {
                              _gameService.endTurn();
                            } else if( _gameService.getPlayer().wallet >= _gameService.getPlayer().bet
                            ){
                              _gameService.startNewGame();
                            }
                            else{
                              _showNotEnoughFundsDialog(context);
                            }
                            setState(() {});
                          },
                          child: Text((() {
                            if (_gameService.getGameState() !=
                                GameState.playerActive) {
                              return "New Game";
                            }
                            return 'Finish';
                          })()),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: [
                                if (_gameService.getGameState() !=
                                    GameState.playerActive) ...[
                                  Text("Winner: ${_gameService.getWinner()}"),
                                  Text(
                                      "Dealer score: ${_gameService.getScore(_gameService.getDealer())}"),
                                  Text(
                                      "Player  score: ${_gameService.getScore(_gameService.getPlayer())}"),
                                ],
                              ],
                            )),
                      ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const SizedBox(height: 25),
          SizedBox(
            height: 180,
            width: _gameService.getPlayer().hand.length * 90,
            child: FlatCardFan(
              children: [
                for (var card in _gameService.getPlayer().hand) ...[
                  CardAnimatedWidget(card, false, 3.0)
                ]
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Spacer(),
          Container(
            width: _gameService.getPlayer().bet.toString().length * 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
            ),
            child: Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        iconSize: 45,
                        onPressed: () {
                          _gameService.getPlayer().setBetLower();
                          setState(() {});
                        },
                        icon: const Icon(Icons.remove)),
                    Text(
                      _gameService.getPlayer().bet.toString(),
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      iconSize: 45,
                      onPressed: () {
                        _gameService.getPlayer().setBetHigher();
                        setState(() {});
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: _gameService.getPlayer().wallet.toString().length *100,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 7.5),
                  Text(
                    _gameService.getPlayer().wallet.toString(),
                    style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

void _showNotEnoughFundsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Not Enough Funds"),
        content: Text("You don't have enough funds to start a new game."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}



class BettingScreen extends StatefulWidget {
  @override
  _BettingScreenState createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  late Player player;

  @override
  void initState() {
    super.initState();
    player = Player([]);
  }

  void placeBet() {
    if (!player.canPlaceBet()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Insufficient Balance"),
            content: Text("You don't have enough money to place this bet."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Only place the bet if the user's balance is enough
    setState(() {
      // Place the bet logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Betting Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Wallet Balance: ${player.wallet}"),
            Text("Current Bet: ${player.bet}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: placeBet,
              child: Text("Place Bet"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  player.setBetHigher();
                });
              },
              child: Text("Increase Bet"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  player.setBetLower();
                });
              },
              child: Text("Decrease Bet"),
            ),
          ],
        ),
      ),
    );
  }
}
