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
import 'package:custom_sliver/sliver_layer/sliver_layer_clip.dart';
import 'package:custom_sliver/sliver_layer/sliver_layer_outside.dart';
import 'package:flutter/material.dart';

class ClipExample extends StatelessWidget {
  final Axis axis;

  const ClipExample({
    super.key,
    required this.axis,
  });

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
        SliverLayerClipRRect(
          borderRadius: BorderRadius.circular(120),
          sliver: SliverList(
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
                  child: OverflowBox(
                      child: TextButton(
                    child: const Text('Clip'),
                    onPressed: () {},
                  ))),
              Container(
                height: edgeHeight,
                width: edgeWidth,
                color: Colors.brown,
              ),
            ]),
          ),
        ),
        SliverLayerBox(
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
                    color: Colors.pink.withOpacity(0.5),
                  )),
                )),
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Container(
                height: edgeHeight,
                width: edgeWidth,
                color: Colors.orange.withOpacity(0.4),
              ),
              Container(
                height: 300,
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
          ],
        ),
        SliverLayerClipRRect(
          borderRadius: BorderRadius.circular(120),
          sliver: SliverList(
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
                  child: OverflowBox(
                      child: TextButton(
                    child: const Text('Clip'),
                    onPressed: () {},
                  ))),
              Container(
                height: edgeHeight,
                width: edgeWidth,
                color: Colors.brown,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
