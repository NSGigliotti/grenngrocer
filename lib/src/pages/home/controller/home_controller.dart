import 'package:get/get.dart';
import 'package:grenngrocer/src/models/category_model.dart';
import 'package:grenngrocer/src/models/item_model.dart';
import 'package:grenngrocer/src/pages/home/repository/home_repository.dart';
import 'package:grenngrocer/src/pages/home/result/home_result.dart';
import 'package:grenngrocer/src/services/utils_services.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController {
  final homeRepository = HomeRepository();
  final utilsServices = UtilsServices();

  bool isCategoryLoading = false;
  bool isProductLoading = true;

  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  List<ItemModel> get allProducts => currentCategory?.items ?? [];

  RxString searchTitle = ''.obs;

  bool get isLastPage {
    if (currentCategory!.items.length < itemsPerPage) return true;

    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }

    update();
  }

  @override
  void onInit() {
    super.onInit();

    debounce(searchTitle, (_) => filterByTitle(),
        time: const Duration(milliseconds: 600));

    getAllCategories();
  }

  void selectedCategory(CategoryModel category) {
    currentCategory = category;
    update();

    if (currentCategory!.items.isNotEmpty) return;

    getAllProducts();
  }

  Future<void> getAllCategories() async {
    setLoading(true);
    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();
    setLoading(false);

    homeResult.when(
      success: (data) {
        allCategories.assignAll(data);

        if (allCategories.isEmpty) return;

        selectedCategory(allCategories.first);
      },
      erro: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  void filterByTitle() {
    //*apagar todos so produtos das categorias
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }

    if (searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {
      CategoryModel? c = allCategories.firstWhereOrNull((cat) => cat.id == '');

      if (c == null) {
        //* criar uma categoria com todos
        final allProductsCategory = CategoryModel(
          id: '',
          title: 'todos',
          items: [],
          pagination: 0,
        );

        allCategories.insert(0, allProductsCategory);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }

    currentCategory = allCategories.first;

    update();

    getAllProducts();
  }

  void loadMoreProducts() {
    currentCategory!.pagination++;

    getAllProducts(canLoad: false);
  }

  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }

    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      'itemsPerPage': itemsPerPage
    };

    if (searchTitle.value.isNotEmpty) {
      body['title'] = searchTitle.value;

      if (currentCategory!.id == '') {
        body.remove('categoryId');
      }
    }

    HomeResult<ItemModel> result = await homeRepository.getAllProducts(body);

    setLoading(false, isProduct: true);

    result.when(
      success: (data) {
        currentCategory!.items.addAll(data);
      },
      erro: (message) {
        utilsServices.showToast(message: message, isError: true);
      },
    );
  }
}
