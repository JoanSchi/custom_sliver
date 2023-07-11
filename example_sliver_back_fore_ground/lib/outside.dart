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

import 'package:custom_sliver/sliver_layer/sliver_background_forground.dart';
import 'package:custom_sliver/sliver_layer/sliver_layer_outside.dart';
import 'package:flutter/material.dart';

class SliverLayerOutsideExample extends StatelessWidget {
  final Axis axis;
  final double beginOutside;
  final double endOutside;
  const SliverLayerOutsideExample(
      {super.key,
      required this.axis,
      this.beginOutside = 0.0,
      this.endOutside = 0.0});

  @override
  Widget build(BuildContext context) {
    double? edgeWidth;
    double? edgeHeight;
    double? width;
    double? height;
    double? spacerWidth;
    double? spacerHeight;

    if (axis == Axis.vertical) {
      height = 300.0;
      edgeHeight = 10.0;
      spacerHeight = 800.0;
    } else {
      width = 300.0;
      edgeWidth = 10.0;
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
        SliverBackForeGround(
          children: [
            SliverLayerOutside(
                beginOutside: 40.0,
                endOutside: 40.0,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                      color: Colors.pink.withOpacity(0.85),
                    ),
                  ),
                )),
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Container(
                height: edgeHeight,
                width: edgeWidth,
                color: Colors.orange.withOpacity(0.4),
              ),
              Container(
                width: width,
                height: height,
                color:
                    const Color.fromARGB(255, 216, 230, 238).withOpacity(0.4),
              ),
              SizedBox(
                width: width,
                height: height,
              ),
              Container(
                width: width,
                height: height,
                color:
                    const Color.fromARGB(255, 216, 230, 238).withOpacity(0.4),
              ),
              SizedBox(
                width: width,
                height: height,
              ),
              Container(
                width: width,
                height: height,
                color:
                    const Color.fromARGB(255, 216, 230, 238).withOpacity(0.4),
              ),
              Container(
                height: edgeHeight,
                width: edgeWidth,
                color: Colors.orange.withOpacity(0.4),
              ),
            ])),
            SliverLayerOutside(
                beginOutside: 40.0,
                endOutside: 40.0,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 60 || constraints.maxHeight < 60) {
                    return const SizedBox();
                  }
                  return Stack(
                    children: [
                      Positioned(
                          left: 0.0,
                          top: 0.0,
                          right: 0.0,
                          height: 80.0,
                          child: TextButton(
                            child: const Text('Top'),
                            onPressed: () {},
                          )),
                      Positioned(
                          left: 0.0,
                          bottom: 0.0,
                          right: 0.0,
                          height: 80.0,
                          child: TextButton(
                            child: const Text('Bottom'),
                            onPressed: () {},
                          ))
                    ],
                  );
                })),
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
