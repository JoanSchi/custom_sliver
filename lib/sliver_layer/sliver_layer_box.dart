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
import 'sliver_layer.dart';
import 'sliver_layer_constraints.dart';

class SliverLayerBox extends MultiChildRenderObjectWidget {
  const SliverLayerBox({
    super.key,
    super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverLayerBox();
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderSliverLayerBox renderObject) {
    // renderObject
    // SliverToBoxAdapter();
    // SliverPadding();
  }
}

class RenderSliverLayerBox extends RenderSliver
    with
        ContainerRenderObjectMixin<RenderObject,
            MultiSliverPhysicalParentData> {
  @override
  void performLayout() {
    RenderObject? child = firstChild;

    if (firstChild == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    final SliverConstraints constraints = this.constraints;

    SliverGeometry? childLayoutGeometry;

    while (child != null) {
      switch (child) {
        case (RenderSliver renderSliver):
          {
            renderSliver.layout(
              constraints.copyWith(
                scrollOffset: math.max(0.0, constraints.scrollOffset),
                cacheOrigin: math.min(0.0, constraints.cacheOrigin),
                overlap: constraints.overlap,
                remainingPaintExtent: constraints.remainingPaintExtent -
                    calculatePaintOffset(constraints, from: 0.0, to: 0.0),
                remainingCacheExtent: constraints.remainingCacheExtent -
                    calculateCacheOffset(constraints, from: 0.0, to: 0.0),
                crossAxisExtent: math.max(0.0, constraints.crossAxisExtent),
                precedingScrollExtent: constraints.precedingScrollExtent,
              ),
              parentUsesSize: true,
            );

            childLayoutGeometry = renderSliver.geometry!;
            if (childLayoutGeometry.scrollOffsetCorrection != null) {
              geometry = SliverGeometry(
                scrollOffsetCorrection:
                    childLayoutGeometry.scrollOffsetCorrection,
              );
              return;
            }

            final double paintExtent = math.min(
              math.max(childLayoutGeometry.paintExtent,
                  childLayoutGeometry.layoutExtent),
              constraints.remainingPaintExtent,
            );

            geometry = SliverGeometry(
              paintOrigin: childLayoutGeometry.paintOrigin,
              scrollExtent: childLayoutGeometry.scrollExtent,
              paintExtent: paintExtent,
              layoutExtent:
                  math.min(childLayoutGeometry.layoutExtent, paintExtent),
              cacheExtent: math.min(childLayoutGeometry.cacheExtent,
                  constraints.remainingCacheExtent),
              maxPaintExtent: childLayoutGeometry.maxPaintExtent,
              hitTestExtent: math.max(
                childLayoutGeometry.paintExtent,
                childLayoutGeometry.hitTestExtent,
              ),
              hasVisualOverflow: childLayoutGeometry.hasVisualOverflow,
            );
          }
      }

      final childParent = child.parentData as ContainerBoxParentData;
      child = childParent.nextSibling;
    }

    if (childLayoutGeometry == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child = firstChild;

    while (child != null) {
      switch (child) {
        // case (RenderSliverFrame renderSliverFrame):
        //   {
        //     renderSliverFrame.layout(SliverLayerConstraints(
        //         axisDirection: constraints.axis,
        //         scrollOffset: constraints.scrollOffset,
        //         scrollExtent: childLayoutGeometry.scrollExtent,
        //         overlap: constraints.overlap,
        //         crossAxisExtent: constraints.crossAxisExtent,
        //         viewportMainAxisExtent: constraints.viewportMainAxisExtent));
        //     break;
        //   }
        case (RenderSliverLayer renderSliverLayer):
          {
            renderSliverLayer.layout(SliverLayerConstraints(
                axis: constraints.axis,
                scrollOffset: constraints.scrollOffset,
                scrollExtent: childLayoutGeometry.scrollExtent,
                overlap: constraints.overlap,
                crossAxisExtent: constraints.crossAxisExtent,
                layoutExtent: childLayoutGeometry.layoutExtent));
            break;
          }
      }
      final childParent = child.parentData as ContainerBoxParentData;
      child = childParent.nextSibling;
    }

    ///
    ///
    ///
    ///
    ///

    // child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    // final double childExtent;

    // switch (constraints.axis) {
    //   case Axis.horizontal:
    //     childExtent = child!.size.width;
    //   case Axis.vertical:
    //     childExtent = child!.size.height;
    // }
    // final double paintedChildSize =
    //     calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    // final double cacheExtent =
    //     calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    // assert(paintedChildSize.isFinite);
    // assert(paintedChildSize >= 0.0);
    // geometry = SliverGeometry(
    //   scrollExtent: childExtent,
    //   paintExtent: paintedChildSize,
    //   cacheExtent: cacheExtent,
    //   maxPaintExtent: childExtent,
    //   hitTestExtent: paintedChildSize,
    //   hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
    //       constraints.scrollOffset > 0.0,
    // );
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! MultiSliverPhysicalParentData) {
      child.parentData = MultiSliverPhysicalParentData();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderObject? child = firstChild;
    while (child != null) {
      final childParentData =
          child.parentData! as MultiSliverPhysicalParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;
    }
  }

  // bool hitTest(SliverHitTestResult result,
  //     {required double mainAxisPosition, required double crossAxisPosition}) {

  //   if (mainAxisPosition >= 0.0 &&
  //       mainAxisPosition < constraints.viewportMainAxisExtent &&
  //       crossAxisPosition >= 0.0 &&
  //       crossAxisPosition < constraints.crossAxisExtent) {
  //     if (hitTestChildren(result,
  //             mainAxisPosition: mainAxisPosition,
  //             crossAxisPosition: crossAxisPosition) ||
  //         hitTestSelf(
  //             mainAxisPosition: mainAxisPosition,
  //             crossAxisPosition: crossAxisPosition)) {
  //       // result.add(SliverHitTestEntry(
  //       //   this,
  //       //   mainAxisPosition: mainAxisPosition,
  //       //   crossAxisPosition: crossAxisPosition,
  //       // )
  //       result.add(HitTestEntry(
  //         this,
  //       ));
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  @override
  bool hitTestSelf(
          {required double mainAxisPosition,
          required double crossAxisPosition}) =>
      false;

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    RenderObject? child = lastChild;
    while (child != null) {
      final childParentData =
          child.parentData! as MultiSliverPhysicalParentData;

      switch (child) {
        case (RenderSliver renderSliver):
          {
            if (renderSliver.geometry!.hitTestExtent > 0.0) {
              // final MultiSliverPhysicalParentData childParentData =
              //     renderSliver.parentData! as MultiSliverPhysicalParentData;
              bool hit = result.addWithAxisOffset(
                mainAxisPosition: mainAxisPosition,
                crossAxisPosition: crossAxisPosition,
                mainAxisOffset: childMainAxisPosition(renderSliver),
                crossAxisOffset: childCrossAxisPosition(renderSliver),
                paintOffset: childParentData.paintOffset,
                hitTest: renderSliver.hitTest,
              );

              if (hit) {
                return true;
              }
            }
            break;
          }
        case (RenderSliverLayer renderSliverLayer):
          {
            if (renderSliverLayer.constraints.layoutExtent > 0.0) {
              bool hit = result.addWithAxisOffset(
                mainAxisPosition: mainAxisPosition,
                crossAxisPosition: crossAxisPosition,
                mainAxisOffset: 0.0,
                crossAxisOffset: 0.0,
                paintOffset: childParentData.paintOffset,
                hitTest: renderSliverLayer.hitTest,
              );

              if (hit) {
                return true;
              }
            }
            break;
          }
        default:
          {}
      }

      child = childParentData.previousSibling;
    }
    // if (child != null) {
    //   return simplyfiedHitTestBoxChild(BoxHitTestResult.wrap(result), child!,
    //       mainAxisPosition: mainAxisPosition,
    //       crossAxisPosition: crossAxisPosition);
    // }
    return false;
  }

  @override
  double childMainAxisPosition(RenderSliver child) {
    return 0.0;
  }

  @override
  double childCrossAxisPosition(RenderSliver child) {
    return 0.0;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    final MultiSliverPhysicalParentData childParentData =
        child.parentData! as MultiSliverPhysicalParentData;
    childParentData.applyPaintTransform(transform);
  }
}

class MultiSliverPhysicalParentData
    extends ContainerBoxParentData<RenderObject> {
  Offset paintOffset = Offset.zero;

  void applyPaintTransform(Matrix4 transform) {
    // Hit test logic relies on this always providing an invertible matrix.
    transform.translate(paintOffset.dx, paintOffset.dy);
  }

  @override
  String toString() => 'paintOffset=$paintOffset';
}
