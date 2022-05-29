import 'package:buzzit/config.dart';
import 'package:buzzit/main.dart';
import 'package:buzzit/playersqueue.dart';
import 'package:buzzit/quizplayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _cq = TextEditingController();
  final TextEditingController _cn = TextEditingController();
  final TextEditingController _jt = TextEditingController();
  final TextEditingController _jc = TextEditingController();
  final FocusNode _fnode = FocusNode();
  bool _cr = false;
  bool _jn = false;
  Widget textfeild(controller, hinttext, ktype, fnode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20, right: 10),
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: TextField(
        focusNode: fnode,
        keyboardType: ktype,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        controller: controller,
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
        },
        style: Theme.of(context).textTheme.headline2,
        decoration: InputDecoration.collapsed(
          hintText: hinttext,
          border: InputBorder.none,
          hintStyle: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to\nBuzzIt',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_jn) textfeild(_jt, 'Enter your/team name', TextInputType.name, _fnode),
                    if (_jn) textfeild(_jc, 'Enter secret code', TextInputType.visiblePassword, null),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        elevation: 0,
                        padding: const EdgeInsets.all(10),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                      ),
                      onPressed: () async {
                        if (_jn) {
                          if (_jt.text.isNotEmpty && _jc.text.isNotEmpty) {
                            CollectionReference games = FirebaseFirestore.instance.collection('games');
                            var data = await games.doc(_jc.text).get();
                            try {
                              List plname = data.get('players');
                              if (plname.contains(_jt.text)) {
                                Alert(
                                  style: Config.alertConfig,
                                  context: context,
                                  title: "Oops!",
                                  desc: 'That name is already taken. Please think of another name.',
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
                                        Navigator.pop(context);
                                        _fnode.requestFocus();
                                      },
                                      width: 120,
                                    ),
                                  ],
                                ).show();
                              } else {
                                plname.add(_jt.text);
                                await games.doc(_jc.text).update({'players': plname});
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => QuizPlayer(
                                      name: _jt.text,
                                      secretcode: _jc.text,
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              Alert(
                                style: Config.alertConfig,
                                context: context,
                                title: "Invalid code",
                                desc: 'Any quiz with that code does not exist. Please recheck the code.',
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
                                      Navigator.pop(context);
                                    },
                                    width: 120,
                                  ),
                                ],
                              ).show();
                            }
                          }
                        } else {
                          setState(() {
                            _jn = true;
                            _cr = false;
                          });
                        }
                      },
                      child: Text(
                        !_jn ? 'Join a quiz' : 'Join',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_cr) textfeild(_cn, 'Enter quiz title', TextInputType.name, null),
                    if (_cr) textfeild(_cq, 'Enter Number of questions', TextInputType.number, null),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        elevation: 0,
                        padding: const EdgeInsets.all(10),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                      ),
                      onPressed: () async {
                        CollectionReference games = FirebaseFirestore.instance.collection('games');
                        if (_cr) {
                          if (_cq.text.isNotEmpty && _cn.text.isNotEmpty) {
                            final prefs = await SharedPreferences.getInstance();
                            final docId = prefs.getString('name')!;
                            var gameData = {
                              'name': _cn.text,
                              'questions': int.parse(_cq.text),
                              'players': [],
                              'sequence': [],
                              'currentq': 1,
                              'gameon': false
                            };

                            games.doc(docId).set(gameData);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlayersQueue(
                                  secretcode: docId,
                                ),
                              ),
                            );
                          }
                        } else {
                          setState(() {
                            _cr = true;
                            _jn = false;
                          });
                        }
                      },
                      child: Text(
                        !_cr ? 'Create a quiz' : 'Create',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
