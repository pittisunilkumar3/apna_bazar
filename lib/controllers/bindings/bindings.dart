import '../bottomNav_controller.dart';
import 'controller_index.dart';
import '../product_enquiry_conv_controller.dart';

class InitBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(ProfileController());
    Get.put(FrontendListingController());
    Get.put(WishlistController());
    Get.put(VerificationController(), permanent: true);

    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<TransactionController>(() => TransactionController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<SupportTicketController>(() => SupportTicketController(),
        fenix: true);
    Get.lazyPut<NotificationSettingsController>(
        () => NotificationSettingsController(),
        fenix: true);
    Get.lazyPut<AnalyticController>(() => AnalyticController(), fenix: true);
    Get.lazyPut<AnalyticDetailsController>(() => AnalyticDetailsController(),
        fenix: true);
    Get.lazyPut<PackageController>(() => PackageController(), fenix: true);
    Get.lazyPut<PaymentHistoryController>(() => PaymentHistoryController(),
        fenix: true);
    Get.lazyPut<ManageListingController>(() => ManageListingController(),
        fenix: true);
    Get.lazyPut<MyListingController>(() => MyListingController(), fenix: true);
    Get.lazyPut<PushNotificationController>(() => PushNotificationController(),
        fenix: true);
    Get.lazyPut<ProductEnquiryController>(() => ProductEnquiryController(),
        fenix: true);
    Get.lazyPut<ProductEnquiryConvController>(
        () => ProductEnquiryConvController(),
        fenix: true);
    Get.lazyPut<ClaimBusinessController>(() => ClaimBusinessController(),
        fenix: true);
    Get.lazyPut<ClaimBusinessInboxController>(
        () => ClaimBusinessInboxController(),
        fenix: true);
    Get.lazyPut<ListingReviewController>(() => ListingReviewController(),
        fenix: true);
    Get.lazyPut<DynamicFormController>(() => DynamicFormController(),
        fenix: true);
    Get.lazyPut<DynamicFormController>(() => DynamicFormController(),
        fenix: true);
    Get.lazyPut<PricingController>(() => PricingController(),
        fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(),
        fenix: true);
  }
}
