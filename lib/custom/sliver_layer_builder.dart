// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright 2023 Joan Schipper. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:custom_sliver/custom/sliver_layer.dart';

import '../layers/sliver_layer_constraints.dart';

class SliverLayerPositionObject {
  final double scrollOffset;
  final double scrollExtent;
  final double layoutExtent;

  SliverLayerPositionObject({
    required this.scrollOffset,
    required this.scrollExtent,
    required this.layoutExtent,
  });

  @override
  bool operator ==(covariant SliverLayerPositionObject other) {
    if (identical(this, other)) return true;

    return other.scrollOffset == scrollOffset &&
        other.scrollExtent == scrollExtent &&
        other.layoutExtent == layoutExtent;
  }

  @override
  int get hashCode =>
      scrollOffset.hashCode ^ scrollExtent.hashCode ^ layoutExtent.hashCode;
}

class SliverLayerAnimationObject {
  SliverLayerAnimationObject(
      {required double scrollOffset,
      required double layoutExtent,
      required double top,
      required double bottom,
      required double animationSpace})
      : animationValue = animationValueByPosition(
            scrollOffset: scrollOffset,
            layoutExtent: layoutExtent,
            top: top,
            bottom: bottom,
            animationSpace: animationSpace);

  final double animationValue;

  static double animationValueByPosition(
      {required double scrollOffset,
      required double layoutExtent,
      required double top,
      required double bottom,
      required double animationSpace}) {
    final double t = clampDouble(
        (layoutExtent + scrollOffset - top) / animationSpace, 0.0, 1.0);

    final double b =
        clampDouble((layoutExtent - bottom) / animationSpace, 0.0, 1.0);

    return t * b;
  }

  @override
  bool operator ==(covariant SliverLayerAnimationObject other) {
    if (identical(this, other)) return true;

    return other.animationValue == animationValue;
  }

  @override
  int get hashCode => animationValue.hashCode;
}

abstract class SliverLayerDelegate<T> {
  T buildObject(double scrollOffset, double scrollExtent, double layoutExtent);

  Widget? build(BuildContext context, T object);

  bool shouldRebuild(covariant SliverLayerDelegate oldDelegate) => true;
}

mixin _SliverLayerRenderForWidgetsMixin<T> on RenderSliverLayer<T> {
  _SliverFrameElement? _element;

  // AnimationController? get _controller => _element!.widget.controller;

  @override
  void updateChild(
    T object,
  ) {
    assert(_element != null);
    _element!._build(object);
  }

  @override
  T buildObject(double scrollOffset, double scrollExtent, double layoutExtent) {
    assert(_element != null);
    return _element!._buildObject(scrollOffset, scrollExtent, layoutExtent);
  }

  @protected
  void triggerRebuild() {
    markNeedsLayout();
  }
}

class _SliverFrameElement<T> extends RenderObjectElement {
  _SliverFrameElement(SliverLayerBuilder widget) : super(widget);

  @override
  SliverLayerBuilder get widget => super.widget as SliverLayerBuilder;

  @override
  _SliverLayerRenderForWidgetsMixin get renderObject =>
      super.renderObject as _SliverLayerRenderForWidgetsMixin;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject._element = this;
  }

  @override
  void unmount() {
    renderObject._element = null;
    super.unmount();
  }

  @override
  void update(SliverLayerBuilder newWidget) {
    final SliverLayerBuilder oldWidget = widget;
    super.update(newWidget);

    final SliverLayerDelegate newDelegate = newWidget.delegate;
    final SliverLayerDelegate oldDelegate = oldWidget.delegate;

    if (newDelegate != oldDelegate &&
        (newDelegate.runtimeType != oldDelegate.runtimeType ||
            newDelegate.shouldRebuild(oldDelegate))) {
      renderObject.triggerRebuild();
    }
  }

  @override
  void performRebuild() {
    super.performRebuild();
    renderObject.triggerRebuild();
  }

  Element? child;

  T _buildObject(
          double scrollOffset, double scrollExtent, double viewPortExtent) =>
      widget.delegate.buildObject(scrollOffset, scrollExtent, viewPortExtent);

  void _build(T? object) {
    owner!.buildScope(this, () {
      child = updateChild(child, widget.delegate.build(this, object), null);
    });
  }

  @override
  void forgetChild(Element child) {
    assert(child == this.child);
    this.child = null;
    super.forgetChild(child);
  }

  @override
  void insertRenderObjectChild(covariant RenderBox child, Object? slot) {
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
  }

  @override
  void moveRenderObjectChild(
      covariant RenderObject child, Object? oldSlot, Object? newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(covariant RenderObject child, Object? slot) {
    renderObject.child = null;
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (child != null) visitor(child!);
  }
}

class SliverLayerBuilder<T> extends RenderObjectWidget {
  /// Creates a sliver that contains a single box widget.
  const SliverLayerBuilder({
    super.key,
    required this.delegate,
  });

  final SliverLayerDelegate delegate;

  @override
  RenderObjectElement createElement() {
    return _SliverFrameElement(this);
  }

  @override
  RenderSliverLayerBuilder<T> createRenderObject(BuildContext context) =>
      RenderSliverLayerBuilder<T>();
}

class RenderSliverLayerBuilder<T> extends RenderSliverLayer
    with _SliverLayerRenderForWidgetsMixin {
  bool _needsUpdateChild = true;
  // double _lastScrollOffset = 0.0;
  // double _lastOffsetExtent = 0.0;
  // double _lastViewPortExtent = 0.0;
  T? object;

  @override
  void markNeedsLayout() {
    // This is automatically called whenever the child's intrinsic dimensions
    // change, at which point we should remeasure them during the next layout.
    _needsUpdateChild = true;
    super.markNeedsLayout();
  }

  @override
  void layoutChild(
    SliverLayerConstraints constraints,
  ) {
    double scrollOffset = constraints.scrollOffset;
    double offsetExtent = constraints.scrollExtent;
    double viewPortExtent = constraints.layoutExtent;
    final oldObject = object;

    object = buildObject(scrollOffset, offsetExtent, viewPortExtent);

    if (_needsUpdateChild || object != oldObject
        // (_lastScrollOffset != scrollOffset ||
        //     _lastOffsetExtent != offsetExtent ||
        //     _lastViewPortExtent != viewPortExtent)
        ) {
      invokeLayoutCallback<SliverLayerConstraints>(
          (SliverLayerConstraints constraints) {
        assert(constraints == this.constraints);
        updateChild(object);
      });
      // _lastScrollOffset = scrollOffset;
      // _lastOffsetExtent = offsetExtent;
      // _lastViewPortExtent = viewPortExtent;
      _needsUpdateChild = false;
    }

    super.layoutChild(constraints);
  }
}
