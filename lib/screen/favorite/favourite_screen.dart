import 'package:flutter/material.dart';

import '../../model/glass_frame.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  static List<GlassFrame> products = [
    GlassFrame(
      imageUrl: [
        "https://assets.glasses.com/is/image/Glasses/805289291015__002.png?impolicy=GL_g-thumbnail-plp"
      ],
      name: 'Prescription Glass',
      price: 250000,
      rating: '4',
      colors: {
        'red': '',
        'white': '',
      },
      description: 'awebewiubewubewu',
    ),
    GlassFrame(
      imageUrl: [
        "https://cdn.shopify.com/s/files/1/0109/5012/products/RORY_CrystalSlate_52_TQ-1600x1200_8abec855-5208-492b-9217-ee89dd983500.jpg?v=1684520565"
      ],
      name: 'Sun Glass',
      price: 350000,
      rating: '4.5',
      colors: {
        'red': '',
        'white': '',
      },
      description: 'awebewiubewubewu',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _FavouriteCard(
          products: products,
          index: index,
        );
      },
    );
  }
}

class _FavouriteCard extends StatefulWidget {
  const _FavouriteCard({
    Key? key,
    required this.products,
    required this.index,
  }) : super(key: key);

  final List<GlassFrame> products;
  final int index;

  @override
  State<_FavouriteCard> createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<_FavouriteCard> {
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.products[widget.index].imageUrl![0],
                  width: 75,
                  fit: BoxFit.cover,
                )),
            title: Text(widget.products[widget.index].name!),
            subtitle: Text(
              '${widget.products[widget.index].price}',
              style: const TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
            ),
            trailing: IconButton(
              onPressed: () {
                isEdit = !isEdit;
                setState(() {});
              },
              icon: const Icon(Icons.edit_rounded),
            ),
          ),
          isEdit
              ? Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Add To cart'),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_shopping_cart_rounded),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Delete'),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete_forever_rounded),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
