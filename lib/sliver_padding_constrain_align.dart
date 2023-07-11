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

import 'package:flutter/cupertino.dart';

import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class SliverPaddingConstrainAlign extends SingleChildRenderObjectWidget {
  /// Creates a sliver that applies padding on each side of another sliver.
  ///
  /// The [padding] argument must not be null.
  const SliverPaddingConstrainAlign(
      {super.key,
      required this.padding,
      Widget? sliver,
      this.maxCrossSize = double.maxFinite,
      this.crossAlign = 0.0})
      : super(child: sliver);

  /// The amount of space by which to inset the child sliver.
  final EdgeInsetsGeometry padding;
  final double maxCrossSize;
  final double crossAlign;

  @override
  RenderSliverPaddingConstrainAlign createRenderObject(BuildContext context) {
    return RenderSliverPaddingConstrainAlign(
      maxCrossSize: maxCrossSize,
      crossAlign: crossAlign,
      padding: padding,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverPaddingConstrainAlign renderObject) {
    renderObject
      ..padding = padding
      ..textDirection = Directionality.of(context)
      ..maxCrossSize = maxCrossSize
      ..crossAlign = crossAlign;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
  }
}

class RenderSliverPaddingConstrainAlign extends RenderSliverEdgeInsetsPadding {
  /// Creates a render object that insets its child in a viewport.
  ///
  /// The [padding] argument must not be null and must have non-negative insets.
  RenderSliverPaddingConstrainAlign({
    required EdgeInsetsGeometry padding,
    TextDirection? textDirection,
    RenderSliver? child,
    required double? maxCrossSize,
    required double crossAlign,
  })  : assert(padding.isNonNegative),
        _maxCrossSize = maxCrossSize,
        _crossAlign = crossAlign,
        _padding = padding,
        _textDirection = textDirection {
    this.child = child;
  }

  @override
  EdgeInsets? get resolvedPadding => _resolvedPadding;
  EdgeInsets? _resolvedPadding;

  void _resolve() {
    if (resolvedPadding != null) {
      return;
    }
    _resolvedPadding = padding.resolve(textDirection);
    assert(resolvedPadding!.isNonNegative);
  }

  void _markNeedsResolution() {
    _resolvedPadding = null;
    markNeedsLayout();
  }

  /// The amount to pad the child in each dimension.
  ///
  /// If this is set to an [EdgeInsetsDirectional] object, then [textDirection]
  /// must not be null.
  EdgeInsetsGeometry get padding => _padding;
  EdgeInsetsGeometry _padding;
  set padding(EdgeInsetsGeometry value) {
    assert(padding.isNonNegative);
    if (_padding == value) {
      return;
    }
    _padding = value;
    _markNeedsResolution();
  }

  /// The text direction with which to resolve [padding].
  ///
  /// This may be changed to null, but only after the [padding] has been changed
  /// to a value that does not depend on the direction.
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    _markNeedsResolution();
  }

  double? _maxCrossSize;

  double? get maxCrossSize => _maxCrossSize;

  set maxCrossSize(double? value) {
    if (_maxCrossSize == value) {
      return;
    }
    _maxCrossSize = value;
    _markNeedsResolution();
  }

  double _crossAlign;

  double get crossAlign => _crossAlign;

  set crossAlign(double value) {
    if (_crossAlign == value) {
      return;
    }
    _crossAlign = value;
    _markNeedsResolution();
  }

  @override
  void performLayout() {
    _resolve();

    final SliverConstraints constraints = this.constraints;
    assert(resolvedPadding != null);
    final double beforePadding = this.beforePadding;
    final double afterPadding = this.afterPadding;
    final double mainAxisPadding = this.mainAxisPadding;
    final double crossAxisPadding = this.crossAxisPadding;
    if (child == null) {
      final double paintExtent = calculatePaintOffset(
        constraints,
        from: 0.0,
        to: mainAxisPadding,
      );
      final double cacheExtent = calculateCacheOffset(
        constraints,
        from: 0.0,
        to: mainAxisPadding,
      );
      geometry = SliverGeometry(
        scrollExtent: mainAxisPadding,
        paintExtent: math.min(paintExtent, constraints.remainingPaintExtent),
        maxPaintExtent: mainAxisPadding,
        cacheExtent: cacheExtent,
      );
      return;
    }
    final double beforePaddingPaintExtent = calculatePaintOffset(
      constraints,
      from: 0.0,
      to: beforePadding,
    );
    double overlap = constraints.overlap;
    if (overlap > 0) {
      overlap = math.max(0.0, constraints.overlap - beforePaddingPaintExtent);
    }
    child!.layout(
      constraints.copyWith(
        scrollOffset: math.max(0.0, constraints.scrollOffset - beforePadding),
        cacheOrigin: math.min(0.0, constraints.cacheOrigin + beforePadding),
        overlap: overlap,
        remainingPaintExtent: constraints.remainingPaintExtent -
            calculatePaintOffset(constraints, from: 0.0, to: beforePadding),
        remainingCacheExtent: constraints.remainingCacheExtent -
            calculateCacheOffset(constraints, from: 0.0, to: beforePadding),
        crossAxisExtent: math.max(0.0, crossSize(constraints)),
        precedingScrollExtent:
            beforePadding + constraints.precedingScrollExtent,
      ),
      parentUsesSize: true,
    );
    final SliverGeometry childLayoutGeometry = child!.geometry!;
    if (childLayoutGeometry.scrollOffsetCorrection != null) {
      geometry = SliverGeometry(
        scrollOffsetCorrection: childLayoutGeometry.scrollOffsetCorrection,
      );
      return;
    }
    final double afterPaddingPaintExtent = calculatePaintOffset(
      constraints,
      from: beforePadding + childLayoutGeometry.scrollExtent,
      to: mainAxisPadding + childLayoutGeometry.scrollExtent,
    );
    final double mainAxisPaddingPaintExtent =
        beforePaddingPaintExtent + afterPaddingPaintExtent;
    final double beforePaddingCacheExtent = calculateCacheOffset(
      constraints,
      from: 0.0,
      to: beforePadding,
    );
    final double afterPaddingCacheExtent = calculateCacheOffset(
      constraints,
      from: beforePadding + childLayoutGeometry.scrollExtent,
      to: mainAxisPadding + childLayoutGeometry.scrollExtent,
    );
    final double mainAxisPaddingCacheExtent =
        afterPaddingCacheExtent + beforePaddingCacheExtent;
    final double paintExtent = math.min(
      beforePaddingPaintExtent +
          math.max(childLayoutGeometry.paintExtent,
              childLayoutGeometry.layoutExtent + afterPaddingPaintExtent),
      constraints.remainingPaintExtent,
    );
    geometry = SliverGeometry(
      paintOrigin: childLayoutGeometry.paintOrigin,
      scrollExtent: mainAxisPadding + childLayoutGeometry.scrollExtent,
      paintExtent: paintExtent,
      layoutExtent: math.min(
          mainAxisPaddingPaintExtent + childLayoutGeometry.layoutExtent,
          paintExtent),
      cacheExtent: math.min(
          mainAxisPaddingCacheExtent + childLayoutGeometry.cacheExtent,
          constraints.remainingCacheExtent),
      maxPaintExtent: mainAxisPadding + childLayoutGeometry.maxPaintExtent,
      hitTestExtent: math.max(
        mainAxisPaddingPaintExtent + childLayoutGeometry.paintExtent,
        beforePaddingPaintExtent + childLayoutGeometry.hitTestExtent,
      ),
      hasVisualOverflow: childLayoutGeometry.hasVisualOverflow,
    );

    final SliverPhysicalParentData childParentData =
        child!.parentData! as SliverPhysicalParentData;
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        childParentData.paintOffset = Offset(
            crossPosition(constraints, _resolvedPadding!.left),
            calculatePaintOffset(constraints,
                from:
                    resolvedPadding!.bottom + childLayoutGeometry.scrollExtent,
                to: resolvedPadding!.bottom +
                    childLayoutGeometry.scrollExtent +
                    resolvedPadding!.top));
      case AxisDirection.right:
        childParentData.paintOffset = Offset(
            calculatePaintOffset(constraints,
                from: 0.0, to: resolvedPadding!.left),
            crossPosition(constraints, resolvedPadding!.top));
      case AxisDirection.down:
        childParentData.paintOffset = Offset(
            crossPosition(constraints, _resolvedPadding!.left),
            calculatePaintOffset(constraints,
                from: 0.0, to: resolvedPadding!.top));
      case AxisDirection.left:
        childParentData.paintOffset = Offset(
            calculatePaintOffset(constraints,
                from: resolvedPadding!.right + childLayoutGeometry.scrollExtent,
                to: resolvedPadding!.right +
                    childLayoutGeometry.scrollExtent +
                    resolvedPadding!.left),
            crossPosition(constraints, resolvedPadding!.top));
    }
    assert(beforePadding == this.beforePadding);
    assert(afterPadding == this.afterPadding);
    assert(mainAxisPadding == this.mainAxisPadding);
    assert(crossAxisPadding == this.crossAxisPadding);
  }

  double crossSize(SliverConstraints constraints) {
    double innerCrossExtent = constraints.crossAxisExtent - crossAxisPadding;
    final m = maxCrossSize;
    return m != null && innerCrossExtent > m ? m : innerCrossExtent;
  }

  double crossPosition(
    SliverConstraints constraints,
    double padding,
  ) {
    final m = maxCrossSize;
    if (m == null) {
      return padding;
    }
    double innerCrossExtent = constraints.crossAxisExtent - crossAxisPadding;

    return padding +
        (innerCrossExtent > m ? alongOffset(innerCrossExtent - m) : 0.0);
  }

  double alongOffset(double other) {
    final double center = other / 2.0;

    return center + crossAlign * center;
  }

  @override
  double childCrossAxisPosition(RenderSliver child) {
    final constraints = this.constraints;

    assert(child == this.child);
    assert(resolvedPadding != null);
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
      case AxisDirection.down:
        return crossPosition(constraints, resolvedPadding!.left);
      case AxisDirection.left:
      case AxisDirection.right:
        return crossPosition(constraints, resolvedPadding!.top);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
  }
}
