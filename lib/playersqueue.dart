import 'package:buzzit/main.dart';
import 'package:buzzit/quizhost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayersQueue extends StatefulWidget {
  final String secretcode;
  const PlayersQueue({Key? key, required this.secretcode}) : super(key: key);

  @override
  State<PlayersQueue> createState() => _PlayersQueueState();
}

class _PlayersQueueState extends State<PlayersQueue> {
  List players = [];
  String title = '';
  var listener;
  CollectionReference games = FirebaseFirestore.instance.collection('games');
  fetchdata() async {
    final docRef = games.doc(widget.secretcode);
    listener = docRef.snapshots(includeMetadataChanges: true).listen((event) async {
      DocumentSnapshot<Object?> gamedata = await games.doc(widget.secretcode).get();
      setState(() {
        players = gamedata.get('players');
        title = gamedata.get('name');
      });
    });
  }

  @override
  initState() {
    super.initState();
    fetchdata();
  }

  Widget playernames(index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Text(
        players[index],
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Waiting for players',
                style: Theme.of(context).textTheme.headline1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  'Secret code: ${widget.secretcode}',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Divider(
                  color: MyApp.myColor.shade100,
                ),
              ),
              if (players.isNotEmpty)
                Text(
                  'Joined players/teams:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              Expanded(
                child: players.isNotEmpty
                    ? ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (BuildContext context, int index) => playernames(index),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              if (players.isNotEmpty)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                    elevation: 0,
                    padding: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                  onPressed: () async {
                    await games.doc(widget.secretcode).update({'gameon': true});
                    listener.cancel();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuizHost(
                          secretcode: widget.secretcode,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Start the quiz',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
/* 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Alert(
        style: Config.alertConfig,
        context: context,
        title: "Share This",
        desc: 'Username: ${widget.docId}\nPassword: ${widget.password}',
        buttons: [
          DialogButton(
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            splashColor: const Color.fromRGBO(0, 0, 0, 0),
            radius: const BorderRadius.all(Radius.circular(20)),
            color: MyApp.myColor,
            child: Text(
              "OK",
              style: Theme.of(context).textTheme.headline4,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            width: 120,
          ),
        ],
      ).show();
    }); 
    
    
    players.isNotEmpty
                    ? ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (BuildContext context, int index) => playernames(index),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
    
    
    StreamBuilder(
                stream: games.doc(widget.secretcode).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    print(snapshot.data.to);
                    return Container();
                  }
                },
              ))
    
    */
