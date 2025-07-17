class AppConstants {
  static const String appName = 'Apna Bazar';
  
  // BASE_URL
  static const String base_url = 'https://storelist.cyberdetox.in';
  // static const String base_url = 'https://listplace.bugfinder.app';
  
  //END_POINTS_URL
  static const String _ = "/api"; // prefix
  static const String registerUrl = '$_/register';
  static const String loginUrl = '$_/login';
  static const String forgotPassUrl = '$_/password-reset/email';
  static const String forgotPassGetCodeUrl = '$_/password-reset/code';
  static const String updatePassUrl = '$_/password-reset';
  static const String languageUrl = '$_/languages';
  static const String profileUrl = '$_/profile';
  static const String profileUpdateUrl = '$_/update-profile';
  static const String profilePassUpdateUrl = '$_/update-password';
  static const String verificationUrl = '$_/get-kyc';
  static const String identityVerificationUrl = '$_/kyc/submit';
  static const String twoFaSecurityUrl = '$_/two-step-security';
  static const String twoFaSecurityEnableUrl = '$_/twoStep-enable';
  static const String twoFaSecurityDisableUrl = '$_/twoStep-disable';
  static const String twoFaVerifyUrl = '$_/twoFA-Verify';
  static const String mailUrl = '$_/mail-verify';
  static const String smsVerifyUrl = '$_/sms-verify';
  static const String resendCodeUrl = '$_/resend-code';

  static const String transactionUrl = '$_/transaction';

  //----support ticket
  static const String supportTicketListUrl = '$_/support-tickets';
  static const String supportTicketCreateUrl = '$_/support-ticket/create';
  static const String supportTicketReplyUrl = '$_/support-ticket/reply';
  static const String supportTicketViewUrl = '$_/support-ticket/view';
  static const String supportTicketCloseUrl = '$_/support-ticket/closed';

  static const String notificationSettingsUrl = "$_/notification-permission";
  static const String notificationPermissionUrl =
      "$_/notification-permission/update";

  static const String analytics = "$_/analytics";
  static const String analyticsDetails = "$_/listing/analytic/details";

  // wishlist
  static const String wishlist = "$_/wish-list";
  static const String addWishlist = "$_/wish-list/add";

  // add listing
  static const String purchasePackage = "$_/purchase-packages";
  static const String listingCategories = "$_/listing-categories";
  static const String countryList = "$_/country-list";
  static const String amenitiesList = "$_/amenities";
  static const String stateList = "$_/state-list";
  static const String cityList = "$_/city-list";
  static const String allCityList = "$_/listing-cities";
  static const String myListings = "$_/listings";
  static const String addListings = "$_/add-listing";
  static const String updateListing = "$_/update-listing";
  static const String editListing = "$_/edit-listing";
  static const String getDynamicFormData = "$_/dynamic-form-data";
  static const String deleteListing = "$_/delete-listing";
  static const String reviews = "$_/reviews";
  static const String packages = "$_/packages";

  // product enquiry
  static const String productEnquiry = "$_/product-enquiries";
  static const String productEnquiryConvList = "$_/product-enquiry/replies";
  static const String productEnquiryReply = "$_/product-enquiry/new-message";
  static const String productEnquiryDelete = "$_/product-enquiry/delete";

  // claim business
  static const String claimBusiness = "$_/claim-business-list";
  static const String claimBusinessConversation =
      "$_/claim-business/conversation";
  static const String claimBusinessConversationReply =
      "$_/claim-business/push-chat/new-message";

  // package
  static const String paymentHistoryList = "$_/payment-history";

  //------frontend
  static const String frontendListingList = "$_/frontend/listings";
  static const String frontendListingListWithoutAuth = "$_/without-auth/frontend/listings";
  static const String frontendListingDetailsList = "$_/frontend/listing-details";
  static const String addReview = "$_/listing-details/add-review";
  static const String claimBusinessSubmit = "$_/claim-business";
  static const String listingMsgSubmit = "$_/send-listing-message";
  static const String querySubmit = "$_/send-product-query";
  static const String msgToAuthor = "$_/send-message-to-listing-author";
  static const String followToAuthor = "$_/author-profile-follow-or-unfollow";
  static const String submitListingFormData = "$_/collect-listing-form-data";
  static const String authorProfile = "$_/listing-author-profile";

  //------pricing
  static const String gateways = "$_/gateways";
  static const String manualPaymentUrl = "$_/addFundConfirm";
  static const String webviewPayment = "$_/payment-webview";
  static const String paymentRequest = "$_/payment-request";
  static const String cardPayment = "$_/card-payment";
  static const String onPaymentDone = "$_/payment-done";
  static const String pricingPlanPayment = "$_/package/payment";

  static const String dashboard = "$_/dashboard";

  static const String deleteAccountUrl = "$_/delete-account";
  static const String pusherConfigUrl = "$_/pusher-config";
}

//----------IMAGE DIRECTORY---------//
String rootImageDir = "assets/images";
String rootIconDir = "assets/icons";
String rootJsonDir = "assets/json";
String rootSvgDir = "assets/svg";



