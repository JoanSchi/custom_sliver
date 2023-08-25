// Copyright 2023 Joan Schipper. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/rendering.dart';

class SliverLayerConstraints extends Constraints {
  const SliverLayerConstraints({
    required this.axis,
    required this.scrollOffset,
    required this.scrollExtent,
    required this.overlap,
    required this.crossAxisExtent,
    required this.layoutExtent,
  });

  final Axis axis;
  final double scrollOffset;
  final double scrollExtent;
  final double overlap;
  final double crossAxisExtent;
  final double layoutExtent;

  @override
  bool get isTight => false;

  @override
  bool get isNormalized {
    return scrollOffset >= 0.0 && crossAxisExtent >= 0.0 && layoutExtent >= 0.0;
  }
}
