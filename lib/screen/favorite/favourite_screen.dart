import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik/provider/favorite_provider.dart';
import 'package:satria_optik/screen/product/product_detail/product_detail_screen.dart';

import '../../model/glass_frame.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favProv, child) {
        if (favProv.state == ConnectionState.active) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
                color: Colors.white, size: 25),
          );
        }
        return EasyRefresh(
          onRefresh: () {
            Provider.of<FavoriteProvider>(context, listen: false)
                .getFavProducts();
          },
          refreshOnStart: favProv.favFrames.isEmpty ? true : false,
          child: ListView.builder(
            itemCount:
                favProv.favFramesId.isEmpty ? 1 : favProv.favFramesId.length,
            itemBuilder: (context, index) {
              if (favProv.favFramesId.isEmpty) {
                return const Center(
                  child: Text(
                      "You don't have any favorite. Try looking some glass"),
                );
              }
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ProductDetailPage.routeName,
                    arguments: favProv.favFrames[index],
                  );
                },
                child: _FavouriteCard(
                  products: favProv.favFrames,
                  index: index,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _FavouriteCard extends StatelessWidget {
  const _FavouriteCard({
    Key? key,
    required this.products,
    required this.index,
  }) : super(key: key);

  final List<GlassFrame> products;
  final int index;

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
                  products[index].imageUrl![0],
                  width: 75,
                  fit: BoxFit.cover,
                )),
            title: Text(products[index].name!),
            subtitle: Text(
              '${products[index].price}',
              style: const TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
            ),
            trailing: Consumer<FavoriteProvider>(
              builder: (context, value, child) => IconButton(
                onPressed: () async {
                  try {
                    await value.updateFavorite(products[index]);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Removed from favorites'),
                        ),
                      );
                      return;
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$e'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete_forever_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
