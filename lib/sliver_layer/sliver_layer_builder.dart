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

import 'package:custom_sliver/sliver_layer/sliver_layer.dart';
import 'package:flutter/widgets.dart';
import 'sliver_layer_constraints.dart';

abstract class SliverLayerDelegate {
  Widget build(BuildContext context, double scrollOffset, double scrollExtent,
      double layoutExtent);

  bool shouldRebuild(covariant SliverLayerDelegate oldDelegate) => true;
}

mixin _SliverLayerRenderForWidgetsMixin on RenderSliverLayer {
  _SliverFrameElement? _element;

  // AnimationController? get _controller => _element!.widget.controller;

  @override
  void updateChild(
      double scrollOffset, double scrollExtent, double viewPortExtent) {
    assert(_element != null);
    _element!._build(scrollOffset, scrollExtent, viewPortExtent);
  }

  @protected
  void triggerRebuild() {
    markNeedsLayout();
  }
}

class _SliverFrameElement extends RenderObjectElement {
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

  void _build(double scrollOffset, double scrollExtent, double viewPortExtent) {
    owner!.buildScope(this, () {
      child = updateChild(
          child,
          widget.delegate
              .build(this, scrollOffset, scrollExtent, viewPortExtent),
          null);
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

class SliverLayerBuilder extends RenderObjectWidget {
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
  RenderSliverLayerBuilder createRenderObject(BuildContext context) =>
      RenderSliverLayerBuilder();
}

class RenderSliverLayerBuilder extends RenderSliverLayer
    with _SliverLayerRenderForWidgetsMixin {
  bool _needsUpdateChild = true;
  double _lastScrollOffset = 0.0;
  double _lastOffsetExtent = 0.0;
  double _lastViewPortExtent = 0.0;

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

    if (_needsUpdateChild ||
        _lastScrollOffset != scrollOffset ||
        _lastOffsetExtent != offsetExtent ||
        _lastViewPortExtent != viewPortExtent) {
      invokeLayoutCallback<SliverLayerConstraints>(
          (SliverLayerConstraints constraints) {
        assert(constraints == this.constraints);
        updateChild(scrollOffset, offsetExtent, viewPortExtent);
      });
      _lastScrollOffset = scrollOffset;
      _lastOffsetExtent = offsetExtent;
      _lastViewPortExtent = viewPortExtent;
      _needsUpdateChild = false;
    }

    super.layoutChild(constraints);
  }
}
