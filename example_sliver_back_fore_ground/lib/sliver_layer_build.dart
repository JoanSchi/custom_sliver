// Copyright (C) 2023 Joan Schipper
//
// This file is part of custom_sliver.
//
// custom_sliver is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// custom_sliver is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with custom_sliver.  If not, see <http://www.gnu.org/licenses/>.

import 'package:custom_sliver/sliver_layer/sliver_layer_box.dart';
import 'package:custom_sliver/sliver_layer/sliver_layer_builder.dart';
import 'package:custom_sliver/sliver_layer/sliver_layer_clip.dart';
import 'package:custom_sliver/sliver_layer/sliver_layer_padding.dart';
import 'package:flutter/material.dart';

class SliverLayerBuilderExample extends StatelessWidget {
  final Axis axis;
  const SliverLayerBuilderExample({super.key, required this.axis});

  @override
  Widget build(BuildContext context) {
    double? edgeWidth;
    double? edgeHeight;
    double? width;
    double? height;
    double? spacerWidth;
    double? spacerHeight;
    double? edgeWidth2;
    double? edgeHeight2;

    if (axis == Axis.vertical) {
      height = 300.0;
      edgeHeight = 10.0;
      edgeHeight2 = 56.0;
      spacerHeight = 800.0;
    } else {
      width = 300.0;
      edgeWidth = 40.0;
      edgeWidth2 = 56.0;
      spacerWidth = 800.0;
    }

    return CustomScrollView(
      scrollDirection: axis,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            Container(
              height: edgeHeight,
              width: edgeWidth,
              color: Colors.brown,
            ),
            Container(
              height: spacerHeight,
              width: spacerWidth,
              color: const Color.fromARGB(255, 145, 208, 244),
            ),
            Container(
              height: edgeHeight,
              width: edgeWidth,
              color: Colors.brown,
            ),
          ]),
        ),
        SliverLayerBox(
          children: [
            SliverLayerBuilder(
              delegate: BackgroundSliverLayerDelegate(axis),
            ),
            SliverLayerPadding(
              padding: const EdgeInsets.all(10.0),
              sliver: SliverLayerClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                  Container(
                      height: edgeHeight2,
                      width: edgeWidth2,
                      color: Colors.white.withOpacity(0.5),
                      child: TextButton(
                        child: const Text('F'),
                        onPressed: () {
                          debugPrint('F');
                        },
                      )),
                  SizedBox(
                    width: width,
                    height: height,
                    // color:
                    //     const Color.fromARGB(255, 216, 230, 238).withOpacity(0.5),
                  ),
                  Container(
                    width: width,
                    height: height,
                    color: const Color.fromARGB(255, 234, 238, 241)
                        .withOpacity(0.5),
                  ),
                  SizedBox(
                    width: width,
                    height: height,
                    // color:
                    //     const Color.fromARGB(255, 216, 230, 238).withOpacity(0.5),
                  ),
                  Container(
                    width: width,
                    height: height,
                    color: const Color.fromARGB(255, 234, 238, 241)
                        .withOpacity(0.5),
                  ),
                  SizedBox(
                    width: width,
                    height: height,
                    // color:
                    //     const Color.fromARGB(255, 216, 230, 238).withOpacity(0.5),
                  ),
                  Container(
                      height: edgeHeight2,
                      width: edgeWidth2,
                      color: Colors.white.withOpacity(0.5),
                      child: TextButton(
                        child: const Text('L'),
                        onPressed: () {
                          debugPrint('L');
                        },
                      )),
                ])),
              ),
            ),
            SliverLayerBuilder(
              delegate: TopSliverLayerDelegate(axis),
            )
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            Container(
              height: edgeHeight,
              width: edgeWidth,
              color: Colors.brown,
            ),
            Container(
              height: spacerHeight,
              width: spacerWidth,
              color: const Color.fromARGB(255, 145, 208, 244),
            ),
            Container(
              height: edgeHeight,
              width: edgeWidth,
              color: Colors.brown,
            ),
          ]),
        ),
      ],
    );
  }
}

class TopSliverLayerDelegate extends SliverLayerDelegate {
  final Axis axis;

  TopSliverLayerDelegate(this.axis);

  @override
  Widget build(BuildContext context, double scrollOffset, double scrollExtent,
      double layoutExtent) {
    double? maxHeight;
    double? maxWidth;

    if (axis == Axis.vertical) {
      maxHeight = layoutExtent < 200 ? 200 : layoutExtent;
    } else {
      maxWidth = layoutExtent < 50 ? 50 : layoutExtent;
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.yellow, fontSize: 24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40.0),
          child: OverflowBox(
            alignment: Alignment.center,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            child: Stack(children: [
              Positioned(
                  top: 12.0,
                  left: 12.0,
                  child: Text('scrollOffset: ${scrollOffset.toInt()}'
                      '\nscrollExtent ${scrollExtent.toInt()}'
                      '\nlayoutExtent: ${layoutExtent.toInt()}')),
              Positioned(
                  bottom: 18.0,
                  right: 18.0,
                  child: FloatingActionButton(
                      shape: const CircleBorder(),
                      child: const Icon(Icons.add),
                      onPressed: () {})),
            ]),
          ),
        ),
      ),
    );
  }
}

class BackgroundSliverLayerDelegate extends SliverLayerDelegate {
  final Axis axis;

  BackgroundSliverLayerDelegate(this.axis);

  @override
  Widget build(BuildContext context, double scrollOffset, double scrollExtent,
      double layoutExtent) {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(40.0),
            ),
            color: Colors.pink.withOpacity(0.5),
          ),
        ));
  }
}
