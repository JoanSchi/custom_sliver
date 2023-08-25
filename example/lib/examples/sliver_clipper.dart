// Copyright 2023 Joan Schipper. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:math' as math;

import '/examples/general_widgets.dart';
import 'package:flutter/material.dart';

import 'package:custom_sliver/sliver_layer/sliver_layer_clip.dart';

class ClipProperties {
  ClipProperties({
    required this.color,
    required this.ratio,
  });

  final Color color;
  double ratio;
}

class ClipExample extends StatefulWidget {
  final Axis axis;

  const ClipExample({
    super.key,
    required this.axis,
  });

  @override
  State<ClipExample> createState() => _ClipExampleState();
}

class _ClipExampleState extends State<ClipExample> {
  List<ButtonSegment<double>> cornerRatioSegments = const [
    ButtonSegment(value: 0.25, label: Text('0.25')),
    ButtonSegment(value: 0.5, label: Text('0.5')),
    ButtonSegment(value: 1.0, label: Text('1.0'))
  ];
  Set<double> selectedRatios = {1.0};

  List<ClipProperties> listProperties = [
    ClipProperties(color: const Color(0xffdfe8b2), ratio: 1.0),
    ClipProperties(color: const Color.fromARGB(255, 243, 229, 149), ratio: 1.0),
    ClipProperties(color: const Color.fromARGB(255, 149, 227, 243), ratio: 1.0),
    ClipProperties(color: const Color.fromARGB(255, 237, 243, 149), ratio: 1.0),
    ClipProperties(color: const Color.fromARGB(255, 185, 243, 149), ratio: 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    const paragraphSize = 18.0;
    double? width;
    double? height;

    final theme = Theme.of(context);

    if (widget.axis == Axis.vertical) {
      height = 800.0;
    } else {
      width = 800.0;
    }

    void ratioSelectedChanged(Set<double> values) {
      setState(() {
        selectedRatios = values;
        final ratio = selectedRatios.first;

        for (var p in listProperties) {
          p.ratio = ratio;
        }
      });
    }

    void ripple(Color color) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 100),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32.0,
                height: 32.0,
                child: Material(
                  shape: const StadiumBorder(),
                  color: color,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              const Text('Ripple'),
            ],
          )));
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final maxRadius = math.min(constraints.biggest.shortestSide,
              (widget.axis == Axis.vertical ? height : width) ?? 0.0) /
          2.0;

      double? aboutHeight;
      double? aboutWidth;

      if (widget.axis == Axis.vertical) {
        aboutHeight = math.max(300.0, constraints.biggest.height);
      } else {
        aboutWidth = constraints.biggest.width;
      }

      return CustomScrollView(
        scrollDirection: widget.axis,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Container(
                  width: aboutWidth,
                  height: aboutHeight,
                  color: const Color(0xFFF9F5E7),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'axis: ${widget.axis == Axis.vertical ? 'vertical' : 'horizontal'}, example next sliver!'),
                        Text(
                          'Rounded Clipper',
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
                                'Five rounded sliver clippers (next sliver). At the moment the rounded SliverLayerClipRRect widget does only clip the drawing not the hittest.'
                                '\n',
                            style: TextStyle(
                                color: Colors.brown[900],
                                fontSize: paragraphSize),
                            // children: [
                            //   TextSpan(
                            //       text: 'Background',
                            //       style: TextStyle(
                            //           color: theme.primaryColor,
                            //           fontSize: headerSize)),
                            //   TextSpan(
                            //     text:
                            //         '\nRounded sliver clipper (next slivers). At the moment the rounded SliverLayerClipRRect widget does only clip the drawing not the hittest.'
                            //         '\n\n',
                            //     style: TextStyle(
                            //         color: Colors.brown[900],
                            //         fontSize: paragraphSize),
                            //   )
                            // ]
                          ),
                        ),
                        Text(
                          'Ratio Radius',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 24,
                          ),
                        ),
                        SegmentedButton(
                            multiSelectionEnabled: false,
                            segments: cornerRatioSegments,
                            selected: selectedRatios,
                            onSelectionChanged: ratioSelectedChanged)
                      ],
                    ),
                  )),
              CircularDivider(
                axis: widget.axis,
              ),
            ]),
          ),
          for (ClipProperties p in listProperties) ...[
            SliverLayerClipRRect(
              borderRadius: BorderRadius.circular(maxRadius * p.ratio),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                    height: height,
                    width: width,
                    child: Material(
                      color: p.color,
                      child: OverflowBox(
                          child: InkWell(
                        onTap: () => ripple(p.color),
                        child: const Center(
                            child: Text(
                          'Press for Ripple',
                        )),
                      )),
                    )),
              ),
            ),
            if (p != listProperties.last)
              SliverToBoxAdapter(
                child: CircularDivider(
                  axis: widget.axis,
                ),
              )
          ]
        ],
      );
    });
  }
}
