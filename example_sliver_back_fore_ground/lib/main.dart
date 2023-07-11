import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'clip_example.dart';
import 'outside.dart';
import 'sliver_layer_build.dart';

enum Example { outside, builder, clip }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Custom Sliver (wrapper)'),
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
  Example example = Example.builder;
  Axis axis = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        axis = axis == Axis.vertical
                            ? Axis.horizontal
                            : Axis.vertical;
                      });
                    },
                    icon: const Icon(Icons.screen_rotation_alt_outlined))
              ],
            ),
            body: switch (example) {
              Example.outside => SliverLayerOutsideExample(
                  axis: axis,
                ),
              Example.builder => SliverLayerBuilderExample(
                  axis: axis,
                ),
              Example.clip => ClipExample(
                  axis: axis,
                )
            },
            bottomNavigationBar: Row(
              children: [
                SelectedButton(
                  changed: selectedExample,
                  groupValue: example,
                  value: Example.builder,
                  title: 'builder',
                ),
                SelectedButton(
                  changed: selectedExample,
                  groupValue: example,
                  value: Example.clip,
                  title: 'Clip',
                ),
                SelectedButton(
                  changed: selectedExample,
                  groupValue: example,
                  value: Example.outside,
                  title: 'outside',
                ),
              ],
            )));
  }

  void selectedExample(Example value) {
    setState(() {
      example = value;
    });
  }
}

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  TargetPlatform getPlatform(BuildContext context) {
    final platform = defaultTargetPlatform;
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return platform;
      default:
        return TargetPlatform.android;
    }
  }

  @override
  Set<PointerDeviceKind> get dragDevices {
    final platform = defaultTargetPlatform;
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return super.dragDevices;
      default:
        return {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        };
    }
  }
}

class SelectedButton<T> extends StatelessWidget {
  final T groupValue;
  final T value;
  final ValueChanged<T> changed;
  final String title;

  const SelectedButton(
      {super.key,
      required this.groupValue,
      required this.value,
      required this.changed,
      required this.title});

  bool get isSelected => groupValue == value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: () {
        changed(value);
      },
      style: TextButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.background,
        foregroundColor: isSelected
            ? theme.colorScheme.background
            : theme.colorScheme.primary,
        // side: const BorderSide(
        //     color: Color.fromARGB(255, 55, 111, 124), width: 2),
      ),
      child: Text(title),
    );
  }
}
