import 'package:get/get.dart';
import '../views/screens/home/dashboard_screen.dart';
import '../views/screens/home/drawer_screen.dart';
import '../views/screens/listing/frontend_listings/author_profile_screen.dart';
import '../views/screens/listing/frontend_listings/dynamic_form_screen.dart';
import '../views/screens/listing/frontend_listings/frontend_listing_demo_screen.dart';
import '../views/screens/listing/frontend_listings/review_list_screen.dart';
import '../views/screens/listing/frontend_listings/listing_categories_screen.dart';
import '../views/screens/pricing/payment_screen.dart';
import '../views/screens/pricing/pricing_screen.dart';
import 'page_index.dart';

class RouteHelper {
  static List<GetPage> routes() => [
        GetPage(
            name: RoutesName.INITIAL,
            page: () => const SplashScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RoutesName.onbordingScreen,
            page: () => const OnbordingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.mainDrawerScreen,
            page: () => MainDrawerScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.bottomNavBar,
            page: () => const BottomNavBar(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.homeScreen,
            page: () => HomeScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.loginScreen,
            page: () => LoginScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.signUpScreen,
            page: () => SignUpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.frontendListingDemoScreen,
            page: () => FrontendListingDemoScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.allListingScreen,
            page: () => AllListingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.authorProfileScreen,
            page: () => AuthorProfileScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myListingScreen,
            page: () => MyListingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.reviewListScreen,
            page: () => ReviewListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.dynamicFormScreen,
            page: () => DynamicFormScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.listingDetailsScreen,
            page: () => ListingDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.productDetailsScreen,
            page: () => ProductDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.profileSettingScreen,
            page: () => ProfileSettingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.editProfileScreen,
            page: () => EditProfileScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.changePasswordScreen,
            page: () => ChangePasswordScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.addListingScreen,
            page: () => AddListingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.wishListScreen,
            page: () => WishListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.transactionScreen,
            page: () => TransactionScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.paymentHistoryScreen,
            page: () => PaymentHistoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myAnalyticsScreen,
            page: () => MyAnalyticsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myAnalyticsDetailsScreen,
            page: () => MyAnalyticsDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myPackageScreen,
            page: () => MyPackageScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.productEnquiryScreen,
            page: () => ProductEnquiryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.productEnquiryInboxScreen,
            page: () => ProductEnquiryInboxScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.createSupportTicketScreen,
            page: () => CreateSupportTicketScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketListScreen,
            page: () => SupportTicketListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketViewScreen,
            page: () => SupportTicketViewScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.twoFaVerificationScreen,
            page: () => TwoFaVerificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.verificationListScreen,
            page: () => VerificationListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.notificationPermissionScreen,
            page: () => NotificationPermissionScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.claimBusinessScreen,
            page: () => ClaimBusinessScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.claimBusinessInboxScreen,
            page: () => ClaimBusinessInboxScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.pricingScreen,
            page: () => PricingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.paymentScreen,
            page: () => PaymentScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.dashboardScreen,
            page: () => DashboardScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.listingCategoryScreen,
            page: () => ListingCategoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.deleteAccountScreen,
            page: () => DeleteAccountScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.notificationScreen,
            page: () => NotificationScreen(),
            transition: Transition.fade),
      ];
}
