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
