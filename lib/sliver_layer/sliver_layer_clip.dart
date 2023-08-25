// Copyright 2023 Joan Schipper. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class SliverLayerClipRRect extends SingleChildRenderObjectWidget {
  /// Creates a sliver that applies padding on each side of another sliver.
  ///
  /// The [padding] argument must not be null.
  const SliverLayerClipRRect({
    super.key,
    this.borderRadius = BorderRadius.zero,
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
    Widget? sliver,
  }) : super(child: sliver);

  final BorderRadiusGeometry? borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip clipBehavior;

  @override
  RenderClipRRect createRenderObject(BuildContext context) {
    return RenderClipRRect(
        borderRadius: borderRadius!,
        clipper: clipper,
        clipBehavior: clipBehavior);
  }

  @override
  void updateRenderObject(BuildContext context, RenderClipRRect renderObject) {
    renderObject
      ..borderRadius = borderRadius!
      ..clipper = clipper
      ..clipBehavior = clipBehavior;
  }
}

class RenderClipRRect extends RenderSliverLayerClip<RRect> {
  /// Creates a rounded-rectangular clip.
  ///
  /// The [borderRadius] defaults to [BorderRadius.zero], i.e. a rectangle with
  /// right-angled corners.
  ///
  /// If [clipper] is non-null, then [borderRadius] is ignored.
  ///
  /// The [clipBehavior] argument must not be null. If [clipBehavior] is
  /// [Clip.none], no clipping will be applied.
  RenderClipRRect({
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    super.clipper,
    super.clipBehavior,
    TextDirection? textDirection,
  })  : _borderRadius = borderRadius,
        _textDirection = textDirection;

  /// The border radius of the rounded corners.
  ///
  /// Values are clamped so that horizontal and vertical radii sums do not
  /// exceed width/height.
  ///
  /// This value is ignored if [clipper] is non-null.
  BorderRadiusGeometry get borderRadius => _borderRadius;
  BorderRadiusGeometry _borderRadius;
  set borderRadius(BorderRadiusGeometry value) {
    if (_borderRadius == value) {
      return;
    }
    _borderRadius = value;
    _markNeedsClip();
  }

  /// The text direction with which to resolve [borderRadius].
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    _markNeedsClip();
  }

  @override
  RRect _defaultClip(Offset offset) =>
      _borderRadius.resolve(textDirection).toRRect(offset & constraintsToSize);

  // @override
  // RRect get _defaultClip =>
  //     RRect.fromRectAndCorners(Offset.zero & constraintsToSize);

  // @override
  // bool hitTest(BoxHitTestResult result, { required Offset position }) {
  //   if (_clipper != null) {
  //     _updateClip();
  //     assert(_clip != null);
  //     if (!_clip!.contains(position)) {
  //       return false;
  //     }
  //   }
  //   return super.hitTest(result, position: position);
  // }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && child!.geometry!.visible) {
      if (clipBehavior != Clip.none) {
        _updateClip(offset);
        layer = context.pushClipRRect(
          needsCompositing,
          offset,
          _clip!.outerRect,
          _clip!,
          super.paint,
          clipBehavior: clipBehavior,
          oldLayer: layer as ClipRRectLayer?,
        );
      } else {
        super.paint(context, offset);
        layer = null;
      }
    } else {
      layer = null;
    }
  }

  // @override
  // void debugPaintSize(PaintingContext context, Offset offset) {
  //   // assert(() {
  //   //   if (child != null) {
  //   //     super.debugPaintSize(context, offset);
  //   //     if (clipBehavior != Clip.none) {
  //   //       context.canvas.drawRRect(_clip!.shift(offset), _debugPaint!);
  //   //       _debugText!.paint(context.canvas, offset + Offset(_clip!.tlRadiusX, -_debugText!.text!.style!.fontSize! * 1.1));
  //   //     }
  //   //   }
  //   //   return true;
  //   // }());
  // }
}

abstract class RenderSliverLayerClip<T> extends RenderSliver
    with RenderObjectWithChildMixin<RenderSliver> {
  RenderSliverLayerClip(
      {Clip? clipBehavior, required CustomClipper<T>? clipper})
      : _clipBehavior = clipBehavior ?? Clip.none,
        _clipper = clipper;

  CustomClipper<T>? get clipper => _clipper;
  CustomClipper<T>? _clipper;
  set clipper(CustomClipper<T>? newClipper) {
    if (_clipper == newClipper) {
      return;
    }
    final CustomClipper<T>? oldClipper = _clipper;
    _clipper = newClipper;
    assert(newClipper != null || oldClipper != null);
    if (newClipper == null ||
        oldClipper == null ||
        newClipper.runtimeType != oldClipper.runtimeType ||
        newClipper.shouldReclip(oldClipper)) {
      _markNeedsClip();
    }
    if (attached) {
      oldClipper?.removeListener(_markNeedsClip);
      newClipper?.addListener(_markNeedsClip);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _clipper?.addListener(_markNeedsClip);
  }

  @override
  void detach() {
    _clipper?.removeListener(_markNeedsClip);
    super.detach();
  }

  void _markNeedsClip() {
    _clip = null;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  T _defaultClip(Offset offset);
  T? _clip;

  Clip get clipBehavior => _clipBehavior;
  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
    }
  }

  Clip _clipBehavior;

  Size _lastClipSize = Size.zero;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData) {
      child.parentData = SliverPhysicalParentData();
    }
  }

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;

    child!.layout(
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

    SliverGeometry childLayoutGeometry = child!.geometry!;
    if (childLayoutGeometry.scrollOffsetCorrection != null) {
      geometry = SliverGeometry(
        scrollOffsetCorrection: childLayoutGeometry.scrollOffsetCorrection,
      );
      return;
    }

    final double paintExtent = math.min(
      math.max(
          childLayoutGeometry.paintExtent, childLayoutGeometry.layoutExtent),
      constraints.remainingPaintExtent,
    );

    geometry = SliverGeometry(
      paintOrigin: childLayoutGeometry.paintOrigin,
      scrollExtent: childLayoutGeometry.scrollExtent,
      paintExtent: paintExtent,
      layoutExtent: math.min(childLayoutGeometry.layoutExtent, paintExtent),
      cacheExtent: math.min(
          childLayoutGeometry.cacheExtent, constraints.remainingCacheExtent),
      maxPaintExtent: childLayoutGeometry.maxPaintExtent,
      hitTestExtent: math.max(
        childLayoutGeometry.paintExtent,
        childLayoutGeometry.hitTestExtent,
      ),
      hasVisualOverflow: childLayoutGeometry.hasVisualOverflow,
    );
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (child != null && child!.geometry!.hitTestExtent > 0.0) {
      final SliverPhysicalParentData childParentData =
          child!.parentData! as SliverPhysicalParentData;
      result.addWithAxisOffset(
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
        mainAxisOffset: childMainAxisPosition(child!),
        crossAxisOffset: childCrossAxisPosition(child!),
        paintOffset: childParentData.paintOffset,
        hitTest: child!.hitTest,
      );
    }
    return false;
  }

  @override
  double childMainAxisPosition(RenderSliver child) {
    assert(child == this.child);
    return calculatePaintOffset(constraints, from: 0.0, to: 0.0);
  }

  @override
  double childCrossAxisPosition(RenderSliver child) {
    return 0.0;
  }

  @override
  double? childScrollOffset(RenderObject child) {
    assert(child.parent == this);
    return 0.0;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child == this.child);
    final SliverPhysicalParentData childParentData =
        child.parentData! as SliverPhysicalParentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(child != null && child!.geometry!.visible,
        'Check child and visibility geometry in extended class');

    final SliverPhysicalParentData childParentData =
        child!.parentData! as SliverPhysicalParentData;

    assert(childParentData.paintOffset == Offset.zero, 'Not zero');
    context.paintChild(child!, offset + childParentData.paintOffset);
  }

  void _updateClip(Offset offset) {
    final clipSize = constraintsToSize;
    offset = Offset.zero;
    if (_clip == null || _lastClipSize != clipSize) {
      _clip = _clipper?.getClip(clipSize) ?? _defaultClip(offset);
      _lastClipSize = clipSize;
    }
  }

  Size get constraintsToSize {
    if (child == null) {
      return Size.zero;
    }

    final mainLength = math.max(0.0,
        math.min(geometry!.layoutExtent, constraints.viewportMainAxisExtent));

    final crossLength = constraints.crossAxisExtent;

    return switch (constraints.axis) {
      Axis.vertical => Size(crossLength, mainLength),
      Axis.horizontal => Size(mainLength, crossLength),
    };
  }

  @override
  Rect? describeApproximatePaintClip(RenderObject child) {
    final size = constraintsToSize;

    switch (clipBehavior) {
      case Clip.none:
        return null;
      case Clip.hardEdge:
      case Clip.antiAlias:
      case Clip.antiAliasWithSaveLayer:
        return _clipper?.getApproximateClipRect(size) ?? Offset.zero & size;
    }
  }

  @override
  void debugPaint(PaintingContext context, Offset offset) {
    // super.debugPaint(context, offset);
    // assert(() {
    //   if (debugPaintSizeEnabled) {
    //     final Size parentSize = getAbsoluteSize();
    //     final Rect outerRect = offset & parentSize;
    //     Rect? innerRect;
    //     if (child != null) {
    //       final Size childSize = child!.getAbsoluteSize();
    //       final SliverPhysicalParentData childParentData = child!.parentData! as SliverPhysicalParentData;
    //       innerRect = (offset + childParentData.paintOffset) & childSize;
    //       assert(innerRect.top >= outerRect.top);
    //       assert(innerRect.left >= outerRect.left);
    //       assert(innerRect.right <= outerRect.right);
    //       assert(innerRect.bottom <= outerRect.bottom);
    //     }
    //     debugPaintPadding(context.canvas, outerRect, innerRect);
    //   }
    //   return true;
    // }());
  }
}

// abstract class _RenderCustomClip<T> extends RenderSliver
//     with RenderObjectWithChildMixin<RenderSliver> {

//   _RenderCustomClip({
//     RenderBox? child,
//     CustomClipper<T>? clipper,
//     Clip clipBehavior = Clip.antiAlias,
//   }) : _clipper = clipper,
//        _clipBehavior = clipBehavior,
//        super(child);

//   /// If non-null, determines which clip to use on the child.
//   CustomClipper<T>? get clipper => _clipper;
//   CustomClipper<T>? _clipper;
//   set clipper(CustomClipper<T>? newClipper) {
//     if (_clipper == newClipper) {
//       return;
//     }
//     final CustomClipper<T>? oldClipper = _clipper;
//     _clipper = newClipper;
//     assert(newClipper != null || oldClipper != null);
//     if (newClipper == null || oldClipper == null ||
//         newClipper.runtimeType != oldClipper.runtimeType ||
//         newClipper.shouldReclip(oldClipper)) {
//       _markNeedsClip();
//     }
//     if (attached) {
//       oldClipper?.removeListener(_markNeedsClip);
//       newClipper?.addListener(_markNeedsClip);
//     }
//   }

//   @override
//   void attach(PipelineOwner owner) {
//     super.attach(owner);
//     _clipper?.addListener(_markNeedsClip);
//   }

//   @override
//   void detach() {
//     _clipper?.removeListener(_markNeedsClip);
//     super.detach();
//   }

//   void _markNeedsClip() {
//     _clip = null;
//     markNeedsPaint();
//     markNeedsSemanticsUpdate();
//   }

//   T get _defaultClip;
//   T? _clip;

//   Clip get clipBehavior => _clipBehavior;
//   set clipBehavior(Clip value) {
//     if (value != _clipBehavior) {
//       _clipBehavior = value;
//       markNeedsPaint();
//     }
//   }
//   Clip _clipBehavior;

//   @override
//   void performLayout() {
//     final Size? oldSize = hasSize ? size : null;
//     super.performLayout();
//     if (oldSize != size) {
//       _clip = null;
//     }
//   }

//   void _updateClip() {
//     _clip ??= _clipper?.getClip(size) ?? _defaultClip;
//   }

//   @override
//   Rect? describeApproximatePaintClip(RenderObject child) {
//     switch (clipBehavior) {
//       case Clip.none:
//         return null;
//       case Clip.hardEdge:
//       case Clip.antiAlias:
//       case Clip.antiAliasWithSaveLayer:
//         return _clipper?.getApproximateClipRect(size) ?? Offset.zero & size;
//     }
//   }

//   Paint? _debugPaint;
//   TextPainter? _debugText;
//   @override
//   void debugPaintSize(PaintingContext context, Offset offset) {
//     assert(() {
//       _debugPaint ??= Paint()
//         ..shader = ui.Gradient.linear(
//           Offset.zero,
//           const Offset(10.0, 10.0),
//           <Color>[const Color(0x00000000), const Color(0xFFFF00FF), const Color(0xFFFF00FF), const Color(0x00000000)],
//           <double>[0.25, 0.25, 0.75, 0.75],
//           TileMode.repeated,
//         )
//         ..strokeWidth = 2.0
//         ..style = PaintingStyle.stroke;
//       _debugText ??= TextPainter(
//         text: const TextSpan(
//           text: '✂',
//           style: TextStyle(
//             color: Color(0xFFFF00FF),
//               fontSize: 14.0,
//             ),
//           ),
//           textDirection: TextDirection.rtl, // doesn't matter, it's one character
//         )
//         ..layout();
//       return true;
//     }());
//   }

//   @override
//   void dispose() {
//     _debugText?.dispose();
//     _debugText = null;
//     super.dispose();
//   }
// }

// abstract class SliverLayerCustomClipper<T> extends Listenable {
//   /// Creates a custom clipper.
//   ///
//   /// The clipper will update its clip whenever [reclip] notifies its listeners.
//   const SliverLayerCustomClipper({Listenable? reclip}) : _reclip = reclip;

//   final Listenable? _reclip;

//   /// Register a closure to be notified when it is time to reclip.
//   ///
//   /// The [CustomClipper] implementation merely forwards to the same method on
//   /// the [Listenable] provided to the constructor in the `reclip` argument, if
//   /// it was not null.
//   @override
//   void addListener(VoidCallback listener) => _reclip?.addListener(listener);

//   /// Remove a previously registered closure from the list of closures that the
//   /// object notifies when it is time to reclip.
//   ///
//   /// The [CustomClipper] implementation merely forwards to the same method on
//   /// the [Listenable] provided to the constructor in the `reclip` argument, if
//   /// it was not null.
//   @override
//   void removeListener(VoidCallback listener) =>
//       _reclip?.removeListener(listener);

//   /// Returns a description of the clip given that the render object being
//   /// clipped is of the given size.
//   T getClip(Offset offset, Size size);

//   /// Returns an approximation of the clip returned by [getClip], as
//   /// an axis-aligned Rect. This is used by the semantics layer to
//   /// determine whether widgets should be excluded.
//   ///
//   /// By default, this returns a rectangle that is the same size as
//   /// the RenderObject. If getClip returns a shape that is roughly the
//   /// same size as the RenderObject (e.g. it's a rounded rectangle
//   /// with very small arcs in the corners), then this may be adequate.
//   Rect getApproximateClipRect(Offset offset, Size size) => offset & size;

//   /// Called whenever a new instance of the custom clipper delegate class is
//   /// provided to the clip object, or any time that a new clip object is created
//   /// with a new instance of the custom clipper delegate class (which amounts to
//   /// the same thing, because the latter is implemented in terms of the former).
//   ///
//   /// If the new instance represents different information than the old
//   /// instance, then the method should return true, otherwise it should return
//   /// false.
//   ///
//   /// If the method returns false, then the [getClip] call might be optimized
//   /// away.
//   ///
//   /// It's possible that the [getClip] method will get called even if
//   /// [shouldReclip] returns false or if the [shouldReclip] method is never
//   /// called at all (e.g. if the box changes size).
//   bool shouldReclip(covariant SliverLayerCustomClipper<T> oldClipper);

//   @override
//   String toString() => objectRuntimeType(this, 'CustomClipper');
// }
