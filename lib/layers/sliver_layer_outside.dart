// Copyright 2023 Joan Schipper. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'sliver_layer.dart';
import 'sliver_layer_constraints.dart';
import 'dart:math' as math;

class SliverLayerOutside extends SingleChildRenderObjectWidget {
  /// Creates a sliver that contains a single box widget.
  const SliverLayerOutside(
      {super.key,
      super.child,
      required this.beginOutside,
      required this.endOutside});

  final double beginOutside;
  final double endOutside;

  @override
  RenderSliverLayerOutside createRenderObject(BuildContext context) =>
      RenderSliverLayerOutside(
          beginOutside: beginOutside, endOutside: endOutside);

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverLayerOutside renderObject) {
    renderObject
      ..beginOutside = beginOutside
      ..endOutside = endOutside;
  }
}

class RenderSliverLayerOutside extends RenderSliverLayer {
  double _beginOutside;
  double _endOutside;

  RenderSliverLayerOutside(
      {required double beginOutside, required double endOutside})
      : _beginOutside = beginOutside,
        _endOutside = endOutside;

  double get beginOutside => _beginOutside;

  set beginOutside(double value) {
    if (_beginOutside == value) {
      return;
    }
    _beginOutside = value;
    markNeedsLayout();
  }

  double get endOutside => _endOutside;

  set endOutside(double value) {
    if (_endOutside == value) {
      return;
    }
    _endOutside = value;
    markNeedsLayout();
  }

  @override
  Offset calculateOffsetForChild(
    SliverLayerConstraints constraints,
  ) {
    final offsetMain =
        -clampDouble(beginOutside, 0.0, constraints.scrollOffset);

    return constraints.axis == Axis.vertical
        ? Offset(0.0, offsetMain)
        : Offset(offsetMain, 0.0);
  }

  @override
  BoxConstraints calculateBoxConstraintsForChild(
    SliverLayerConstraints constraints,
  ) {
    double from = math.max(constraints.scrollOffset - beginOutside, 0.0);
    double to = from +
        math.min(constraints.scrollExtent - from,
            constraints.layoutExtent + beginOutside + endOutside);

    final mainlength = math.max(to - from, 0.0);
    final crossAxisLength = constraints.crossAxisExtent;

    return constraints.axis == Axis.vertical
        ? BoxConstraints(maxWidth: crossAxisLength, maxHeight: mainlength)
        : BoxConstraints(maxWidth: mainlength, maxHeight: crossAxisLength);
  }
}
