class DashboardModel {
  Data? data;

  DashboardModel({this.data});

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
      data: json["data"] == null ? null : Data.fromJson(json["data"]));
}

class Data {
  dynamic totalListing;
  dynamic activeListing;
  dynamic pendingListing;
  dynamic totalViews;
  dynamic totalProduct;
  dynamic totalProductQuires;
  dynamic pendingPackage;
  dynamic activePackage;

  Data({
    this.totalListing,
    this.activeListing,
    this.pendingListing,
    this.totalViews,
    this.totalProduct,
    this.totalProductQuires,
    this.pendingPackage,
    this.activePackage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalListing: json["total_listing"] ?? "0",
        activeListing: json["active_listing"] ?? "0",
        pendingListing: json["pending_listing"] ?? "0",
        totalViews: json["total_views"] ?? "0",
        totalProduct: json["total_product"] ?? "0",
        totalProductQuires: json["total_product_quires"] ?? "0",
        pendingPackage: json["pending_package"] ?? "0",
        activePackage: json["active_package"] ?? "0",
      );
}
