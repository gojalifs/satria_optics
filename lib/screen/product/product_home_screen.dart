import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/frames_provider.dart';
import 'package:satria_optik/screen/product/product_list_screen.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  static List<Map<String, dynamic>> genderCategories = [
    {
      'imageUrl':
          'https://media.ray-ban.com/cms/resource/image/656634/portrait_ratio841x897/828/884/5d4c0a93d81b0793534ed3ee391a237b/23C7D35638F98A353B2B278CE41F0BC3/rb-genuinesince-plp-mensun.jpg',
      'title': 'For Male',
    },
    {
      'imageUrl':
          'https://media.karousell.com/media/photos/products/2023/2/14/sunglasses_rayban_round_1960s_1676351097_78d0fa68_progressive.jpg',
      'title': 'For Female',
    },
    {
      'imageUrl':
          'https://images.squarespace-cdn.com/content/v1/62ea7cb3500bd533351b4192/1659534773079-3BCIFGJ7O6Y2XWB5YEEA/Ray+Ban+Kids+3.png',
      'title': 'For Child',
    },
    {
      'imageUrl':
          'https://images.tokopedia.net/img/cache/700/VqbcmM/2020/11/1/c77ed6b9-8e9c-42f6-ad77-5971ecb75765.jpg',
      'title': 'Sunglasses',
    },
  ];

  static List<Map<String, dynamic>> typeCategories = [
    {
      'imageUrl':
          'https://s1.bukalapak.com/img/1459685852/large/Frame_kacamata_FF39_FULL_FRAME_Sport_Aluminum_Paling_Lebar_k.jpg',
      'title': 'Full Frame',
    },
    {
      'imageUrl':
          'https://cdn.shopify.com/s/files/1/1766/7669/products/IMG_8062_2000x.jpg?v=1612208274',
      'title': 'Half Frame',
    },
    {
      'imageUrl':
          'https://images.squarespace-cdn.com/content/v1/62ea7cb3500bd533351b4192/1659534773079-3BCIFGJ7O6Y2XWB5YEEA/Ray+Ban+Kids+3.png',
      'title': 'Rimless',
    },
    {
      'imageUrl':
          'https://images.tokopedia.net/img/cache/700/VqbcmM/2020/11/1/c77ed6b9-8e9c-42f6-ad77-5971ecb75765.jpg',
      'title': 'Semi-Rimless',
    },
    {
      'imageUrl':
          'https://images.tokopedia.net/img/cache/700/VqbcmM/2020/11/1/c77ed6b9-8e9c-42f6-ad77-5971ecb75765.jpg',
      'title': 'Cat Eye',
    },
    {
      'imageUrl':
          'https://images.tokopedia.net/img/cache/700/VqbcmM/2020/11/1/c77ed6b9-8e9c-42f6-ad77-5971ecb75765.jpg',
      'title': 'Wayfarer',
    },
    {
      'imageUrl':
          'https://images.tokopedia.net/img/cache/700/VqbcmM/2020/11/1/c77ed6b9-8e9c-42f6-ad77-5971ecb75765.jpg',
      'title': 'Aviator-Sun Glasses',
    },
    {
      'imageUrl':
          'https://images.tokopedia.net/img/cache/700/VqbcmM/2020/11/1/c77ed6b9-8e9c-42f6-ad77-5971ecb75765.jpg',
      'title': 'Round-Oval',
    },
    {
      'imageUrl':
          'https://images.tokopedia.net/img/cache/700/VqbcmM/2020/11/1/c77ed6b9-8e9c-42f6-ad77-5971ecb75765.jpg',
      'title': 'Oversize',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.network(
          'https://ds393qgzrxwzn.cloudfront.net/cat1/img/images/0/qQg9w5UVNs.jpg',
          height: 250,
        ),
        const Divider(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              ProductListPage.routeName,
              arguments: [
                'All Products',
                Provider.of<FrameProvider>(context, listen: false)
                    .getAllFrames()
              ],
            );
          },
          child: const Text(
            'Please Select The Category Below, or Tap Me To See All of Product',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        GridView.builder(
          itemCount: genderCategories.length,
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(ProductListPage.routeName,

                    /// TODO The arguments need implement list
                    arguments: genderCategories[index]['title']);
              },
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Image.network(
                        genderCategories[index]['imageUrl'],
                      ),
                    ),
                    Expanded(child: Text(genderCategories[index]['title'])),
                  ],
                ),
              ),
            );
          },
        ),
        const Text('Or find by eyeglass type'),
        GridView.builder(
          itemCount: typeCategories.length,
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(ProductListPage.routeName,
                    arguments: typeCategories[index]['title']);
              },
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Image.network(
                        typeCategories[index]['imageUrl'],
                      ),
                    ),
                    Expanded(child: Text(typeCategories[index]['title'])),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
