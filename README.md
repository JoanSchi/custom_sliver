
# Custom Sliver

The Custom Sliver package contains following slivers:
- SliverLayerBox, to create layers around the sliver.
    - SliverLayer, SliverLayerbuilder, SliverLayerOutside
- SliverClipRRect
- SliverMaintainPadding
- SliverPaddingConstrainAlign




## SliverLayers with SliverMaintainPadding and SliverClipRRect

```Dart
class SliverLayerBuilderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CustomScrollView(slivers: [
      SliverLayer(
          child: Container(
              decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(40.0),
        ),
        color: Color(0xFFF9F5E7),
      ))),
      SliverLayerBuilder(delegate: ProgressSliverLayerDelegate()),
      SliverMaintainPadding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 52.0, right: 10.0, bottom: 10.0),
          sliver: SliverClipRRect(
              //A default SliverRender like SliverList (Add only one)
              sliver: SliverList(children: children)))
    ]);
  }
}

class ProgressSliverLayerDelegate
    extends SliverLayerDelegate<SliverLayerPositionObject> {
  ProgressSliverLayerDelegate();

  @override
  Widget build(BuildContext context, SliverLayerPositionObject object) {
    // Make your progressIndicator with custompainter.
  }

  @override
  SliverLayerPositionObject buildObject(
          double scrollOffset, double scrollExtent, double layoutExtent) =>
      SliverLayerPositionObject(
        scrollOffset: scrollOffset,
        scrollExtent: scrollExtent,
        layoutExtent: layoutExtent,
      );
}
```

