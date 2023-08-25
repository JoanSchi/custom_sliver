import 'package:custom_sliver/layers/sliver_layer_constraints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class SliverLayer extends SingleChildRenderObjectWidget {
  /// Creates a sliver that contains a single box widget.
  const SliverLayer({
    super.key,
    super.child,
  });

  @override
  RenderSliverLayer createRenderObject(BuildContext context) =>
      RenderSliverLayer();
}

class RenderSliverLayer<T> extends RenderObject
    with RenderObjectWithChildMixin<RenderBox> {
  // layout input
  @override
  SliverLayerConstraints get constraints =>
      super.constraints as SliverLayerConstraints;

  @override
  Rect get semanticBounds => paintBounds;

  @override
  Rect get paintBounds {
    switch (constraints.axis) {
      case Axis.horizontal:
        return Rect.fromLTWH(
          0.0,
          0.0,
          constraints.layoutExtent,
          constraints.crossAxisExtent,
        );
      case Axis.vertical:
        return Rect.fromLTWH(
          0.0,
          0.0,
          constraints.crossAxisExtent,
          constraints.layoutExtent,
        );
    }
  }

  @override
  void performLayout() {
    layoutChild(constraints);
  }

  Offset calculateOffsetForChild(
    SliverLayerConstraints constraints,
  ) =>
      Offset.zero;

  BoxConstraints calculateBoxConstraintsForChild(
    SliverLayerConstraints constraints,
  ) {
    final mainlength = math.max(
        math.min(constraints.scrollExtent - constraints.scrollOffset,
            constraints.layoutExtent),
        0.0);
    final crossAxisLength = constraints.crossAxisExtent;

    return constraints.axis == Axis.vertical
        ? BoxConstraints(maxWidth: crossAxisLength, maxHeight: mainlength)
        : BoxConstraints(maxWidth: mainlength, maxHeight: crossAxisLength);
  }

  void layoutChild(
    SliverLayerConstraints constraints,
  ) {
    if (child == null) {
      return;
    }
    child!.layout(calculateBoxConstraintsForChild(constraints));
    final childParent = child!.parentData as BoxParentData;
    childParent.offset = calculateOffsetForChild(constraints);
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  void debugResetSize() {}

  T buildObject(double scrollOffset, double scrollExtent, double layoutExtent) {
    throw UnimplementedError();
  }

  void updateChild(
    T object,
  ) {
    throw UnimplementedError();
  }

  @override
  void debugAssertDoesMeetConstraints() {
    // assert(geometry!.debugAssertIsValid(
    //   informationCollector: () => <DiagnosticsNode>[
    //     describeForError('The RenderSliver that returned the offending geometry was'),
    //   ],
    // ));
    // assert(() {
    //   if (geometry!.paintOrigin + geometry!.paintExtent > constraints.remainingPaintExtent) {
    //     throw FlutterError.fromParts(<DiagnosticsNode>[
    //       ErrorSummary('SliverGeometry has a paintOffset that exceeds the remainingPaintExtent from the constraints.'),
    //       describeForError('The render object whose geometry violates the constraints is the following'),
    //       ..._debugCompareFloats(
    //         'remainingPaintExtent', constraints.remainingPaintExtent,
    //         'paintOrigin + paintExtent', geometry!.paintOrigin + geometry!.paintExtent,
    //       ),
    //       ErrorDescription(
    //         'The paintOrigin and paintExtent must cause the child sliver to paint '
    //         'within the viewport, and so cannot exceed the remainingPaintExtent.',
    //       ),
    //     ]);
    //   }
    //   return true;
    // }());
  }

  @override
  void performResize() {
    assert(false);
  }

  /// For a center sliver, the distance before the absolute zero scroll offset
  /// that this sliver can cover.
  ///
  /// For example, if an [AxisDirection.down] viewport with an
  /// [RenderViewport.anchor] of 0.5 has a single sliver with a height of 100.0
  /// and its [centerOffsetAdjustment] returns 50.0, then the sliver will be
  /// centered in the viewport when the scroll offset is 0.0.
  ///
  /// The distance here is in the opposite direction of the
  /// [RenderViewport.axisDirection], so values will typically be positive.
  double get centerOffsetAdjustment => 0.0;

  /// Determines the set of render objects located at the given position.
  ///
  /// Returns true if the given point is contained in this render object or one
  /// of its descendants. Adds any render objects that contain the point to the
  /// given hit test result.
  ///
  /// The caller is responsible for providing the position in the local
  /// coordinate space of the callee. The callee is responsible for checking
  /// whether the given position is within its bounds.
  ///
  /// Hit testing requires layout to be up-to-date but does not require painting
  /// to be up-to-date. That means a render object can rely upon [performLayout]
  /// having been called in [hitTest] but cannot rely upon [paint] having been
  /// called. For example, a render object might be a child of a [RenderOpacity]
  /// object, which calls [hitTest] on its children when its opacity is zero
  /// even through it does not [paint] its children.
  ///
  /// ## Coordinates for RenderSliver objects
  ///
  /// The `mainAxisPosition` is the distance in the [AxisDirection] (after
  /// applying the [GrowthDirection]) from the edge of the sliver's painted
  /// area. This can be an unusual direction, for example in the
  /// [AxisDirection.up] case this is a distance from the _bottom_ of the
  /// sliver's painted area.
  ///
  /// The `crossAxisPosition` is the distance in the other axis. If the cross
  /// axis is horizontal (i.e. the [SliverConstraints.axisDirection] is either
  /// [AxisDirection.down] or [AxisDirection.up]), then the `crossAxisPosition`
  /// is a distance from the left edge of the sliver. If the cross axis is
  /// vertical (i.e. the [SliverConstraints.axisDirection] is either
  /// [AxisDirection.right] or [AxisDirection.left]), then the
  /// `crossAxisPosition` is a distance from the top edge of the sliver.
  ///
  /// ## Implementing hit testing for slivers
  ///
  /// The most straight-forward way to implement hit testing for a new sliver
  /// render object is to override its [hitTestSelf] and [hitTestChildren]
  /// methods.
  bool hitTest(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (mainAxisPosition >= 0.0 &&
        mainAxisPosition < constraints.layoutExtent &&
        crossAxisPosition >= 0.0 &&
        crossAxisPosition < constraints.crossAxisExtent) {
      if (hitTestChildren(result,
              mainAxisPosition: mainAxisPosition,
              crossAxisPosition: crossAxisPosition) ||
          hitTestSelf(
              mainAxisPosition: mainAxisPosition,
              crossAxisPosition: crossAxisPosition)) {
        // result.add(SliverHitTestEntry(
        //   this,
        //   mainAxisPosition: mainAxisPosition,
        //   crossAxisPosition: crossAxisPosition,
        // )
        // result.add(SliverLayerHitTestEntry(
        //   this,
        //   crossAxisPosition: crossAxisPosition,
        //   mainAxisPosition: mainAxisPosition,
        // ));
        return true;
      }
    }
    return false;
  }

  @protected
  bool hitTestSelf(
          {required double mainAxisPosition,
          required double crossAxisPosition}) =>
      false;

  @protected
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (child != null) {
      return simplyfiedHitTestBoxChild(BoxHitTestResult.wrap(result), child!,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition);
    }
    return false;
  }

  // Simplified hitTestBoxChild
  bool simplyfiedHitTestBoxChild(BoxHitTestResult result, RenderBox child,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    final double crossAxisDelta = childCrossAxisPosition(child);
    double absolutePosition = mainAxisPosition;
    final double absoluteCrossAxisPosition = crossAxisPosition - crossAxisDelta;
    Offset paintOffset, transformedPosition;

    paintOffset = (constraints.axis == Axis.vertical
        ? Offset(crossAxisDelta, 0.0)
        : Offset(0.0, crossAxisDelta));
    final positionChild = calculateOffsetForChild(constraints);

    transformedPosition = (constraints.axis == Axis.vertical
            ? Offset(absoluteCrossAxisPosition, absolutePosition)
            : Offset(absolutePosition, absoluteCrossAxisPosition)) -
        positionChild;

    final resultChild = result.addWithOutOfBandPosition(
      paintOffset: paintOffset,
      hitTest: (BoxHitTestResult result) {
        return child.hitTest(result, position: transformedPosition);
      },
    );
    // debugPrint(
    //     'hit box $resultChild mainAxisPosition: $mainAxisPosition  $crossAxisPosition: positionChild: $positionChild');
    return resultChild;
  }

  /// Computes the portion of the region from `from` to `to` that is visible,
  /// assuming that only the region from the [SliverConstraints.scrollOffset]
  /// that is [SliverConstraints.remainingPaintExtent] high is visible, and that
  /// the relationship between scroll offsets and paint offsets is linear.
  ///
  /// For example, if the constraints have a scroll offset of 100 and a
  /// remaining paint extent of 100, and the arguments to this method describe
  /// the region 50..150, then the returned value would be 50 (from scroll
  /// offset 100 to scroll offset 150).
  ///
  /// This method is not useful if there is not a 1:1 relationship between
  /// consumed scroll offset and consumed paint extent. For example, if the
  /// sliver always paints the same amount but consumes a scroll offset extent
  /// that is proportional to the [SliverConstraints.scrollOffset], then this
  /// function's results will not be consistent.
  // This could be a static method but isn't, because it would be less convenient
  // to call it from subclasses if it was.
  // double calculatePaintOffset(SliverConstraints constraints,
  //     {required double from, required double to}) {
  //   assert(from <= to);
  //   final double a = constraints.scrollOffset;
  //   final double b =
  //       constraints.scrollOffset + constraints.remainingPaintExtent;
  //   // the clamp on the next line is to avoid floating point rounding errors
  //   return clampDouble(clampDouble(to, a, b) - clampDouble(from, a, b), 0.0,
  //       constraints.remainingPaintExtent);
  // }

  /// Computes the portion of the region from `from` to `to` that is within
  /// the cache extent of the viewport, assuming that only the region from the
  /// [SliverConstraints.cacheOrigin] that is
  /// [SliverConstraints.remainingCacheExtent] high is visible, and that
  /// the relationship between scroll offsets and paint offsets is linear.
  ///
  /// This method is not useful if there is not a 1:1 relationship between
  /// consumed scroll offset and consumed cache extent.
  // double calculateCacheOffset(SliverConstraints constraints,
  //     {required double from, required double to}) {
  //   assert(from <= to);
  //   final double a = constraints.scrollOffset + constraints.cacheOrigin;
  //   final double b =
  //       constraints.scrollOffset + constraints.remainingCacheExtent;
  //   // the clamp on the next line is to avoid floating point rounding errors
  //   return clampDouble(clampDouble(to, a, b) - clampDouble(from, a, b), 0.0,
  //       constraints.remainingCacheExtent);
  // }

  /// Returns the distance from the leading _visible_ edge of the sliver to the
  /// side of the given child closest to that edge.
  ///
  /// For example, if the [constraints] describe this sliver as having an axis
  /// direction of [AxisDirection.down], then this is the distance from the top
  /// of the visible portion of the sliver to the top of the child. On the other
  /// hand, if the [constraints] describe this sliver as having an axis
  /// direction of [AxisDirection.up], then this is the distance from the bottom
  /// of the visible portion of the sliver to the bottom of the child. In both
  /// cases, this is the direction of increasing
  /// [SliverConstraints.scrollOffset] and
  /// [SliverLogicalParentData.layoutOffset].
  ///
  /// For children that are [RenderSliver]s, the leading edge of the _child_
  /// will be the leading _visible_ edge of the child, not the part of the child
  /// that would locally be a scroll offset 0.0. For children that are not
  /// [RenderSliver]s, for example a [RenderBox] child, it's the actual distance
  /// to the edge of the box, since those boxes do not know how to handle being
  /// scrolled.
  ///
  /// This method differs from [childScrollOffset] in that
  /// [childMainAxisPosition] gives the distance from the leading _visible_ edge
  /// of the sliver whereas [childScrollOffset] gives the distance from the
  /// sliver's zero scroll offset.
  ///
  /// Calling this for a child that is not visible is not valid.
  @protected
  double childMainAxisPosition(covariant RenderObject child) {
    assert(() {
      throw FlutterError(
          '${objectRuntimeType(this, 'RenderSliver')} does not implement childPosition.');
    }());
    return 0.0;
  }

  /// Returns the distance along the cross axis from the zero of the cross axis
  /// in this sliver's [paint] coordinate space to the nearest side of the given
  /// child.
  ///
  /// For example, if the [constraints] describe this sliver as having an axis
  /// direction of [AxisDirection.down], then this is the distance from the left
  /// of the sliver to the left of the child. Similarly, if the [constraints]
  /// describe this sliver as having an axis direction of [AxisDirection.up],
  /// then this is value is the same. If the axis direction is
  /// [AxisDirection.left] or [AxisDirection.right], then it is the distance
  /// from the top of the sliver to the top of the child.
  ///
  /// Calling this for a child that is not visible is not valid.
  @protected
  double childCrossAxisPosition(covariant RenderObject child) => 0.0;

  /// Returns the scroll offset for the leading edge of the given child.
  ///
  /// The `child` must be a child of this sliver.
  ///
  /// This method differs from [childMainAxisPosition] in that
  /// [childMainAxisPosition] gives the distance from the leading _visible_ edge
  /// of the sliver whereas [childScrollOffset] gives the distance from sliver's
  /// zero scroll offset.
  double? childScrollOffset(covariant RenderObject child) {
    assert(child.parent == this);
    return 0.0;
  }

  /// This returns a [Size] with dimensions relative to the leading edge of the
  /// sliver, specifically the same offset that is given to the [paint] method.
  /// This means that the dimensions may be negative.
  ///
  /// This is only valid after [layout] has completed.
  ///
  /// See also:
  ///
  ///  * [getAbsoluteSize], which returns absolute size.

  Size getAbsoluteSizeRelativeToOrigin() {
    return Size(constraints.crossAxisExtent, constraints.layoutExtent);

    // assert(geometry != null);
    // assert(!debugNeedsLayout);
    // switch (applyGrowthDirectionToAxisDirection(
    //     constraints.axisDirection, constraints.growthDirection)) {
    //   case AxisDirection.up:
    //     return Size(constraints.crossAxisExtent, -geometry!.paintExtent);
    //   case AxisDirection.right:
    //     return Size(geometry!.paintExtent, constraints.crossAxisExtent);
    //   case AxisDirection.down:
    //     return Size(constraints.crossAxisExtent, geometry!.paintExtent);
    //   case AxisDirection.left:
    //     return Size(-geometry!.paintExtent, constraints.crossAxisExtent);
    // }
  }

  /// This returns the absolute [Size] of the sliver.
  ///
  /// The dimensions are always positive and calling this is only valid after
  /// [layout] has completed.
  ///
  /// See also:
  ///
  ///  * [getAbsoluteSizeRelativeToOrigin], which returns the size relative to
  ///    the leading edge of the sliver.

  Size getAbsoluteSize() {
    return Size(constraints.crossAxisExtent, constraints.layoutExtent);
    // assert(geometry != null);
    // assert(!debugNeedsLayout);
    // switch (constraints.axisDirection) {
    //   case AxisDirection.up:
    //   case AxisDirection.down:
    //     return Size(constraints.crossAxisExtent, geometry!.paintExtent);
    //   case AxisDirection.right:
    //   case AxisDirection.left:
    //     return Size(geometry!.paintExtent, constraints.crossAxisExtent);
    // }
  }

  // void _debugDrawArrow(Canvas canvas, Paint paint, Offset p0, Offset p1,
  //     GrowthDirection direction) {
  //   assert(() {
  //     if (p0 == p1) {
  //       return true;
  //     }
  //     assert(p0.dx == p1.dx || p0.dy == p1.dy); // must be axis-aligned
  //     final double d = (p1 - p0).distance * 0.2;
  //     final Offset temp;
  //     double dx1, dx2, dy1, dy2;
  //     switch (direction) {
  //       case GrowthDirection.forward:
  //         dx1 = dx2 = dy1 = dy2 = d;
  //       case GrowthDirection.reverse:
  //         temp = p0;
  //         p0 = p1;
  //         p1 = temp;
  //         dx1 = dx2 = dy1 = dy2 = -d;
  //     }
  //     if (p0.dx == p1.dx) {
  //       dx2 = -dx2;
  //     } else {
  //       dy2 = -dy2;
  //     }
  //     canvas.drawPath(
  //       Path()
  //         ..moveTo(p0.dx, p0.dy)
  //         ..lineTo(p1.dx, p1.dy)
  //         ..moveTo(p1.dx - dx1, p1.dy - dy1)
  //         ..lineTo(p1.dx, p1.dy)
  //         ..lineTo(p1.dx - dx2, p1.dy - dy2),
  //       paint,
  //     );
  //     return true;
  //   }());
  // }

  // @override
  // void debugPaint(PaintingContext context, Offset offset) {
  //   assert(() {
  //     if (debugPaintSizeEnabled) {
  //       final double strokeWidth = math.min(4.0, geometry!.paintExtent / 30.0);
  //       final Paint paint = Paint()
  //         ..color = const Color(0xFF33CC33)
  //         ..strokeWidth = strokeWidth
  //         ..style = PaintingStyle.stroke
  //         ..maskFilter = MaskFilter.blur(BlurStyle.solid, strokeWidth);
  //       final double arrowExtent = geometry!.paintExtent;
  //       final double padding = math.max(2.0, strokeWidth);
  //       final Canvas canvas = context.canvas;
  //       canvas.drawCircle(
  //         offset.translate(padding, padding),
  //         padding * 0.5,
  //         paint,
  //       );
  //       switch (constraints.axis) {
  //         case Axis.vertical:
  //           canvas.drawLine(
  //             offset,
  //             offset.translate(constraints.crossAxisExtent, 0.0),
  //             paint,
  //           );
  //           _debugDrawArrow(
  //             canvas,
  //             paint,
  //             offset.translate(
  //                 constraints.crossAxisExtent * 1.0 / 4.0, padding),
  //             offset.translate(constraints.crossAxisExtent * 1.0 / 4.0,
  //                 arrowExtent - padding),
  //             constraints.normalizedGrowthDirection,
  //           );
  //           _debugDrawArrow(
  //             canvas,
  //             paint,
  //             offset.translate(
  //                 constraints.crossAxisExtent * 3.0 / 4.0, padding),
  //             offset.translate(constraints.crossAxisExtent * 3.0 / 4.0,
  //                 arrowExtent - padding),
  //             constraints.normalizedGrowthDirection,
  //           );
  //         case Axis.horizontal:
  //           canvas.drawLine(
  //             offset,
  //             offset.translate(0.0, constraints.crossAxisExtent),
  //             paint,
  //           );
  //           _debugDrawArrow(
  //             canvas,
  //             paint,
  //             offset.translate(
  //                 padding, constraints.crossAxisExtent * 1.0 / 4.0),
  //             offset.translate(arrowExtent - padding,
  //                 constraints.crossAxisExtent * 1.0 / 4.0),
  //             constraints.normalizedGrowthDirection,
  //           );
  //           _debugDrawArrow(
  //             canvas,
  //             paint,
  //             offset.translate(
  //                 padding, constraints.crossAxisExtent * 3.0 / 4.0),
  //             offset.translate(arrowExtent - padding,
  //                 constraints.crossAxisExtent * 3.0 / 4.0),
  //             constraints.normalizedGrowthDirection,
  //           );
  //       }
  //     }
  //     return true;
  //   }());
  // }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final childParentData = child!.parentData! as BoxParentData;
      context.paintChild(child!, childParentData.offset + offset);
    }
  }

  // This override exists only to change the type of the second argument.
  @override
  void handleEvent(PointerEvent event, SliverHitTestEntry entry) {}

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(DiagnosticsProperty<SliverGeometry>('geometry', geometry));
  }
}

// typedef SliverLayerHitTest = bool Function(SliverHitLayerTestResult result,
//     {required double mainAxisPosition, required double crossAxisPosition});

// class SliverHitLayerTestResult extends HitTestResult {
//   /// Creates an empty hit test result for hit testing on [RenderSliver].
//   SliverHitLayerTestResult() : super();

//   SliverHitLayerTestResult.wrap(super.result) : super.wrap();

//   bool addWithAxisOffset({
//     required Offset? paintOffset,
//     required double mainAxisOffset,
//     required double crossAxisOffset,
//     required double mainAxisPosition,
//     required double crossAxisPosition,
//     required SliverLayerHitTest hitTest,
//   }) {
//     if (paintOffset != null) {
//       pushOffset(-paintOffset);
//     }
//     final bool isHit = hitTest(
//       this,
//       mainAxisPosition: mainAxisPosition - mainAxisOffset,
//       crossAxisPosition: crossAxisPosition - crossAxisOffset,
//     );
//     if (paintOffset != null) {
//       popTransform();
//     }
//     return isHit;
//   }
// }

// class SliverLayerHitTestEntry extends HitTestEntry<RenderSliverLayer> {
//   /// Creates a sliver hit test entry.
//   ///
//   /// The [mainAxisPosition] and [crossAxisPosition] arguments must not be null.
//   SliverLayerHitTestEntry(
//     super.target, {
//     required this.mainAxisPosition,
//     required this.crossAxisPosition,
//   });

//   /// The distance in the [AxisDirection] from the edge of the sliver's painted
//   /// area (as given by the [SliverConstraints.scrollOffset]) to the hit point.
//   /// This can be an unusual direction, for example in the [AxisDirection.up]
//   /// case this is a distance from the _bottom_ of the sliver's painted area.
//   final double mainAxisPosition;

//   /// The distance to the hit point in the axis opposite the
//   /// [SliverConstraints.axis].
//   ///
//   /// If the cross axis is horizontal (i.e. the
//   /// [SliverConstraints.axisDirection] is either [AxisDirection.down] or
//   /// [AxisDirection.up]), then the [crossAxisPosition] is a distance from the
//   /// left edge of the sliver. If the cross axis is vertical (i.e. the
//   /// [SliverConstraints.axisDirection] is either [AxisDirection.right] or
//   /// [AxisDirection.left]), then the [crossAxisPosition] is a distance from the
//   /// top edge of the sliver.
//   ///
//   /// This is always a distance from the left or top of the parent, never a
//   /// distance from the right or bottom.
//   final double crossAxisPosition;

//   @override
//   String toString() =>
//       '${target.runtimeType}@(mainAxis: $mainAxisPosition, crossAxis: $crossAxisPosition)';
// }
