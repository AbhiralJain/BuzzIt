import 'package:buzzit/config.dart';
import 'package:buzzit/homepage.dart';
import 'package:buzzit/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class QuizHost extends StatefulWidget {
  final String secretcode;
  const QuizHost({Key? key, required this.secretcode}) : super(key: key);

  @override
  State<QuizHost> createState() => _QuizHostState();
}

class _QuizHostState extends State<QuizHost> {
  CollectionReference games = FirebaseFirestore.instance.collection('games');
  double progresswidth = 0;
  String title = '';
  List players = [];
  bool _end = false;
  int _currentq = 0;
  int _questions = 0;
  var listener;
  fetchdata() async {
    final docRef = games.doc(widget.secretcode);
    listener = docRef.snapshots(includeMetadataChanges: true).listen((event) async {
      DocumentSnapshot<Object?> gamedata = await games.doc(widget.secretcode).get();
      setState(() {
        title = gamedata.get('name');
        players = gamedata.get('sequence');
        _questions = gamedata.get('questions');
        players.sort(((a, b) {
          return (double.parse(a.split('@').first)).compareTo(double.parse(b.split('@').first));
        }));
        progresswidth = (MediaQuery.of(context).size.width / gamedata.get('questions')) * gamedata.get('currentq');
      });
    });
  }

  Widget playernames(index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            '${index + 1}.',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            margin: const EdgeInsets.only(bottom: 5, left: 5, right: 15, top: 5),
            decoration: BoxDecoration(
              color: MyApp.myColor.shade500,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Text(
              players[index].split('@').last,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
      ],
    );
  }

  Widget controlbutton(icon, function) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: MyApp.myColor.shade100,
        minimumSize: const Size(75, 50),
        elevation: 0,
        padding: const EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      onPressed: function,
      child: Icon(
        icon,
        color: MyApp.myColor.shade500,
        size: 30,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Text(
                'Current order:',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Expanded(
              child: players.isNotEmpty
                  ? ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (BuildContext context, int index) => playernames(index),
                    )
                  : Center(
                      child: Text(
                        'Waiting for players\nto press the buzzer...',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                controlbutton(
                  Icons.restart_alt_rounded,
                  () async {
                    await games.doc(widget.secretcode).update({'sequence': []});
                  },
                ),
                if (!_end)
                  controlbutton(
                    Icons.arrow_forward_ios_rounded,
                    () async {
                      await games.doc(widget.secretcode).update({'sequence': []});
                      _currentq++;
                      await games.doc(widget.secretcode).update({'currentq': _currentq});
                      if (_currentq == _questions) {
                        setState(() {
                          _end = true;
                        });
                      }
                    },
                  ),
                controlbutton(
                  Icons.close_rounded,
                  () {
                    Alert(
                      style: Config.alertConfig,
                      context: context,
                      title: "Are you sure you want to end the quiz?",
                      buttons: [
                        DialogButton(
                          highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                          splashColor: const Color.fromRGBO(0, 0, 0, 0),
                          radius: const BorderRadius.all(Radius.circular(20)),
                          color: MyApp.myColor,
                          child: Text(
                            "Yes",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          onPressed: () async {
                            listener.cancel();
                            await games.doc(widget.secretcode).delete();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Homepage()));
                          },
                          width: 120,
                        ),
                        DialogButton(
                          highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                          splashColor: const Color.fromRGBO(0, 0, 0, 0),
                          radius: const BorderRadius.all(Radius.circular(20)),
                          color: MyApp.myColor,
                          child: Text(
                            "No",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          width: 120,
                        ),
                      ],
                    ).show();
                  },
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 15)),
            AnimatedContainer(
              width: progresswidth,
              height: 8,
              color: MyApp.myColor,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}
