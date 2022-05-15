import 'package:flutter/material.dart';

class PlayersQueue extends StatefulWidget {
  const PlayersQueue({Key? key}) : super(key: key);

  @override
  State<PlayersQueue> createState() => _PlayersQueueState();
}

class _PlayersQueueState extends State<PlayersQueue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Waiting for players',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
