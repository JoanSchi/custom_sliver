// Copyright 2023 Joan Schipper. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CircularDivider extends StatelessWidget {
  const CircularDivider({
    Key? key,
    required this.axis,
  }) : super(key: key);

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    double? dividerHeight;
    double? dividerWidth;

    if (axis == Axis.vertical) {
      dividerHeight = 40.0;
    } else {
      dividerWidth = 40.0;
    }

    return Center(
        child: SizedBox(
      height: dividerHeight ?? dividerWidth,
      width: dividerWidth ?? dividerHeight,
      child: const Material(
        shape: StadiumBorder(),
        color: Color(0xFFA7727D),
      ),
    ));
  }
}
