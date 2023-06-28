import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/glass_frame.dart';
import '../../../provider/frames_provider.dart';
import '../../../provider/lens_provider.dart';
import '../../cart/cart_screen.dart';
import 'product_bottom_sheet.dart';

class ProductDetailPage extends StatefulWidget {
  static String routeName = '/detail';
  final GlassFrame glassFrame;

  const ProductDetailPage({
    Key? key,
    required this.glassFrame,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  CarouselController controller = CarouselController();
  int images = 0;
  List<String> frameImages = [];
  List<String> frameColorsName = [];
  List<String> frameColorImages = [];
  GlassFrame frame = GlassFrame();

  @override
  void initState() {
    images = widget.glassFrame.imageUrl!.length;

    Provider.of<FrameProvider>(context, listen: false)
        .getFrameDetail(widget.glassFrame.id!)
        .then((value) {
      frame = value;
      setState(() {});
    });
    Provider.of<LensProvider>(context, listen: false).getLens();

    frameColorsName = widget.glassFrame.colors?.keys.toList() ?? [];
    frameColorImages =
        widget.glassFrame.colors?.values.map((e) => e.toString()).toList() ??
            [];
    frameImages.addAll(widget.glassFrame.imageUrl ?? []);
    frameImages.addAll(frameColorImages);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.glassFrame.name!),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              icon: const Icon(Icons.shopping_cart_rounded)),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
            children: [
              CarouselSlider.builder(
                carouselController: controller,
                itemCount: frameImages.length,
                itemBuilder: (context, index, realIndex) {
                  return Image.network(frameImages[index]);
                },
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Variation',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: frameColorImages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          var currLength = images;

                          controller.jumpToPage(currLength + index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Text(frameColorsName[index]),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Divider(),
              ),
              Text(
                widget.glassFrame.name!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.glassFrame.price}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: const Color.fromRGBO(255, 69, 0, 1)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 5),
                  Text(widget.glassFrame.rating!),
                ],
              ),
              const Divider(),
              Text(
                'Description',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${frame.description}',
                style: const TextStyle(color: Colors.white70),
              ),
              const Divider(
                thickness: 2,
                color: Colors.white70,
              ),
              Text(
                'Lens Type',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Text(
                '''All of eyeglass product in this app is compatible with the lens type below. '''
                '''Just look at the table for the different. '''
                '''If you have any question, feel free chat our customer service''',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white60, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Consumer<LensProvider>(
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(
                                child: Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                            SizedBox(width: 10),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text(
                              'Price',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                        const Divider(),
                        Column(
                          children: value.lens
                              .map(
                                (e) => Row(
                                  children: [
                                    Expanded(child: Text(e.name ?? '')),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        flex: 2,
                                        child: Text(e.description ?? '')),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text('${e.price}')),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ProductDetailBottomSheet(
                frame: widget.glassFrame,
                colorName: frameColorsName,
                page: 'detail',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
