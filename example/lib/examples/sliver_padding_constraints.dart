// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright 2023 Joan Schipper. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:custom_sliver/custom/sliver_clip_rrect.dart';
import 'package:custom_sliver/custom/sliver_padding_constrain_align.dart';

import '/examples/general_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Properties {
  Properties({
    required this.padding,
    required this.ratioCrossSize,
    required this.crossAlign,
  });

  EdgeInsets padding;
  double ratioCrossSize;
  double crossAlign;
}

class SliverPaddingConstraints extends StatefulWidget {
  const SliverPaddingConstraints({
    Key? key,
    required this.axis,
  }) : super(key: key);

  final Axis axis;

  @override
  State<SliverPaddingConstraints> createState() =>
      _SliverPaddingConstraintsState();
}

class _SliverPaddingConstraintsState extends State<SliverPaddingConstraints> {
  Map<Axis, Properties> axisProperties = {
    Axis.vertical: Properties(
        padding: EdgeInsets.zero, ratioCrossSize: 1.0, crossAlign: 0.0),
    Axis.horizontal: Properties(
        padding: EdgeInsets.zero, ratioCrossSize: 1.0, crossAlign: 0.0)
  };
  late TextEditingController tcLeft;
  late TextEditingController tcTop;
  late TextEditingController tcRight;
  late TextEditingController tcBottom;

  Properties get properties => axisProperties[widget.axis]!;

  @override
  void initState() {
    tcLeft = TextEditingController(text: '${properties.padding.left.toInt()}');
    tcTop = TextEditingController(text: '${properties.padding.top.toInt()}');
    tcRight =
        TextEditingController(text: '${properties.padding.right.toInt()}');
    tcBottom =
        TextEditingController(text: '${properties.padding.bottom.toInt()}');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SliverPaddingConstraints oldWidget) {
    if (widget.axis != oldWidget.axis) {
      tcLeft.text = '${properties.padding.left.toInt()}';
      tcTop.text = '${properties.padding.top.toInt()}';
      tcRight.text = '${properties.padding.right.toInt()}';
      tcBottom.text = '${properties.padding.bottom.toInt()}';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    tcLeft.dispose();
    tcTop.dispose();
    tcRight.dispose();
    tcBottom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    final crossSize = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('CrossSize'),
        Expanded(
          child: Slider(
              value: properties.ratioCrossSize,
              min: 0.1,
              max: 1.0,
              onChanged: (double? v) {
                if (v == null) return;
                setState(() {
                  properties.ratioCrossSize = v;
                });
              }),
        ),
      ],
    );

    final crossAlign = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('CrossAlign'),
        Expanded(
          child: Slider(
              value: properties.crossAlign,
              min: -1.0,
              max: 1.0,
              onChanged: (double? v) {
                if (v == null) return;
                setState(() {
                  properties.crossAlign = v;
                });
              }),
        ),
      ],
    );

    final padding = Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        width: 45.0,
        child: TextField(
          decoration: const InputDecoration(label: Text('left')),
          controller: tcLeft,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          onSubmitted: (v) => changePadding('L', v),
        ),
      ),
      const SizedBox(
        width: 8.0,
      ),
      SizedBox(
        width: 45.0,
        child: TextField(
          decoration: const InputDecoration(label: Text('top')),
          controller: tcTop,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          onSubmitted: (v) => changePadding('T', v),
        ),
      ),
      const SizedBox(
        width: 8.0,
      ),
      SizedBox(
        width: 45.0,
        child: TextField(
          decoration: const InputDecoration(label: Text('right')),
          controller: tcRight,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          onSubmitted: (v) => changePadding('R', v),
        ),
      ),
      const SizedBox(
        width: 8.0,
      ),
      SizedBox(
        width: 55.0,
        child: TextField(
          decoration: const InputDecoration(label: Text('bottom')),
          controller: tcBottom,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          onSubmitted: (v) => changePadding('B', v),
        ),
      )
    ]);

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double? edgeWidth;
            double? edgeHeight;
            double? widthContainer;
            double? heightContainer;
            double? aboutHeight;
            double? aboutWidth;
            const paragraphSize = 18.0;

            final theme = Theme.of(context);

            if (widget.axis == Axis.vertical) {
              heightContainer = mediaQuery.size.height / 3.0;
              edgeHeight = 10.0;
              aboutHeight = 350.0;
            } else {
              widthContainer = mediaQuery.size.width / 3.0;
              edgeWidth = 10.0;
              aboutWidth = constraints.biggest.width;
            }

            final aboutChildren = [
              Text(
                  'axis: ${widget.axis == Axis.vertical ? 'vertical' : 'horizontal'}, example next sliver!'),
              Text(
                'Padding, crossSize and crossAlign',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              RichText(
                text: TextSpan(
                  text:
                      'When a ScrollView is used on a large screens, it is not always desired to fully stretch the SliverRender.'
                      ' With SliverPaddingConstrainAlign the padding, maximum crossSize, crossAligned can be set to the SliverRender.'
                      ' CrossAlignment: left: -1.0, middle: 0.0, right: 1.0'
                      '\n',
                  style: TextStyle(
                      color: Colors.brown[900], fontSize: paragraphSize),
                ),
              ),
              Text(
                'Coffee image',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 24,
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      'Author: Pipat Pajongwong.\nhttps://www.vecteezy.com/vector-art/1906625-coffee-elements-icons',
                  style: TextStyle(
                      color: Colors.brown[900], fontSize: paragraphSize),
                ),
              )
            ];

            return CustomScrollView(
              scrollDirection: widget.axis,
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    Container(
                      width: aboutWidth,
                      height: aboutHeight,
                      color: const Color(0xFFF9F5E7),
                      child: widget.axis == Axis.vertical
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: aboutChildren))
                          : ListView(
                              padding: const EdgeInsets.all(8.0),
                              children: [
                                for (Widget w in aboutChildren) Center(child: w)
                              ],
                            ),
                    ),
                    CircularDivider(
                      axis: widget.axis,
                    ),
                  ]),
                ),
                SliverPaddingConstrainAlign(
                  sliver: SliverClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed([
                      Container(
                        height: edgeHeight,
                        width: edgeWidth,
                        color: Colors.orange,
                      ),
                      for (int i = 0; i < 6; i++)
                        Container(
                            height: heightContainer,
                            width: widthContainer,
                            color: i % 2 == 0
                                ? const Color.fromARGB(255, 216, 230, 238)
                                : const Color.fromARGB(255, 234, 238, 241),
                            child: (heightContainer ?? widthContainer ?? 0.0) <
                                    60.0
                                ? null
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Image(
                                            image: AssetImage(
                                                'graphics/coffee_background.png'))),
                                  )),
                      Container(
                        height: edgeHeight,
                        width: edgeWidth,
                        color: Colors.orange,
                      ),
                    ])),
                  ),
                  crossAlign: properties.crossAlign,
                  maxCrossSize: (widget.axis == Axis.vertical
                          ? constraints.biggest.width
                          : constraints.biggest.height) *
                      properties.ratioCrossSize,
                  padding: properties.padding,
                ),
                SliverList(
                    delegate: SliverChildListDelegate.fixed([
                  CircularDivider(axis: widget.axis),
                  Container(
                    width: aboutWidth,
                    height: aboutHeight,
                    color: const Color(0xFFF9F5E7),
                  )
                ]))
              ],
              // This trailing comma makes auto-formatting nicer for build methods.
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
          child: width > 850
              ? Row(
                  children: [
                    Expanded(child: crossSize),
                    Expanded(
                      child: crossAlign,
                    ),
                    padding,
                  ],
                )
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [crossSize, crossAlign, padding],
                ),
        )
      ],
    );
  }

  void changePadding(String side, String? value) {
    if (value == null) return;

    double? left, top, right, bottom;

    final size = double.tryParse(value);

    switch (side) {
      case 'L':
        {
          left = size;
          break;
        }
      case 'T':
        {
          top = size;
          break;
        }
      case 'R':
        {
          right = size;
          break;
        }
      default:
        {
          bottom = size;
        }
    }
    setState(() {
      properties.padding = properties.padding
          .copyWith(left: left, top: top, right: right, bottom: bottom);
    });
  }
}
