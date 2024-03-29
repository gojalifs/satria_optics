import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/favorite_provider.dart';
import 'package:satria_optik/utils/custom_function.dart';

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
  int imagesLength = 0;
  int variationIndex = -1;
  List<String> frameImages = [];
  List<String> frameColorsName = [];
  List<String> frameColorImages = [];
  GlassFrame frame = GlassFrame();

  @override
  void initState() {
    /// get image length only, not include colors
    if (widget.glassFrame.imageUrl != null &&
        widget.glassFrame.imageUrl!.isNotEmpty) {
      imagesLength = widget.glassFrame.imageUrl!.length;
    } else {
      imagesLength = 0;
    }

    Provider.of<FrameProvider>(context, listen: false)
        .getFrameDetail(widget.glassFrame.id!)
        .then((value) {
      frame = value;
      setState(() {});
    });
    Provider.of<LensProvider>(context, listen: false).getLens();

    frameColorsName =
        widget.glassFrame.colors?.map((e) => e.name ?? '').toList() ?? [];
    frameColorImages =
        widget.glassFrame.colors?.map((e) => e.url ?? '').toList() ?? [];

    frameImages.addAll(widget.glassFrame.imageUrl ?? []);
    frameImages.addAll(frameColorImages);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.glassFrame.name!),
          actions: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              icon: const Icon(Icons.shopping_cart_rounded),
            ),
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
                            var currLength = imagesLength;
                            if (variationIndex == index) {
                              variationIndex = -1;
                              controller.jumpToPage(0);
                            } else {
                              variationIndex = index;
                              controller.jumpToPage(currLength + index);
                            }
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: variationIndex == index
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                          ),
                          child: Text(
                            frameColorsName[index],
                            style: TextStyle(
                              color: variationIndex == index
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.glassFrame.name!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Format.formatToRupiah(widget.glassFrame.price ?? 0),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: const Color.fromRGBO(255, 69, 0, 1)),
                        ),
                      ],
                    ),
                    Consumer<FavoriteProvider>(
                      builder: (context, favProv, child) {
                        return IconButton(
                          iconSize: 30,
                          color: (favProv.favFramesId
                                  .contains(widget.glassFrame.id))
                              ? Colors.red
                              : Colors.white,
                          onPressed: () async {
                            try {
                              ScaffoldMessenger.maybeOf(context)
                                  ?.hideCurrentSnackBar();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return LoadingAnimationWidget
                                      .threeArchedCircle(
                                          color: Colors.white, size: 25);
                                },
                              );

                              bool isAddFavorite = await favProv
                                  .updateFavorite(widget.glassFrame);

                              if (!mounted) {
                                return;
                              }
                              Navigator.of(context).pop();
                              if (isAddFavorite) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to favorites'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Removed from favorites'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$e'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.favorite_rounded),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 5),
                    Text(widget.glassFrame.rating ?? ''),
                  ],
                ),
                const Divider(),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                MarkdownBody(
                  data: '${frame.description}',
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(color: Colors.white70),
                  ),
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
                                      Expanded(
                                        child: Text(
                                          Format.formatToRupiah(e.price),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
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
      ),
    );
  }
}
