/// Product models - barrel file for backward compatibility.
///
/// All product-related models are now organized in separate files:
/// - [ProductModel] - Main product model
/// - [PriceListModel], [ProductPriceListModel], [PriceOptionModel] - Pricing
/// - [ManufacturerModel] - Brand/manufacturer
/// - [CategoryModel], [ParentCategory], [CategoryType] - Categories
/// - [DeliveryType], [DeliveryFee] - Delivery options
/// - [Rate] - Product ratings
library;

export 'product/product_model.dart';
export 'product/price_models.dart';
export 'product/manufacturer_model.dart';
export 'product/category_models.dart';
export 'product/delivery_models.dart';
export 'product/rate_model.dart';
