// Copyright 2023 Joan Schipper. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:custom_sliver/custom/sliver_clip_rrect.dart';
import 'package:custom_sliver/custom/sliver_maintain_padding.dart';
import 'package:custom_sliver/layers/sliver_layer.dart';
import 'package:custom_sliver/layers/sliver_layer_box.dart';
import 'package:custom_sliver/layers/sliver_layer_builder.dart';

import '/coffee_brands.dart';
import '/examples/general_widgets.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class SliverLayerBuilderExample extends StatelessWidget {
  const SliverLayerBuilderExample({super.key, required this.axis});

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    const headerSize = 20.0;
    const paragraphSize = 18.0;

    final theme = Theme.of(context);
    final headlineMedium = theme.textTheme.headlineSmall
        ?.copyWith(color: const Color.fromARGB(255, 72, 45, 57));

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double? aboutHeight;
      double? aboutWidth;
      double? width;
      double? height;
      double? spacerWidth;
      double? spacerHeight;

      if (axis == Axis.vertical) {
        height = 80.0;
        aboutHeight = math.max(1200.0, constraints.biggest.height);
        spacerHeight = constraints.biggest.height;
      } else {
        aboutWidth = constraints.biggest.width;
        spacerWidth = constraints.biggest.width;
        width = 300.0;
      }

      final aboutChildren = [
        Text(
            'axis: ${axis == Axis.vertical ? 'vertical' : 'horizontal'}, example next sliver!'),
        Text(
          'SliverLayerBuilder',
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        RichText(
          text: TextSpan(
              text:
                  'The delegate of the SliverLayerBuilder implements a buildObject function to build a custom object from scrollOffset, scrollLayout and scrollExtent and a build function to build the widget triggered only when the custom object change. The object should implement equal and hashcode. Two default SliverBuildObjects are present: SliverLayerPositionObject and SliverLayerAnimationObject.',
              style:
                  TextStyle(color: Colors.brown[900], fontSize: paragraphSize)),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          'Coffee',
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        RichText(
          text: TextSpan(
              text:
                  'The Coffee ranking list example (next sliver), has the following SliverLayers:'
                  '\n\n',
              style:
                  TextStyle(color: Colors.brown[900], fontSize: paragraphSize),
              children: [
                TextSpan(
                    text: 'Background',
                    style: TextStyle(
                        color: theme.primaryColor, fontSize: headerSize)),
                TextSpan(
                    text:
                        '\nThe background is a simple container with rounded corners wrapped in a SliverLayer.'
                        ' This is the basic layer and used for none scroll reponsive widgets.'
                        '\n\n',
                    style: TextStyle(
                        color: Colors.brown[900], fontSize: paragraphSize)),
                TextSpan(
                    text: 'ScrollIndicator',
                    style: TextStyle(
                        color: theme.primaryColor, fontSize: headerSize)),
                TextSpan(
                    text:
                        '\nThe ScrollIndicator is a simple indicator to show the scrolling position in the coffee branch list.'
                        ' The size and the position of the indicator is determined with scrollOffset, the scrollExtent and the layoutExtent which is passed along with the build function of the SliverLayerBuilder.'
                        '\n\n',
                    style: TextStyle(
                        color: Colors.brown[900], fontSize: paragraphSize)),
                TextSpan(
                    text: 'Info Header',
                    style: TextStyle(
                        color: theme.primaryColor, fontSize: headerSize)),
                TextSpan(
                    text:
                        '\nThe header shows the scrollOffset, the scrollExtent and the layoutExtent provided by SliverLayerBuilder.'
                        '\n\n',
                    style: TextStyle(
                        color: Colors.brown[900], fontSize: paragraphSize)),
                TextSpan(
                    text: 'Coffee list',
                    style: TextStyle(
                        color: theme.primaryColor, fontSize: headerSize)),
                TextSpan(
                    text:
                        '\nThe coffee list is padded and clipped (rounded). Additinal padding is added for the header and the scrollIndicator. Widgets Tree: SliverMaintainPadding -> SliverClipRRect -> Sliverlist'
                        '\n\n',
                    style: TextStyle(
                        color: Colors.brown[900], fontSize: paragraphSize)),
                TextSpan(
                    text: 'Floating button',
                    style: TextStyle(
                        color: theme.primaryColor, fontSize: headerSize)),
                TextSpan(
                    text:
                        '\nThe floating button starts to appears from the top after 120 with animationSpace of 32 and starts to disappears after the (bottom - animationspace) reach (110 - 32). The animationValue (0.0 to 1.0) can be easily calcualted with the buildObject SliverLayerAnimationObject. The rebuild is only trigged if the animationValue is changed.',
                    style: TextStyle(
                        color: Colors.brown[900], fontSize: paragraphSize)),
              ]),
        ),
      ];

      return CustomScrollView(
        scrollDirection: axis,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Container(
                height: aboutHeight,
                width: aboutWidth,
                color: const Color(0xFFF9F5E7),
                child: axis == Axis.vertical
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: aboutChildren))
                    : ListView(padding: const EdgeInsets.all(8.0), children: [
                        for (Widget w in aboutChildren) Center(child: w)
                      ]),
              ),
              CircularDivider(
                axis: axis,
              ),
            ]),
          ),
          SliverLayerBox(
            children: [
              SliverLayer(
                  child: Container(
                      decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
                color: Color(0xFFF9F5E7),
              ))),
              SliverLayerBuilder(delegate: ProgressSliverLayerDelegate(axis)),
              SliverLayerBuilder(
                delegate: InfoSliverLayerDelegate(axis),
              ),
              SliverMaintainPadding(
                padding: axis == Axis.vertical
                    ? const EdgeInsets.only(
                        left: 20.0, top: 52.0, right: 10.0, bottom: 10.0)
                    : const EdgeInsets.only(
                        left: 10.0, top: 64.0, right: 10.0, bottom: 10.0),
                sliver: SliverClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return SizedBox(
                      height: height,
                      width: width,
                      child: Material(
                        color: index % 2 == 0
                            ? const Color(0xFFD79771)
                            : const Color(0xFFDEBA9D),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(milliseconds: 100),
                                content: Text(
                                    '${index + 1}: ${coffeeBrands[index]}')));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              Material(
                                  color: const Color(0xFFF5E8C7),
                                  shape: const StadiumBorder(),
                                  child: SizedBox(
                                    width: 48.0,
                                    height: 48.0,
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: headlineMedium,
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Text(
                                  coffeeBrands[index],
                                  style: headlineMedium,
                                  softWrap: true,
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    );
                  }, childCount: coffeeBrands.length)),
                ),
              ),
              SliverLayerBuilder(
                delegate: FloatingButtonSliverLayerDelegate(axis),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              CircularDivider(
                axis: axis,
              ),
              Container(
                height: spacerHeight,
                width: spacerWidth,
                color: const Color(0xFFF9F5E7),
              ),
            ]),
          ),
        ],
      );
    });
  }
}

class FloatingButtonSliverLayerDelegate
    extends SliverLayerDelegate<SliverLayerAnimationObject> {
  final Axis axis;

  FloatingButtonSliverLayerDelegate(this.axis);

  @override
  Widget build(BuildContext context, SliverLayerAnimationObject object) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: DefaultTextStyle(
        style: const TextStyle(
            color: Color.fromARGB(255, 84, 51, 11), fontSize: 16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 48.0 * object.animationValue,
              height: 48.0 * object.animationValue,
              child: FloatingActionButton(
                  shape: const CircleBorder(),
                  child: const FittedBox(
                      child: Icon(
                    Icons.add,
                  )),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(milliseconds: 100),
                      content: Text('Add'),
                    ));
                  }),
            ),
          ),
        ),
      ),
    );
  }

  @override
  SliverLayerAnimationObject buildObject(
          double scrollOffset, double scrollExtent, double layoutExtent) =>
      SliverLayerAnimationObject(
        scrollOffset: scrollOffset,
        layoutExtent: layoutExtent,
        bottom: 110.0,
        top: 120.0,
        animationSpace: 32.0,
      );
}

class InfoSliverLayerDelegate
    extends SliverLayerDelegate<SliverLayerPositionObject> {
  final Axis axis;

  InfoSliverLayerDelegate(this.axis);

  @override
  Widget build(BuildContext context, SliverLayerPositionObject object) {
    double? maxHeight;
    double? maxWidth;

    if (axis == Axis.vertical) {
      maxHeight = object.layoutExtent < 56 ? 56 : object.layoutExtent;
    } else {
      maxWidth = object.layoutExtent < 300 ? 300 : object.layoutExtent;
    }

    final info = Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
        child: OverflowBox(
          alignment: Alignment.center,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'ScrollExtent ${object.scrollExtent.toInt()},'
                '\nScrollOffset: ${object.scrollOffset.toInt()}, LayoutExtent: ${object.layoutExtent.toInt()}',
                textAlign: TextAlign.center,
              )),
        ));

    return (axis == Axis.vertical)
        ? ClipRect(child: info)
        : ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: info);
  }

  @override
  SliverLayerPositionObject buildObject(
          double scrollOffset, double scrollExtent, double layoutExtent) =>
      SliverLayerPositionObject(
        scrollOffset: scrollOffset,
        scrollExtent: scrollExtent,
        layoutExtent: layoutExtent,
      );
}

class ProgressSliverLayerDelegate
    extends SliverLayerDelegate<SliverLayerPositionObject> {
  final Axis axis;

  ProgressSliverLayerDelegate(this.axis);

  @override
  Widget build(BuildContext context, SliverLayerPositionObject object) {
    final progress = CustomPaint(
      painter: ProgressPainter(
          layoutExtent: object.layoutExtent,
          scrollOffset: object.scrollOffset,
          scrollExtent: object.scrollExtent,
          backgroundColor: const Color(0xFFCC9544),
          foregroundColor: const Color(0xFF361500),
          axis: axis),
    );

    return axis == Axis.vertical
        ? Padding(
            padding: const EdgeInsets.only(left: 6.0, top: 76.0, bottom: 32.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    width: 6.0, height: double.infinity, child: progress)))
        : Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 52.0, right: 10.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    width: double.infinity, height: 6.0, child: progress)));
  }

  @override
  SliverLayerPositionObject buildObject(
          double scrollOffset, double scrollExtent, double layoutExtent) =>
      SliverLayerPositionObject(
        scrollOffset: scrollOffset,
        scrollExtent: scrollExtent,
        layoutExtent: layoutExtent,
      );
}

class ProgressPainter extends CustomPainter {
  final Color backgroundColor;
  final Color foregroundColor;
  final double scrollExtent;
  final double scrollOffset;
  final double layoutExtent;
  final Axis axis;

  ProgressPainter({
    required this.scrollExtent,
    required this.scrollOffset,
    required this.layoutExtent,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.axis,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.shortestSide / 2.0);
    final paint = Paint();

    paint.color = backgroundColor;

    canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, radius), paint);

    paint.color = foregroundColor;

    final RRect rrect = RRect.fromRectAndRadius(
        switch (axis) {
          Axis.vertical =>
            Offset(0.0, size.height / scrollExtent * scrollOffset) &
                Size(size.width, size.height / scrollExtent * layoutExtent),
          Axis.horizontal =>
            Offset(size.width / scrollExtent * scrollOffset, 0.0) &
                Size(size.width / scrollExtent * layoutExtent, size.height)
        },
        radius);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) {
    return scrollExtent != oldDelegate.scrollExtent ||
        scrollOffset != oldDelegate.scrollOffset ||
        layoutExtent != oldDelegate.layoutExtent;
  }
}
