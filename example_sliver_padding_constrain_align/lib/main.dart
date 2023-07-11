import 'package:custom_sliver/sliver_padding_constrain_align.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Axis axis = Axis.vertical;
  @override
  Widget build(BuildContext context) {
    double? edgeWidth;
    double? edgeHeight;
    double? width;
    double? height;

    if (axis == Axis.vertical) {
      height = 300.0;
      edgeHeight = 10.0;
    } else {
      width = 300.0;
      edgeWidth = 10.0;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    axis =
                        axis == Axis.vertical ? Axis.horizontal : Axis.vertical;
                  });
                },
                icon: const Icon(Icons.screen_rotation_alt_outlined))
          ],
        ),
        body: CustomScrollView(
          scrollDirection: axis,
          slivers: [
            SliverPaddingConstrainAlign(
              sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                Container(
                  height: edgeHeight,
                  width: edgeWidth,
                  color: Colors.orange,
                ),
                Container(
                  height: 300,
                  color: const Color.fromARGB(255, 216, 230, 238),
                ),
                Container(
                  width: width,
                  height: height,
                  color: const Color.fromARGB(255, 234, 238, 241),
                ),
                Container(
                  width: width,
                  height: height,
                  color: const Color.fromARGB(255, 216, 230, 238),
                ),
                Container(
                  width: width,
                  height: height,
                  color: const Color.fromARGB(255, 234, 238, 241),
                ),
                Container(
                  width: width,
                  height: height,
                  color: const Color.fromARGB(255, 216, 230, 238),
                ),
                Container(
                  height: edgeHeight,
                  width: edgeWidth,
                  color: Colors.orange,
                ),
              ])),
              crossAlign: 0.0,
              maxCrossSize: 200.0,
              padding: const EdgeInsets.all(4.0),
            ),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
