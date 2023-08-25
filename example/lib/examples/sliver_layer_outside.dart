// Copyright 2023 Joan Schipper. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:custom_sliver/layers/sliver_layer_box.dart';
import 'package:custom_sliver/layers/sliver_layer_outside.dart';

import '/coffee_brands.dart';
import '/examples/general_widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SliverLayerOutsideExample extends StatelessWidget {
  const SliverLayerOutsideExample(
      {super.key,
      required this.axis,
      this.beginOutside = 0.0,
      this.endOutside = 0.0});

  final Axis axis;
  final double beginOutside;
  final double endOutside;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberMedium = theme.textTheme.headlineSmall
        ?.copyWith(color: const Color.fromARGB(255, 72, 45, 57));

    final headlineMedium = theme.textTheme.headlineSmall
        ?.copyWith(color: const Color.fromARGB(255, 248, 215, 188));

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      const paragraphSize = 18.0;
      double? width;
      double? height;
      double? aboutHeight;
      double? aboutWidth;
      double? spacerHeight;
      double? spacerWidth;

      if (axis == Axis.vertical) {
        height = 80.0;
        aboutHeight = math.max(300.0, constraints.biggest.height);
        spacerHeight = constraints.biggest.height;
      } else {
        aboutWidth = constraints.biggest.width;
        spacerWidth = constraints.biggest.width;
        width = 300.0;
      }

      return CustomScrollView(
        scrollDirection: axis,
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
                            'axis: ${axis == Axis.vertical ? 'vertical' : 'horizontal'}, example next sliver!'),
                        Text(
                          'Background Outside',
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
                                'SliverLayerOutside is a lazy way to move the roundings of the background outside the view if the scrollLayout is not at the beginning or the end.',
                            style: TextStyle(
                                color: Colors.brown[900],
                                fontSize: paragraphSize),
                          ),
                        ),
                        Text(
                          'Coffee image',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 24,
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                                'Author: Pipat Pajongwong.\nhttps://www.vecteezy.com/vector-art/1906625-coffee-elements-icons',
                            style: TextStyle(
                                color: Colors.brown[900],
                                fontSize: paragraphSize),
                          ),
                        )
                      ],
                    ),
                  )),
              CircularDivider(
                axis: axis,
              ),
            ]),
          ),
          SliverLayerBox(
            children: [
              SliverLayerOutside(
                  beginOutside: 40.0,
                  endOutside: 40.0,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                        color: Color.fromARGB(255, 89, 57, 71),
                      ),
                      child: const Center(
                          child: Image(
                              image: AssetImage(
                                  'graphics/coffee_background.png'))),
                    ),
                  )),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return SizedBox(
                  height: height,
                  width: width,
                  child: Material(
                    type: MaterialType.transparency,
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(milliseconds: 100),
                            content:
                                Text('${index + 1}: ${coffeeBrands[index]}')));
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
                                    style: numberMedium,
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
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              CircularDivider(
                axis: axis,
              ),
              Container(
                  width: spacerWidth,
                  height: spacerHeight,
                  color: const Color(0xFFF9F5E7),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                  )),
            ]),
          ),
        ],
      );
    });
  }
}
