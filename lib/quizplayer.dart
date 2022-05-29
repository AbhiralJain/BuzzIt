import 'package:buzzit/config.dart';
import 'package:buzzit/homepage.dart';
import 'package:buzzit/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class QuizPlayer extends StatefulWidget {
  final String secretcode;
  final String name;
  const QuizPlayer({Key? key, required this.secretcode, required this.name}) : super(key: key);

  @override
  State<QuizPlayer> createState() => _QuizPlayerState();
}

class _QuizPlayerState extends State<QuizPlayer> {
  CollectionReference games = FirebaseFirestore.instance.collection('games');
  double progresswidth = 0;
  String title = '';

  var listener;
  bool _isgameon = false;

  String currentstatus = '';
  String status = 'Waiting for the host to start the game.';

  fetchdata() async {
    final docRef = games.doc(widget.secretcode);
    listener = docRef.snapshots(includeMetadataChanges: true).listen((event) async {
      DocumentSnapshot<Object?> gamedata = await games.doc(widget.secretcode).get();

      try {
        setState(() {
          title = gamedata.get('name');

          progresswidth = (MediaQuery.of(context).size.width / gamedata.get('questions')) * gamedata.get('currentq');
          if (gamedata.get('gameon')) {
            List sdata = gamedata.get('sequence');
            print(sdata);
            print(sdata.contains(currentstatus));
            if (sdata.contains(currentstatus)) {
              _isgameon = false;
            } else {
              _isgameon = true;
            }
          } else {
            _isgameon = false;
          }
        });
      } catch (e) {
        Alert(
          style: Config.alertConfig,
          context: context,
          title: "Note",
          desc: 'The quiz was ended by the host.',
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
                listener.cancel();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Homepage()));
              },
              width: 120,
            ),
          ],
        ).show();
      }
    });
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: _isgameon
                    ? ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            status = "";
                          });
                          final dt = DateTime.now();
                          var metadata = await games.doc(widget.secretcode).get();
                          List csequence = metadata.get('sequence');
                          currentstatus = '${dt.hour}${dt.minute}.${dt.second}${dt.millisecond}@${widget.name}';
                          csequence.add(currentstatus);
                          print('currentstatus: $currentstatus');
                          await games.doc(widget.secretcode).update({'sequence': csequence});
                        },
                        child: null,
                        style: ElevatedButton.styleFrom(
                          elevation: 16,
                          minimumSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          primary: MyApp.myColor.shade500,
                          onPrimary: MyApp.myColor.shade900,
                        ),
                      )
                    : Center(child: Text(status, style: Theme.of(context).textTheme.headline3)),
              ),
            ),
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
