import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:telly/routes.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final buttonStyle = ElevatedButton.styleFrom(
      // backgroundColor: Colors.blue,
      // foregroundColor: Colors.white,
      // borderRadius: BorderRadius.circular(10),
      padding: EdgeInsets.fromLTRB(75, 5, 75, 5));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text('Telly!'),
      // ),
      body: SafeArea(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Telly!', style: TextStyle(fontSize: 90)),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Play', style: TextStyle(fontSize: 25)),
                onPressed: () {
                  // Navigator.pushNamed(context, '/game');
                  Navigator.of(context).push(Routes.createRoute(context));
                },
                style: buttonStyle,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
