import 'package:buzzit/quizdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to\nBuzzIt',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(15),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              onPressed: () async {
/*                 List docs = [];
                QuerySnapshot<Object?> g = await games.get();
                for (int i = 0; i < g.size; i++) {
                  Map data = {'name': g.docs[i]['name'], 'password': g.docs[i]['password']};
                  docs.add(data);
                }
                print(docs); */
              },
              child: Text(
                'Join a quiz',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(15),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () {
/*                   var gameData = {
                    'name': 'Aadit',
                    'password': 'abhi1234',
                  };
                  games.add(gameData); */
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuizDetials()));
                },
                child: Text(
                  'Create a quiz',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
