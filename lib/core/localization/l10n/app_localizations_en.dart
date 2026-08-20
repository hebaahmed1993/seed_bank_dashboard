// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get platformTitle => 'Gheras Cloud Platform';

  @override
  String get platformSubtitle => 'Centralized Administration Dashboard System';

  @override
  String get login => 'Login';

  @override
  String get loginInstruction =>
      'Enter administrator credentials to access the dashboard';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Access Dashboard';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get homeMenu => 'Home';

  @override
  String get plantsMenu => 'Plants & Seeds';

  @override
  String get usersMenu => 'Users';

  @override
  String get ordersMenu => 'Orders';

  @override
  String get reportsMenu => 'Financial Reports';

  @override
  String get settingsMenu => 'Settings';

  @override
  String get logoutButton => 'Logout';

  @override
  String get welcomeMessage => 'Welcome back, Heba Ahmed 👋';

  @override
  String get overviewTitle => 'System Overview';

  @override
  String get totalSeeds => 'Total Seeds';

  @override
  String get activeOrders => 'Active Orders';

  @override
  String get registeredFarmers => 'Registered Farmers';

  @override
  String get monthlyEarnings => 'Monthly Earnings';

  @override
  String get chartsPlaceholder =>
      'Charts space and latest operations list (Under Development) 📊';

  @override
  String get usersManagementTitle => 'User Management & Permissions';

  @override
  String get usersManagementSubtitle =>
      'Full control over system accounts, employees, and farmers';

  @override
  String get addNewEmployee => 'Add New Employee';

  @override
  String get searchUsersHint => 'Search by username, email, or phone...';

  @override
  String get allRoles => 'All Roles';

  @override
  String get adminRole => 'Admin';

  @override
  String get dataEntryRole => 'Data Entry';

  @override
  String get farmerRole => 'Professional Farmer';

  @override
  String get hobbyistRole => 'Hobbyist / Regular User';

  @override
  String get allStatuses => 'All Statuses';

  @override
  String get activeOnly => 'Active Only';

  @override
  String get blockedOnly => 'Blocked Only';

  @override
  String get noMatchingUsers =>
      'No users match the search and filter criteria.';

  @override
  String get userColumn => 'User';

  @override
  String get phoneColumn => 'Phone Number';

  @override
  String get cityColumn => 'City';

  @override
  String get roleColumn => 'Role';

  @override
  String get statusColumn => 'Status';

  @override
  String get actionsColumn => 'Actions';

  @override
  String get activeStatus => 'Active';

  @override
  String get blockedStatus => 'Blocked';

  @override
  String get backToUsersList => 'Back to Users List';

  @override
  String get createAccountCloud => 'Create New User Account Securely';

  @override
  String get fullNameLabel => 'Full Name *';

  @override
  String get fullNameValidator => 'Please enter full name';

  @override
  String get emailLabel => 'Email Address *';

  @override
  String get emailEmptyValidator => 'Please enter email address';

  @override
  String get emailInvalidValidator => 'Please enter a valid email';

  @override
  String get phoneLabel => 'Phone Number *';

  @override
  String get phoneValidator => 'Please enter phone number';

  @override
  String get cityLabel => 'City *';

  @override
  String get roleLabel => 'Select Role Level (Account Type) *';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveAccountCloud => 'Save Account to Cloud';

  @override
  String get productsManagementSubtitle =>
      'Manage platform offerings including plants, seeds, and equipment';

  @override
  String get addNewProduct => 'Add New Product';

  @override
  String get searchProductsHint =>
      'Search by product commercial or scientific name...';

  @override
  String get allCategories => 'All Categories';

  @override
  String get productImageColumn => 'Image';

  @override
  String get productNameArColumn => 'Name (Ar)';

  @override
  String get productNameEnColumn => 'Name (En)';

  @override
  String get productPriceColumn => 'Price';

  @override
  String get productStockColumn => 'Stock';

  @override
  String get noMatchingProducts => 'No matching products found 📦';

  @override
  String get backToProductsList => 'Back to Products List';

  @override
  String get addProductToPlatform => 'Add New Product to Platform';

  @override
  String get productTitleLabel => 'Product Title / Name *';

  @override
  String get productTitleValidator => 'Please enter product title';

  @override
  String get productDescriptionLabel => 'Detailed Description *';

  @override
  String get productDescriptionValidator => 'Please enter description';

  @override
  String get productPriceLabel => 'Price (LYD) *';

  @override
  String get productPriceValidator => 'Invalid price';

  @override
  String get productStockLabel => 'Stock Quantity *';

  @override
  String get productStockValidator => 'Invalid quantity';

  @override
  String get mainCategoryLabel => 'Main Category *';

  @override
  String get categoryRequiredValidator => 'Please select a category';

  @override
  String get suitableSeasonLabel => 'Suitable Season *';

  @override
  String get germinationRateLabel =>
      'Germination Rate if applicable (e.g., 90%)';

  @override
  String get saveProductCloud => 'Save Product to Cloud';

  @override
  String get ordersManagementTitle => 'Orders Management';

  @override
  String get ordersManagementSubtitle =>
      'Monitor and process incoming farmer orders (last 30 added orders)';

  @override
  String get addNewCancelReason => 'Add New Cancel Reason';

  @override
  String get noOrdersRegistered =>
      'No orders registered in the system currently.';

  @override
  String showingOrders(String start, String end, String total) {
    return 'Showing $start to $end of $total orders';
  }

  @override
  String pageOf(String current, String total) {
    return 'Page $current of $total';
  }

  @override
  String ordersError(String error) {
    return 'An error occurred while fetching orders: $error';
  }

  @override
  String get orderNumberColumn => 'Order Number';

  @override
  String get farmerAndContactColumn => 'Farmer & Contact';

  @override
  String get orderDateTimeColumn => 'Order Date & Time';

  @override
  String get orderValueColumn => 'Order Value';

  @override
  String get orderStatusColumn => 'Order Status';

  @override
  String get detailsColumn => 'Details';

  @override
  String get pendingApproval => 'Pending Approval';

  @override
  String get currency => 'LYD';

  @override
  String orderDetailsTitle(String id) {
    return 'Order Details #$id';
  }

  @override
  String get clientData => 'Client Data';

  @override
  String clientNameLabel(String name) {
    return 'Name: $name';
  }

  @override
  String clientPhoneLabel(String phone) {
    return 'Phone: $phone';
  }

  @override
  String clientUserIdLabel(String id) {
    return 'User ID: $id';
  }

  @override
  String get deliveryAndTimeData => 'Delivery & Time Data';

  @override
  String deliveryAddressLabel(String address) {
    return 'Address: $address';
  }

  @override
  String deliveryFeeLabel(String fee) {
    return 'Delivery Fee: $fee LYD';
  }

  @override
  String orderTimeLabel(String time) {
    return 'Order Time: $time';
  }

  @override
  String get requestedProducts => 'Requested Products:';

  @override
  String get productTableColumn => 'Product';

  @override
  String get unitPriceTableColumn => 'Unit Price';

  @override
  String get quantityTableColumn => 'Quantity';

  @override
  String get subtotalTableColumn => 'Subtotal';

  @override
  String get totalProductsLabel => 'Total Products:';

  @override
  String get deliveryCostLabel => 'Delivery Cost:';

  @override
  String get grandTotalLabel => 'Grand Total:';

  @override
  String get cancellationInfoTitle => 'Order Cancellation Information:';

  @override
  String cancelReasonLabel(String reason) {
    return 'Cancellation Reason: $reason';
  }

  @override
  String get noReasonSpecified => 'No reason specified';

  @override
  String adminNotesLabel(String notes) {
    return 'Admin Notes: $notes';
  }

  @override
  String orderNotesLabel(String notes) {
    return 'Order Notes: $notes';
  }

  @override
  String get updateOrderStatusTitle => 'Update Order Status:';

  @override
  String orderStatusUpdatedSuccess(String status) {
    return 'Order status updated to ($status) successfully';
  }

  @override
  String get cancelOrderAndReturnProducts => 'Cancel Order & Return Products';

  @override
  String cancelOrderConfirmation(String id) {
    return 'You are about to cancel order #$id. Please select the reason and save details:';
  }

  @override
  String get actualCancelReason => 'Actual Cancellation Reason';

  @override
  String get selectCancelReasonValidator =>
      'Please select a cancellation reason first';

  @override
  String get additionalAdminNotes => 'Additional Admin Notes (Optional)';

  @override
  String get goBack => 'Go Back';

  @override
  String get confirmFinalCancellation => 'Confirm Final Cancellation';

  @override
  String get customerChangedMind => 'Customer changed mind about the order';

  @override
  String get orderCancelledSuccess =>
      'Order cancelled and data saved successfully';

  @override
  String get addNewCancelReasonSystem => 'Add New Cancel Reason in System';

  @override
  String get newReasonDisclaimer =>
      'The new reason will immediately appear as an option in the cancellation list for administrators.';

  @override
  String get cancelReasonArLabel => 'Cancellation Reason (Arabic)';

  @override
  String get requiredField => 'Required';

  @override
  String get cancelReasonEnLabel => 'Cancellation Reason (English)';

  @override
  String get saveAndRegister => 'Save';

  @override
  String get newCancelReasonRegisteredSuccess =>
      'New cancellation reason registered successfully';

  @override
  String get citiesManagementTitle => 'Cities & Active Delivery Management';

  @override
  String get searchCityHint => 'Search by city name...';

  @override
  String get noRegisteredCities => 'No registered cities found currently.';

  @override
  String get noMatchingCities => 'No cities match the current search.';

  @override
  String get serialNumberColumn => '#';

  @override
  String get cityNameColumn => 'City Name';

  @override
  String get activityStatusColumn => 'Activity Status';

  @override
  String get inactiveStatus => 'Inactive';

  @override
  String statusUpdateFailed(String error) {
    return 'Failed to update status: $error';
  }

  @override
  String errorLoadingCities(String error) {
    return 'Error loading cities: $error';
  }

  @override
  String get addNewCity => 'Add New City';

  @override
  String get regionsManagementTitle => 'Regions & Delivery Cost Management';

  @override
  String get searchRegionHint => 'Search by region name...';

  @override
  String get noRegisteredRegions => 'No registered regions currently';

  @override
  String get noMatchingRegions => 'No results match the current search.';

  @override
  String get regionColumn => 'Region';

  @override
  String get deliveryFeeColumn => 'Delivery Fee';

  @override
  String get deliveryTimeColumn => 'Delivery Time';

  @override
  String get deliveryStatusColumn => 'Delivery Status';

  @override
  String get addNewRegion => 'Add New Region';

  @override
  String errorLoadingRegions(String error) {
    return 'Error loading regions: $error';
  }

  @override
  String get addNewDeliveryRegionTitle => 'Add New Delivery Region';

  @override
  String get parentCityLabel => 'Parent City *';

  @override
  String get selectCityHint => 'Select City';

  @override
  String get selectParentCityValidator => 'Please select the parent city';

  @override
  String get errorFetchingCities => 'Error fetching cities';

  @override
  String get regionNameLabel => 'Region Name *';

  @override
  String get requiredFieldValidator => 'This field is required';

  @override
  String get deliveryFeeInputLabel => 'Delivery Fee (LYD) *';

  @override
  String get invalidValueValidator => 'Invalid value';

  @override
  String get deliveryDurationLabel => 'Delivery Duration (e.g., 1-2 days) *';

  @override
  String get savingProgress => 'Saving...';

  @override
  String get add => 'Add';

  @override
  String get addNewCityTitle => 'Add New Service City';

  @override
  String get addCityInstruction =>
      'Please enter the name of the city you want to activate to receive orders from:';

  @override
  String get cityNameInputLabel => 'City Name (e.g., Tobruk)';

  @override
  String get cityNameValidator => 'Please enter the city name';

  @override
  String get addAndActivate => 'Add & Activate';

  @override
  String cityAddedSuccess(String city) {
    return '$city city added successfully!';
  }

  @override
  String addFailedError(String error) {
    return 'Addition failed: $error';
  }

  @override
  String get editRegionTitle => 'Edit Region Details';

  @override
  String get regionNameArLabel => 'Region Name (Arabic) *';

  @override
  String get editDetails => 'Update Details';

  @override
  String get editProgress => 'Updating...';

  @override
  String get editCityTitle => 'Edit City Details';

  @override
  String get cityUpdatedSuccess => 'City updated successfully!';

  @override
  String updateFailedError(String error) {
    return 'Update failed: $error';
  }

  @override
  String get manageCancelReasonsTitle => 'Cancel Reasons Management';

  @override
  String get manageCancelReasonsSubtitle =>
      'Browse and add order cancellation reasons, with the ability to deactivate old reasons to ensure historical system record integrity.';

  @override
  String errorLoadingReasons(String error) {
    return 'An error occurred while loading reasons: $error';
  }

  @override
  String get noRegisteredReasons =>
      'No cancellation reasons registered currently';

  @override
  String get addFirstReasonInstruction =>
      'Add the first reason so it appears to admins in the order cancellation window.';

  @override
  String get addNow => 'Add Now';

  @override
  String get reasonColumn => 'Reason';

  @override
  String get disabledStatus => 'Disabled';

  @override
  String get reasonReactivatedSuccess =>
      'Cancellation reason successfully reactivated!';

  @override
  String get reasonDeactivatedSuccess => 'Cancellation reason deactivated.';

  @override
  String operationFailed(String error) {
    return 'Operation failed: $error';
  }

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get manageOrderStatusesTitle => 'Order Statuses Management';

  @override
  String get manageOrderStatusesSubtitle =>
      'Browse, add, and edit order statuses and their custom colors, with instant activation and deactivation capabilities.';

  @override
  String get addNewStatus => 'Add New Status';

  @override
  String errorLoadingStatuses(String error) {
    return 'An error occurred while loading order statuses: $error';
  }

  @override
  String get noRegisteredStatuses => 'No order statuses registered currently';

  @override
  String get addFirstStatusInstruction =>
      'Add the first status to the system to appear in order tracking.';

  @override
  String get addStatusNow => 'Add Status Now';

  @override
  String get statusNameColumn => 'Status Name';

  @override
  String get statusIdColumn => 'Identifier (ID)';

  @override
  String get statusDescriptionColumn => 'Description';

  @override
  String get statusColorColumn => 'Color';

  @override
  String statusActivatedSuccess(String name) {
    return 'Order status ($name) successfully activated!';
  }

  @override
  String statusDeactivatedSuccess(String name) {
    return 'Order status ($name) deactivated.';
  }

  @override
  String get editOrderStatusTitle => 'Edit Order Status';

  @override
  String get addOrderStatusTitle => 'Add New Status';

  @override
  String get orderStatusFormSubtitle =>
      'Enter the order status details that appear to users and admins on the dashboard.';

  @override
  String get statusIdLabel => 'Unique Identifier (statusId)';

  @override
  String get statusIdHint => 'e.g., processing, delivered, cancelled';

  @override
  String get statusIdRequiredError =>
      'Please enter the status unique identifier';

  @override
  String get statusIdInvalidError =>
      'Identifier must contain only English letters and numbers without spaces';

  @override
  String get statusNameLabel => 'Status Name';

  @override
  String get statusNameHint => 'e.g., Processing';

  @override
  String get statusDescriptionLabel => 'Detailed Status Description';

  @override
  String get statusDescriptionHint =>
      'e.g., Our team is currently packing and preparing products for shipping';

  @override
  String get colorHexLabel => 'Color Code (Hex)';

  @override
  String get colorHexHint => '#2196F3';

  @override
  String get colorHexRequiredError => 'Please enter the color code';

  @override
  String get colorHexInvalidError => 'Invalid format (e.g., #2196F3)';

  @override
  String get previewLabel => 'Preview';

  @override
  String get suggestedColorsLabel => 'Suggested colors for quick selection:';

  @override
  String get systemActivationStatusLabel =>
      'System Activation Status (Active):';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get addStatus => 'Add Status';

  @override
  String get statusUpdatedSuccess => 'Status updated successfully!';

  @override
  String get statusAddedSuccess => 'New order status added successfully!';

  @override
  String get errorLoadingSettings =>
      'Failed to load general settings. Please try again.';

  @override
  String get generalAppSettingsTitle => 'General App Settings';

  @override
  String get generalAppSettingsSubtitle =>
      'Manage basic app data, social links, and legal pages.';

  @override
  String get generalAndOperationSettings => 'General & Operation Settings';

  @override
  String get appNameLabel => 'App Name';

  @override
  String get appNameHint => 'e.g., Gheiras';

  @override
  String get appVersionLabel => 'App Version';

  @override
  String get appVersionHint => 'e.g., 1.0.0';

  @override
  String get storeSupportPhoneLabel => 'Store Support Phone';

  @override
  String get storeSupportPhoneHint => 'e.g., 0912345678';

  @override
  String get minOrderValueLabel => 'Minimum Order Value';

  @override
  String get minOrderValueHint => 'e.g., 50';

  @override
  String get currencyCodeLabel => 'Currency Code';

  @override
  String get currencyCodeHint => 'e.g., LYD';

  @override
  String get socialMediaLinksTitle => 'Social Media Links';

  @override
  String get facebookUrlLabel => 'Facebook URL';

  @override
  String get facebookUrlHint => 'https://facebook.com/...';

  @override
  String get instagramUrlLabel => 'Instagram URL';

  @override
  String get instagramUrlHint => 'https://instagram.com/...';

  @override
  String get whatsappNumberLabel => 'WhatsApp Number';

  @override
  String get whatsappNumberHint => 'e.g., +218912345678';

  @override
  String get legalAndIntroPagesTitle => 'Legal & Intro Pages';

  @override
  String get aboutUsLabel => 'About Us';

  @override
  String get aboutUsHint => 'Write a clear and brief description of the store.';

  @override
  String get privacyPolicyUrlLabel => 'Privacy Policy URL';

  @override
  String get privacyPolicyUrlHint => 'https://example.com/privacy';

  @override
  String get termsUrlLabel => 'Terms and Conditions URL';

  @override
  String get termsUrlHint => 'https://example.com/terms';

  @override
  String get maintenanceModeActive => 'Maintenance mode is currently active';

  @override
  String get changesApplyAfterSave =>
      'Changes will apply to the app after saving';

  @override
  String get saveSettingsButton => 'Save Settings';

  @override
  String get settingsSavedSuccess => 'General settings saved successfully';

  @override
  String get settingsSaveError => 'Failed to save settings. Please try again.';

  @override
  String get maintenanceModeActiveStatus => 'App is under maintenance';

  @override
  String get appWorkingNormally => 'App is working normally';

  @override
  String get unblockUserTooltip => 'Unblock User';

  @override
  String get blockUserTooltip => 'Block User';

  @override
  String get editUserDetailsTitle => 'Edit User Details';

  @override
  String get userUpdatedSuccess => 'Updated successfully';

  @override
  String get areYouSurePrompt => 'Are you sure about this action?';

  @override
  String get accountStatusUpdatedSuccess =>
      'Account status changed successfully';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get manageAdminsTitle => 'Admins & Permissions Management';

  @override
  String get manageAdminsSubtitle =>
      'Manage admin accounts, define their roles, and control access permissions to the dashboard.';

  @override
  String get addNewAdmin => 'Add New Admin';

  @override
  String get nameColumn => 'Name';

  @override
  String get emailColumn => 'Email';

  @override
  String get noRegisteredAdmins => 'No registered admins currently.';

  @override
  String get editAdminRole => 'Edit Admin Role';

  @override
  String get adminUpdatedSuccess =>
      'Admin details and role updated successfully!';

  @override
  String get adminAddedSuccess => 'New admin added successfully!';

  @override
  String get save => 'Save';
}
