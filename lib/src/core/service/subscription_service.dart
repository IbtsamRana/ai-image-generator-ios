import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:imagecreator/src/utils/app_constants.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../../main.dart';
import '../../ui/screens/main_screen/main_screen.dart';
import '../model/purchase_model/purchase_model.dart';
import '../navigation/navigation.dart';
import 'user_service.dart';

class InAppModel {
  ProductDetails? selectProduct;
  bool available;
  List<ProductDetails> productDetails;
  InAppModel(
      {this.selectProduct,
      this.available = false,
      this.productDetails = const []});
}

final String monthly = Platform.isMacOS
    ? "com.friends.image.artgenerator.monthly"
    : "com.friends.image.art.generator.monthly";
final String yearly = Platform.isMacOS
    ? "com.friends.image.artgenerator.yearly"
    : "com.friends.image.art.generator.yearly";

class SubscriptionsController extends ValueNotifier<InAppModel> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final String productIDios = '';
  bool loading = false;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  BuildContext get context => NavigationService.navigationKey.currentContext!;
  SubscriptionsController(super.value) {
    onInit();
  }

  // ignore: invalid_use_of_protected_member

  void onInit() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    //     .queryProductDetails(
    //   Set<String>.from(
    //     {_productID},
    //   ),
    // )
    //     .then((value) {
    //   for (var element in value.productDetails) {
    //     print(element.price);
    //   }
    // });
    if (Platform.isAndroid) {
      getOldSubscription();
    }

    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      print("Received purchase update...${purchaseDetailsList.first.status.name}");
      if (purchaseDetailsList.isEmpty) {
        if (loading) {
          loading = false;
          NavigationService.goBack();
        }
      }
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      print("Purchase stream error: $error");
      _subscription?.cancel();
    });

    _initialize();
    notifyListeners();
  }

  getOldSubscription() async {
    final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    final QueryPurchaseDetailsResponse oldpurchases =
        await androidAddition.queryPastPurchases();
    if (oldpurchases.error == null) {
      final oldPurcaseList = oldpurchases.pastPurchases
          .where((element) =>
              element.productID == monthly || element.productID == yearly)
          .where((element) => element.status == PurchaseStatus.purchased);

      if (oldPurcaseList.isNotEmpty) {
        final expiredate = storageService.get(userKey);
        final PurchaseDetails data = oldPurcaseList.first;
        if (expiredate == null) {
          final PurchaseModel model = PurchaseModel(
              productId: data.productID, transactionDate: data.transactionDate);
          user.setUserData = model;
        }
      } else if (user.premium && oldPurcaseList.isEmpty) {
        user.setUserData = const PurchaseModel();
      }
      notifyListeners();
    }
  }

  void setProduct(ProductDetails pr) {
    value.selectProduct = pr;
    notifyListeners();
  }

  void addPurchases(List<PurchaseDetails> newpurchase) {}

  @override
  void dispose() {
    _subscription?.cancel();
    // TODO: implement onClose
    super.dispose();
  }

  void _initialize() async {
    updateAvailable(await _inAppPurchase.isAvailable());

    updateProducts(await _getProducts(
      productIds: Set<String>.from(
        {monthly, yearly},
      ),
    ));
  }

  void updateAvailable(bool boolvalue) {
    value.available = boolvalue;

    notifyListeners();
  }

  void updateProducts(List<ProductDetails> newproduct) {
    print("New product:: ${newproduct.asMap()}");
    value.productDetails = newproduct;
    value.productDetails.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    setProduct(value.productDetails.last);
    notifyListeners();
  }

  // void oldPurchases() async {
  //   final dtaa = await _inAppPurchase;
  //   setState(() {
  //     _purchases = dtaa.productDetails;
  //   });
  // }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    print("Processing purchase update...");
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print("Processing purchase: ${purchaseDetails.productID} with status: ${purchaseDetails.status}");

      if (purchaseDetails.pendingCompletePurchase) {
        print("Purchase:: pending complete ");
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          print("Purchase is pending for: ${purchaseDetails.productID}");
          // Handle pending state if needed
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          print("Purchase successful: ${purchaseDetails.productID}");
          user.setUserData = PurchaseModel(
              productId: purchaseDetails.productID,
              transactionDate: purchaseDetails.transactionDate);

          num imageGeneratorChances = storageService.get(AppConstants.imageGenerator) ?? 0;
          num imageBGRemoverChances = storageService.get(AppConstants.backgroundremover) ?? 0;
          if(purchaseDetails.productID == monthly){
            storageService.set(AppConstants.imageGenerator, imageGeneratorChances + AppConstants.monthlyImageGenerators);
            storageService.set(AppConstants.backgroundremover, imageBGRemoverChances + AppConstants.monthlyBGRemover);
          } else if(purchaseDetails.productID == yearly) {
            storageService.set(AppConstants.imageGenerator, imageGeneratorChances + AppConstants.yearlyImageGenerators);
            storageService.set(AppConstants.backgroundremover, imageBGRemoverChances + AppConstants.yearlyBGRemover);
          }
          print("Purchase:: 2 ${imageGeneratorChances}--${imageBGRemoverChances}");

          if (loading) {
            loading = false;
            NavigationService.goBack();
            print("Purchase:: 3 ");
          }
          print("Purchase:: 4 ");
          NavigationService.replaceScreen(const MainScreen());
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("You are premium now")));
          break;
        case PurchaseStatus.canceled:
          print("Purchase canceled: ${purchaseDetails.productID}");
          if (loading) {
            loading = false;
            NavigationService.goBack();
          }
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Purchase was canceled")));
          break;
        case PurchaseStatus.error:
          print("Purchase error: ${purchaseDetails.error}");
          if (loading) {
            loading = false;
            NavigationService.goBack();
          }
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error Occur while purchasing")));
          break;
        default:
          print("Unhandled purchase status: ${purchaseDetails.status}");
          if (loading) {
            loading = false;
            NavigationService.goBack();
          }
          break;
      }

    });
  }




  Future<List<ProductDetails>> _getProducts(
      {required Set<String> productIds}) async {
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);

    return response.productDetails;
  }

  // ListTile _buildProduct({required ProductDetails product}) {
  //   return ListTile(
  //     leading: Icon(Icons.attach_money),
  //     title: Text('${product.title} - ${product.price}'),
  //     subtitle: Text(product.description),
  //     trailing: ElevatedButton(
  //       onPressed: () {
  //         _subscribe(product: product);
  //       },
  //       child: Text(
  //         'Subscribe',
  //       ),
  //     ),
  //   );
  // }

  // ListTile _buildPurchase({required PurchaseDetails purchase}) {
  //   if (purchase.error != null) {
  //     return ListTile(
  //       title: Text('${purchase.error}'),
  //       subtitle: Text(purchase.status.toString()),
  //     );
  //   }

  //   String? transactionDate;
  //   if (purchase.status == PurchaseStatus.purchased) {
  //     DateTime date = DateTime.fromMillisecondsSinceEpoch(
  //       int.parse(purchase.transactionDate!),
  //     );
  //     transactionDate = date.toString();
  //   }

  //   return ListTile(
  //     title: Text('${purchase.productID} ${transactionDate ?? ''}'),
  //     subtitle: Text(purchase.status.toString()),
  //   );
  // }

  void subscribe({required ProductDetails product}) async {
    try {
      loading = true;
      onLoading(context);
      print("subscribe:: product:: ${product.id}");
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    } catch (e) {
      print("subscribe:: Error:: ${product.id}");
      if (loading) {
        loading = false;
        NavigationService.goBack();
      }

    }
  }

  void restoreSubscription() async {
    try {
      loading = true;
      onLoading(context);

      await _inAppPurchase.restorePurchases();
    } catch (e) {
      if (loading) {
        loading = false;
        NavigationService.goBack();
      }
    }
  }
}

void onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const Center(child: CircularProgressIndicator.adaptive()));
    },
  );
}
