import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/cubits/product_state.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/product.dart';
import 'package:flutter_application_1/product_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductController productController;

  ProductBloc(this.productController) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<UpdateFavorite>(_onUpdateFavorite);
  }

  void _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    try {
      List<Product> products = await productController.getProducts();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      products.forEach((product) {
        product.isFavorite = prefs.getBool('fav_${product.id}') ?? false;
      });
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onUpdateFavorite(
      UpdateFavorite event, Emitter<ProductState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fav_${event.productId}', event.isFavorite);
    if (state is ProductLoaded) {
      List<Product> updatedProducts = (state as ProductLoaded).products;
      int index = updatedProducts.indexWhere((p) => p.id == event.productId);
      if (index != -1) {
        updatedProducts[index].isFavorite = event.isFavorite;
        emit(ProductLoaded(List.from(updatedProducts)));
      }
    }
  }
}