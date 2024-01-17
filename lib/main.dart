import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/cubits/product_cubit.dart';
import 'package:flutter_application_1/cubits/product_state.dart';
import 'package:flutter_application_1/product.dart';
import 'package:flutter_application_1/product_controller.dart';

// Product Event
abstract class ProductEvent {}

class FetchProducts extends ProductEvent {}

class UpdateFavorite extends ProductEvent {
  final int productId;
  final bool isFavorite;

  UpdateFavorite(this.productId, this.isFavorite);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ProductController productController = ProductController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ProductBloc(productController)..add(FetchProducts()),
        child: ProductListPage(),
      ),
    );
  }
}

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => context.read<ProductBloc>().add(FetchProducts()),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                var product = state.products[index];
                return ListTile(
                  title: Text(product.title),
                  leading: Image.network(product.imageUrl),
                  trailing: IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      context.read<ProductBloc>().add(
                            UpdateFavorite(product.id, !product.isFavorite),
                          );
                    },
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
