import 'package:buzzit/playersqueue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizDetials extends StatefulWidget {
  const QuizDetials({Key? key}) : super(key: key);

  @override
  State<QuizDetials> createState() => _QuizDetialsState();
}

class _QuizDetialsState extends State<QuizDetials> {
  CollectionReference games = FirebaseFirestore.instance.collection('games');
  final TextEditingController _qname = TextEditingController();
  final TextEditingController _passwd = TextEditingController();
  final TextEditingController _totalq = TextEditingController();
  Widget textfeild(controller, hinttext, ktype) {
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
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              textfeild(_qname, 'Enter quiz name', TextInputType.name),
              textfeild(_passwd, 'Enter quiz password', TextInputType.visiblePassword),
              textfeild(_totalq, 'Total questions', TextInputType.number),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(15),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () async {
                  if (_qname.text.isNotEmpty && _passwd.text.isNotEmpty && _totalq.text.isNotEmpty) {
                    final prefs = await SharedPreferences.getInstance();
                    var gameData = {
                      'id': prefs.getString('name'),
                      'name': _qname.text,
                      'password': _passwd.text,
                      'qustions': _totalq.text,
                    };
                    games.add(gameData);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PlayersQueue()));
                  }
                },
                child: Text(
                  'Create',
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
