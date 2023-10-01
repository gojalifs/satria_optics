import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik/model/cart.dart';

import '../../../provider/product_detail_provider.dart';

class EyeCondition extends StatefulWidget {
  final bool nearsightedValue;
  final MinusData? minusData;
  final void Function(double?)? onChangedLeft;
  final void Function(double?)? onChangedRight;
  final void Function(double?)? onChangedLeftP;
  final void Function(double?)? onChangedRightP;

  const EyeCondition({
    Key? key,
    required this.nearsightedValue,
    this.minusData,
    this.onChangedLeft,
    this.onChangedRight,
    this.onChangedLeftP,
    this.onChangedRightP,
  }) : super(key: key);

  @override
  State<EyeCondition> createState() => _EyeConditionState();
}

class _EyeConditionState extends State<EyeCondition> {
  int quantity = 1;
  String filePath = '';
  Map<String, dynamic> eyeCondition = {};
  List<double> eyes = List.generate(50, (index) => 0.25 * index);

  @override
  void initState() {
    for (var eye in eyes) {
      eyeCondition['$eye'] = 50000 * eye;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(''),
                Text('Minus'),
              ],
            )),
            Expanded(
              child: Column(
                children: [
                  const Text('Left Eye'),
                  DropdownButtonFormField(
                    value: widget.minusData?.leftEyeMinus != null &&
                            widget.minusData!.leftEyeMinus!.isNotEmpty
                        ? double.parse(widget.minusData!.leftEyeMinus!)
                        : null,
                    validator: (value) {
                      return value == null ? 'field required' : null;
                    },
                    items: eyes
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text('$e'),
                          ),
                        )
                        .toList(),
                    onChanged: widget.onChangedLeft,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  const Text('Right Eye'),
                  DropdownButtonFormField(
                    value: widget.minusData?.rightEyeMinus != null &&
                            widget.minusData!.rightEyeMinus!.isNotEmpty
                        ? double.parse(widget.minusData!.rightEyeMinus!)
                        : null,
                    validator: (value) {
                      return value == null ? 'field required' : null;
                    },
                    items: eyes
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text('$e'),
                          ),
                        )
                        .toList(),
                    onChanged: widget.onChangedRight,
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message: 'Please input only increment of 0.25',
              onTriggered: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                '''This is the example of the lens size.\n'''
                                '''You need to input the sphere value for the '''
                                '''lens size. Please input only OD size '''
                                '''for right eye.'''),
                            Image.asset('assets/images/resep.png'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.help_outline_rounded),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(''),
                Text('Plus'),
              ],
            )),
            Expanded(
              child: Column(
                children: [
                  const Text('Left Eye'),
                  DropdownButtonFormField(
                    value: widget.minusData?.leftEyePlus != null &&
                            widget.minusData!.leftEyePlus!.isNotEmpty
                        ? double.parse(widget.minusData!.leftEyePlus!)
                        : null,
                    validator: (value) {
                      return value == null ? 'field required' : null;
                    },
                    items: eyes
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text('$e'),
                          ),
                        )
                        .toList(),
                    onChanged: widget.onChangedLeftP,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  const Text('Right Eye'),
                  DropdownButtonFormField(
                    value: widget.minusData?.rightEyePlus != null &&
                            widget.minusData!.rightEyePlus!.isNotEmpty
                        ? double.parse(widget.minusData!.rightEyePlus!)
                        : null,
                    validator: (value) {
                      return value == null ? 'field required' : null;
                    },
                    items: eyes
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text('$e'),
                          ),
                        )
                        .toList(),
                    onChanged: widget.onChangedRightP,
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message: 'Please input only increment of 0.25',
              onTriggered: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                '''This is the example of the lens size.\n'''
                                '''You need to input the sphere value for the '''
                                '''lens size. Please input only OS size '''
                                '''for left eye.'''),
                            Image.asset('assets/images/resep.png'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.help_outline_rounded),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'For other detail such as farsighted or cylinder, please upload the recipe from doctor or check up result',
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(child: Text('Tap icon to upload')),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: () async {
                        filePath = await Provider.of<FrameDetailProvider>(
                                context,
                                listen: false)
                            .getPictCamera();
                        setState(() {});
                      },
                      icon: const Icon(Icons.camera_alt_rounded),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () async {
                        filePath = await Provider.of<FrameDetailProvider>(
                                context,
                                listen: false)
                            .getPictGallery();
                        setState(() {});
                      },
                      icon: const Icon(Icons.image_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        filePath.isEmpty
            ? const SizedBox()
            : Row(
                children: [
                  const Expanded(
                    child: Text('File Picked'),
                  ),
                  filePath.isEmpty
                      ? widget.minusData?.recipePath != null &&
                              widget.minusData!.recipePath!.isNotEmpty
                          ? Image.network(
                              widget.minusData!.recipePath!,
                              width: 100,
                              height: 100,
                            )
                          : const SizedBox()
                      : Consumer<FrameDetailProvider>(
                          builder: (context, value, child) {
                          return Image.file(
                            File(value.image!.path),
                            width: 100,
                            height: 100,
                          );
                        }),
                ],
              ),
      ],
    );
  }
}
