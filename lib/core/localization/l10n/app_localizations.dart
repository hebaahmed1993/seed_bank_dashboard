import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @platformTitle.
  ///
  /// In en, this message translates to:
  /// **'Gheras Cloud Platform'**
  String get platformTitle;

  /// No description provided for @platformSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Centralized Administration Dashboard System'**
  String get platformSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter administrator credentials to access the dashboard'**
  String get loginInstruction;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Access Dashboard'**
  String get loginButton;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @homeMenu.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeMenu;

  /// No description provided for @plantsMenu.
  ///
  /// In en, this message translates to:
  /// **'Plants & Seeds'**
  String get plantsMenu;

  /// No description provided for @usersMenu.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersMenu;

  /// No description provided for @ordersMenu.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersMenu;

  /// No description provided for @reportsMenu.
  ///
  /// In en, this message translates to:
  /// **'Financial Reports'**
  String get reportsMenu;

  /// No description provided for @settingsMenu.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsMenu;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, Heba Ahmed 👋'**
  String get welcomeMessage;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'System Overview'**
  String get overviewTitle;

  /// No description provided for @totalSeeds.
  ///
  /// In en, this message translates to:
  /// **'Total Seeds'**
  String get totalSeeds;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get activeOrders;

  /// No description provided for @registeredFarmers.
  ///
  /// In en, this message translates to:
  /// **'Registered Farmers'**
  String get registeredFarmers;

  /// No description provided for @monthlyEarnings.
  ///
  /// In en, this message translates to:
  /// **'Monthly Earnings'**
  String get monthlyEarnings;

  /// No description provided for @chartsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Charts space and latest operations list (Under Development) 📊'**
  String get chartsPlaceholder;

  /// No description provided for @usersManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'User Management & Permissions'**
  String get usersManagementTitle;

  /// No description provided for @usersManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full control over system accounts, employees, and farmers'**
  String get usersManagementSubtitle;

  /// No description provided for @addNewEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add New Employee'**
  String get addNewEmployee;

  /// No description provided for @searchUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Search by username, email, or phone...'**
  String get searchUsersHint;

  /// No description provided for @allRoles.
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get allRoles;

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRole;

  /// No description provided for @dataEntryRole.
  ///
  /// In en, this message translates to:
  /// **'Data Entry'**
  String get dataEntryRole;

  /// No description provided for @farmerRole.
  ///
  /// In en, this message translates to:
  /// **'Professional Farmer'**
  String get farmerRole;

  /// No description provided for @hobbyistRole.
  ///
  /// In en, this message translates to:
  /// **'Hobbyist / Regular User'**
  String get hobbyistRole;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get allStatuses;

  /// No description provided for @activeOnly.
  ///
  /// In en, this message translates to:
  /// **'Active Only'**
  String get activeOnly;

  /// No description provided for @blockedOnly.
  ///
  /// In en, this message translates to:
  /// **'Blocked Only'**
  String get blockedOnly;

  /// No description provided for @noMatchingUsers.
  ///
  /// In en, this message translates to:
  /// **'No users match the search and filter criteria.'**
  String get noMatchingUsers;

  /// No description provided for @userColumn.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userColumn;

  /// No description provided for @phoneColumn.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneColumn;

  /// No description provided for @cityColumn.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityColumn;

  /// No description provided for @roleColumn.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleColumn;

  /// No description provided for @statusColumn.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusColumn;

  /// No description provided for @actionsColumn.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actionsColumn;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @blockedStatus.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blockedStatus;

  /// No description provided for @backToUsersList.
  ///
  /// In en, this message translates to:
  /// **'Back to Users List'**
  String get backToUsersList;

  /// No description provided for @createAccountCloud.
  ///
  /// In en, this message translates to:
  /// **'Create New User Account Securely'**
  String get createAccountCloud;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullNameLabel;

  /// No description provided for @fullNameValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get fullNameValidator;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address *'**
  String get emailLabel;

  /// No description provided for @emailEmptyValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter email address'**
  String get emailEmptyValidator;

  /// No description provided for @emailInvalidValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalidValidator;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get phoneLabel;

  /// No description provided for @phoneValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get phoneValidator;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get cityLabel;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Role Level (Account Type) *'**
  String get roleLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveAccountCloud.
  ///
  /// In en, this message translates to:
  /// **'Save Account to Cloud'**
  String get saveAccountCloud;

  /// No description provided for @productsManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage platform offerings including plants, seeds, and equipment'**
  String get productsManagementSubtitle;

  /// No description provided for @addNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addNewProduct;

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by product commercial or scientific name...'**
  String get searchProductsHint;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @productImageColumn.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get productImageColumn;

  /// No description provided for @productNameArColumn.
  ///
  /// In en, this message translates to:
  /// **'Name (Ar)'**
  String get productNameArColumn;

  /// No description provided for @productNameEnColumn.
  ///
  /// In en, this message translates to:
  /// **'Name (En)'**
  String get productNameEnColumn;

  /// No description provided for @productPriceColumn.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get productPriceColumn;

  /// No description provided for @productStockColumn.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get productStockColumn;

  /// No description provided for @noMatchingProducts.
  ///
  /// In en, this message translates to:
  /// **'No matching products found 📦'**
  String get noMatchingProducts;

  /// No description provided for @backToProductsList.
  ///
  /// In en, this message translates to:
  /// **'Back to Products List'**
  String get backToProductsList;

  /// No description provided for @addProductToPlatform.
  ///
  /// In en, this message translates to:
  /// **'Add New Product to Platform'**
  String get addProductToPlatform;

  /// No description provided for @productTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Title / Name *'**
  String get productTitleLabel;

  /// No description provided for @productTitleValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter product title'**
  String get productTitleValidator;

  /// No description provided for @productDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Detailed Description *'**
  String get productDescriptionLabel;

  /// No description provided for @productDescriptionValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get productDescriptionValidator;

  /// No description provided for @productPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (LYD) *'**
  String get productPriceLabel;

  /// No description provided for @productPriceValidator.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get productPriceValidator;

  /// No description provided for @productStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock Quantity *'**
  String get productStockLabel;

  /// No description provided for @productStockValidator.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get productStockValidator;

  /// No description provided for @mainCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Main Category *'**
  String get mainCategoryLabel;

  /// No description provided for @categoryRequiredValidator.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get categoryRequiredValidator;

  /// No description provided for @suitableSeasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Suitable Season *'**
  String get suitableSeasonLabel;

  /// No description provided for @germinationRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Germination Rate if applicable (e.g., 90%)'**
  String get germinationRateLabel;

  /// No description provided for @saveProductCloud.
  ///
  /// In en, this message translates to:
  /// **'Save Product to Cloud'**
  String get saveProductCloud;

  /// No description provided for @ordersManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders Management'**
  String get ordersManagementTitle;

  /// No description provided for @ordersManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor and process incoming farmer orders (last 30 added orders)'**
  String get ordersManagementSubtitle;

  /// No description provided for @addNewCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Add New Cancel Reason'**
  String get addNewCancelReason;

  /// No description provided for @noOrdersRegistered.
  ///
  /// In en, this message translates to:
  /// **'No orders registered in the system currently.'**
  String get noOrdersRegistered;

  /// No description provided for @showingOrders.
  ///
  /// In en, this message translates to:
  /// **'Showing {start} to {end} of {total} orders'**
  String showingOrders(String start, String end, String total);

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOf(String current, String total);

  /// No description provided for @ordersError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while fetching orders: {error}'**
  String ordersError(String error);

  /// No description provided for @orderNumberColumn.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumberColumn;

  /// No description provided for @farmerAndContactColumn.
  ///
  /// In en, this message translates to:
  /// **'Farmer & Contact'**
  String get farmerAndContactColumn;

  /// No description provided for @orderDateTimeColumn.
  ///
  /// In en, this message translates to:
  /// **'Order Date & Time'**
  String get orderDateTimeColumn;

  /// No description provided for @orderValueColumn.
  ///
  /// In en, this message translates to:
  /// **'Order Value'**
  String get orderValueColumn;

  /// No description provided for @orderStatusColumn.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatusColumn;

  /// No description provided for @detailsColumn.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsColumn;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApproval;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'LYD'**
  String get currency;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details #{id}'**
  String orderDetailsTitle(String id);

  /// No description provided for @clientData.
  ///
  /// In en, this message translates to:
  /// **'Client Data'**
  String get clientData;

  /// No description provided for @clientNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name: {name}'**
  String clientNameLabel(String name);

  /// No description provided for @clientPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String clientPhoneLabel(String phone);

  /// No description provided for @clientUserIdLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID: {id}'**
  String clientUserIdLabel(String id);

  /// No description provided for @deliveryAndTimeData.
  ///
  /// In en, this message translates to:
  /// **'Delivery & Time Data'**
  String get deliveryAndTimeData;

  /// No description provided for @deliveryAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address: {address}'**
  String deliveryAddressLabel(String address);

  /// No description provided for @deliveryFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee: {fee} LYD'**
  String deliveryFeeLabel(String fee);

  /// No description provided for @orderTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Time: {time}'**
  String orderTimeLabel(String time);

  /// No description provided for @requestedProducts.
  ///
  /// In en, this message translates to:
  /// **'Requested Products:'**
  String get requestedProducts;

  /// No description provided for @productTableColumn.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productTableColumn;

  /// No description provided for @unitPriceTableColumn.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPriceTableColumn;

  /// No description provided for @quantityTableColumn.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityTableColumn;

  /// No description provided for @subtotalTableColumn.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotalTableColumn;

  /// No description provided for @totalProductsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Products:'**
  String get totalProductsLabel;

  /// No description provided for @deliveryCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Cost:'**
  String get deliveryCostLabel;

  /// No description provided for @grandTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Grand Total:'**
  String get grandTotalLabel;

  /// No description provided for @cancellationInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Cancellation Information:'**
  String get cancellationInfoTitle;

  /// No description provided for @cancelReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason: {reason}'**
  String cancelReasonLabel(String reason);

  /// No description provided for @noReasonSpecified.
  ///
  /// In en, this message translates to:
  /// **'No reason specified'**
  String get noReasonSpecified;

  /// No description provided for @adminNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Admin Notes: {notes}'**
  String adminNotesLabel(String notes);

  /// No description provided for @orderNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Notes: {notes}'**
  String orderNotesLabel(String notes);

  /// No description provided for @updateOrderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Order Status:'**
  String get updateOrderStatusTitle;

  /// No description provided for @orderStatusUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order status updated to ({status}) successfully'**
  String orderStatusUpdatedSuccess(String status);

  /// No description provided for @cancelOrderAndReturnProducts.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order & Return Products'**
  String get cancelOrderAndReturnProducts;

  /// No description provided for @cancelOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'You are about to cancel order #{id}. Please select the reason and save details:'**
  String cancelOrderConfirmation(String id);

  /// No description provided for @actualCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Actual Cancellation Reason'**
  String get actualCancelReason;

  /// No description provided for @selectCancelReasonValidator.
  ///
  /// In en, this message translates to:
  /// **'Please select a cancellation reason first'**
  String get selectCancelReasonValidator;

  /// No description provided for @additionalAdminNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Admin Notes (Optional)'**
  String get additionalAdminNotes;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @confirmFinalCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Final Cancellation'**
  String get confirmFinalCancellation;

  /// No description provided for @customerChangedMind.
  ///
  /// In en, this message translates to:
  /// **'Customer changed mind about the order'**
  String get customerChangedMind;

  /// No description provided for @orderCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled and data saved successfully'**
  String get orderCancelledSuccess;

  /// No description provided for @addNewCancelReasonSystem.
  ///
  /// In en, this message translates to:
  /// **'Add New Cancel Reason in System'**
  String get addNewCancelReasonSystem;

  /// No description provided for @newReasonDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'The new reason will immediately appear as an option in the cancellation list for administrators.'**
  String get newReasonDisclaimer;

  /// No description provided for @cancelReasonArLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason (Arabic)'**
  String get cancelReasonArLabel;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @cancelReasonEnLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason (English)'**
  String get cancelReasonEnLabel;

  /// No description provided for @saveAndRegister.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAndRegister;

  /// No description provided for @newCancelReasonRegisteredSuccess.
  ///
  /// In en, this message translates to:
  /// **'New cancellation reason registered successfully'**
  String get newCancelReasonRegisteredSuccess;

  /// No description provided for @citiesManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Cities & Active Delivery Management'**
  String get citiesManagementTitle;

  /// No description provided for @searchCityHint.
  ///
  /// In en, this message translates to:
  /// **'Search by city name...'**
  String get searchCityHint;

  /// No description provided for @noRegisteredCities.
  ///
  /// In en, this message translates to:
  /// **'No registered cities found currently.'**
  String get noRegisteredCities;

  /// No description provided for @noMatchingCities.
  ///
  /// In en, this message translates to:
  /// **'No cities match the current search.'**
  String get noMatchingCities;

  /// No description provided for @serialNumberColumn.
  ///
  /// In en, this message translates to:
  /// **'#'**
  String get serialNumberColumn;

  /// No description provided for @cityNameColumn.
  ///
  /// In en, this message translates to:
  /// **'City Name'**
  String get cityNameColumn;

  /// No description provided for @activityStatusColumn.
  ///
  /// In en, this message translates to:
  /// **'Activity Status'**
  String get activityStatusColumn;

  /// No description provided for @inactiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactiveStatus;

  /// No description provided for @statusUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status: {error}'**
  String statusUpdateFailed(String error);

  /// No description provided for @errorLoadingCities.
  ///
  /// In en, this message translates to:
  /// **'Error loading cities: {error}'**
  String errorLoadingCities(String error);

  /// No description provided for @addNewCity.
  ///
  /// In en, this message translates to:
  /// **'Add New City'**
  String get addNewCity;

  /// No description provided for @regionsManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Regions & Delivery Cost Management'**
  String get regionsManagementTitle;

  /// No description provided for @searchRegionHint.
  ///
  /// In en, this message translates to:
  /// **'Search by region name...'**
  String get searchRegionHint;

  /// No description provided for @noRegisteredRegions.
  ///
  /// In en, this message translates to:
  /// **'No registered regions currently'**
  String get noRegisteredRegions;

  /// No description provided for @noMatchingRegions.
  ///
  /// In en, this message translates to:
  /// **'No results match the current search.'**
  String get noMatchingRegions;

  /// No description provided for @regionColumn.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get regionColumn;

  /// No description provided for @deliveryFeeColumn.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFeeColumn;

  /// No description provided for @deliveryTimeColumn.
  ///
  /// In en, this message translates to:
  /// **'Delivery Time'**
  String get deliveryTimeColumn;

  /// No description provided for @deliveryStatusColumn.
  ///
  /// In en, this message translates to:
  /// **'Delivery Status'**
  String get deliveryStatusColumn;

  /// No description provided for @addNewRegion.
  ///
  /// In en, this message translates to:
  /// **'Add New Region'**
  String get addNewRegion;

  /// No description provided for @errorLoadingRegions.
  ///
  /// In en, this message translates to:
  /// **'Error loading regions: {error}'**
  String errorLoadingRegions(String error);

  /// No description provided for @addNewDeliveryRegionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Delivery Region'**
  String get addNewDeliveryRegionTitle;

  /// No description provided for @parentCityLabel.
  ///
  /// In en, this message translates to:
  /// **'Parent City *'**
  String get parentCityLabel;

  /// No description provided for @selectCityHint.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCityHint;

  /// No description provided for @selectParentCityValidator.
  ///
  /// In en, this message translates to:
  /// **'Please select the parent city'**
  String get selectParentCityValidator;

  /// No description provided for @errorFetchingCities.
  ///
  /// In en, this message translates to:
  /// **'Error fetching cities'**
  String get errorFetchingCities;

  /// No description provided for @regionNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Region Name *'**
  String get regionNameLabel;

  /// No description provided for @requiredFieldValidator.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredFieldValidator;

  /// No description provided for @deliveryFeeInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee (LYD) *'**
  String get deliveryFeeInputLabel;

  /// No description provided for @invalidValueValidator.
  ///
  /// In en, this message translates to:
  /// **'Invalid value'**
  String get invalidValueValidator;

  /// No description provided for @deliveryDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Duration (e.g., 1-2 days) *'**
  String get deliveryDurationLabel;

  /// No description provided for @savingProgress.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingProgress;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addNewCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Service City'**
  String get addNewCityTitle;

  /// No description provided for @addCityInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please enter the name of the city you want to activate to receive orders from:'**
  String get addCityInstruction;

  /// No description provided for @cityNameInputLabel.
  ///
  /// In en, this message translates to:
  /// **'City Name (e.g., Tobruk)'**
  String get cityNameInputLabel;

  /// No description provided for @cityNameValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter the city name'**
  String get cityNameValidator;

  /// No description provided for @addAndActivate.
  ///
  /// In en, this message translates to:
  /// **'Add & Activate'**
  String get addAndActivate;

  /// No description provided for @cityAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{city} city added successfully!'**
  String cityAddedSuccess(String city);

  /// No description provided for @addFailedError.
  ///
  /// In en, this message translates to:
  /// **'Addition failed: {error}'**
  String addFailedError(String error);

  /// No description provided for @editRegionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Region Details'**
  String get editRegionTitle;

  /// No description provided for @regionNameArLabel.
  ///
  /// In en, this message translates to:
  /// **'Region Name (Arabic) *'**
  String get regionNameArLabel;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Update Details'**
  String get editDetails;

  /// No description provided for @editProgress.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get editProgress;

  /// No description provided for @editCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit City Details'**
  String get editCityTitle;

  /// No description provided for @cityUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'City updated successfully!'**
  String get cityUpdatedSuccess;

  /// No description provided for @updateFailedError.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String updateFailedError(String error);

  /// No description provided for @manageCancelReasonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Reasons Management'**
  String get manageCancelReasonsTitle;

  /// No description provided for @manageCancelReasonsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse and add order cancellation reasons, with the ability to deactivate old reasons to ensure historical system record integrity.'**
  String get manageCancelReasonsSubtitle;

  /// No description provided for @errorLoadingReasons.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading reasons: {error}'**
  String errorLoadingReasons(String error);

  /// No description provided for @noRegisteredReasons.
  ///
  /// In en, this message translates to:
  /// **'No cancellation reasons registered currently'**
  String get noRegisteredReasons;

  /// No description provided for @addFirstReasonInstruction.
  ///
  /// In en, this message translates to:
  /// **'Add the first reason so it appears to admins in the order cancellation window.'**
  String get addFirstReasonInstruction;

  /// No description provided for @addNow.
  ///
  /// In en, this message translates to:
  /// **'Add Now'**
  String get addNow;

  /// No description provided for @reasonColumn.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reasonColumn;

  /// No description provided for @disabledStatus.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabledStatus;

  /// No description provided for @reasonReactivatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason successfully reactivated!'**
  String get reasonReactivatedSuccess;

  /// No description provided for @reasonDeactivatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason deactivated.'**
  String get reasonDeactivatedSuccess;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed: {error}'**
  String operationFailed(String error);

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @manageOrderStatusesTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Statuses Management'**
  String get manageOrderStatusesTitle;

  /// No description provided for @manageOrderStatusesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse, add, and edit order statuses and their custom colors, with instant activation and deactivation capabilities.'**
  String get manageOrderStatusesSubtitle;

  /// No description provided for @addNewStatus.
  ///
  /// In en, this message translates to:
  /// **'Add New Status'**
  String get addNewStatus;

  /// No description provided for @errorLoadingStatuses.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading order statuses: {error}'**
  String errorLoadingStatuses(String error);

  /// No description provided for @noRegisteredStatuses.
  ///
  /// In en, this message translates to:
  /// **'No order statuses registered currently'**
  String get noRegisteredStatuses;

  /// No description provided for @addFirstStatusInstruction.
  ///
  /// In en, this message translates to:
  /// **'Add the first status to the system to appear in order tracking.'**
  String get addFirstStatusInstruction;

  /// No description provided for @addStatusNow.
  ///
  /// In en, this message translates to:
  /// **'Add Status Now'**
  String get addStatusNow;

  /// No description provided for @statusNameColumn.
  ///
  /// In en, this message translates to:
  /// **'Status Name'**
  String get statusNameColumn;

  /// No description provided for @statusIdColumn.
  ///
  /// In en, this message translates to:
  /// **'Identifier (ID)'**
  String get statusIdColumn;

  /// No description provided for @statusDescriptionColumn.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get statusDescriptionColumn;

  /// No description provided for @statusColorColumn.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get statusColorColumn;

  /// No description provided for @statusActivatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order status ({name}) successfully activated!'**
  String statusActivatedSuccess(String name);

  /// No description provided for @statusDeactivatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order status ({name}) deactivated.'**
  String statusDeactivatedSuccess(String name);

  /// No description provided for @editOrderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Order Status'**
  String get editOrderStatusTitle;

  /// No description provided for @addOrderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Status'**
  String get addOrderStatusTitle;

  /// No description provided for @orderStatusFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the order status details that appear to users and admins on the dashboard.'**
  String get orderStatusFormSubtitle;

  /// No description provided for @statusIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Unique Identifier (statusId)'**
  String get statusIdLabel;

  /// No description provided for @statusIdHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., processing, delivered, cancelled'**
  String get statusIdHint;

  /// No description provided for @statusIdRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the status unique identifier'**
  String get statusIdRequiredError;

  /// No description provided for @statusIdInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Identifier must contain only English letters and numbers without spaces'**
  String get statusIdInvalidError;

  /// No description provided for @statusNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Status Name'**
  String get statusNameLabel;

  /// No description provided for @statusNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Processing'**
  String get statusNameHint;

  /// No description provided for @statusDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Detailed Status Description'**
  String get statusDescriptionLabel;

  /// No description provided for @statusDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Our team is currently packing and preparing products for shipping'**
  String get statusDescriptionHint;

  /// No description provided for @colorHexLabel.
  ///
  /// In en, this message translates to:
  /// **'Color Code (Hex)'**
  String get colorHexLabel;

  /// No description provided for @colorHexHint.
  ///
  /// In en, this message translates to:
  /// **'#2196F3'**
  String get colorHexHint;

  /// No description provided for @colorHexRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the color code'**
  String get colorHexRequiredError;

  /// No description provided for @colorHexInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Invalid format (e.g., #2196F3)'**
  String get colorHexInvalidError;

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewLabel;

  /// No description provided for @suggestedColorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggested colors for quick selection:'**
  String get suggestedColorsLabel;

  /// No description provided for @systemActivationStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'System Activation Status (Active):'**
  String get systemActivationStatusLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @addStatus.
  ///
  /// In en, this message translates to:
  /// **'Add Status'**
  String get addStatus;

  /// No description provided for @statusUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Status updated successfully!'**
  String get statusUpdatedSuccess;

  /// No description provided for @statusAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'New order status added successfully!'**
  String get statusAddedSuccess;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load general settings. Please try again.'**
  String get errorLoadingSettings;

  /// No description provided for @generalAppSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'General App Settings'**
  String get generalAppSettingsTitle;

  /// No description provided for @generalAppSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage basic app data, social links, and legal pages.'**
  String get generalAppSettingsSubtitle;

  /// No description provided for @generalAndOperationSettings.
  ///
  /// In en, this message translates to:
  /// **'General & Operation Settings'**
  String get generalAndOperationSettings;

  /// No description provided for @appNameLabel.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appNameLabel;

  /// No description provided for @appNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Gheiras'**
  String get appNameHint;

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersionLabel;

  /// No description provided for @appVersionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 1.0.0'**
  String get appVersionHint;

  /// No description provided for @storeSupportPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Store Support Phone'**
  String get storeSupportPhoneLabel;

  /// No description provided for @storeSupportPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 0912345678'**
  String get storeSupportPhoneHint;

  /// No description provided for @minOrderValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum Order Value'**
  String get minOrderValueLabel;

  /// No description provided for @minOrderValueHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 50'**
  String get minOrderValueHint;

  /// No description provided for @currencyCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency Code'**
  String get currencyCodeLabel;

  /// No description provided for @currencyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., LYD'**
  String get currencyCodeHint;

  /// No description provided for @socialMediaLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'Social Media Links'**
  String get socialMediaLinksTitle;

  /// No description provided for @facebookUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Facebook URL'**
  String get facebookUrlLabel;

  /// No description provided for @facebookUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://facebook.com/...'**
  String get facebookUrlHint;

  /// No description provided for @instagramUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Instagram URL'**
  String get instagramUrlLabel;

  /// No description provided for @instagramUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://instagram.com/...'**
  String get instagramUrlHint;

  /// No description provided for @whatsappNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number'**
  String get whatsappNumberLabel;

  /// No description provided for @whatsappNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., +218912345678'**
  String get whatsappNumberHint;

  /// No description provided for @legalAndIntroPagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal & Intro Pages'**
  String get legalAndIntroPagesTitle;

  /// No description provided for @aboutUsLabel.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUsLabel;

  /// No description provided for @aboutUsHint.
  ///
  /// In en, this message translates to:
  /// **'Write a clear and brief description of the store.'**
  String get aboutUsHint;

  /// No description provided for @privacyPolicyUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy URL'**
  String get privacyPolicyUrlLabel;

  /// No description provided for @privacyPolicyUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://example.com/privacy'**
  String get privacyPolicyUrlHint;

  /// No description provided for @termsUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions URL'**
  String get termsUrlLabel;

  /// No description provided for @termsUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://example.com/terms'**
  String get termsUrlHint;

  /// No description provided for @maintenanceModeActive.
  ///
  /// In en, this message translates to:
  /// **'Maintenance mode is currently active'**
  String get maintenanceModeActive;

  /// No description provided for @changesApplyAfterSave.
  ///
  /// In en, this message translates to:
  /// **'Changes will apply to the app after saving'**
  String get changesApplyAfterSave;

  /// No description provided for @saveSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettingsButton;

  /// No description provided for @settingsSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'General settings saved successfully'**
  String get settingsSavedSuccess;

  /// No description provided for @settingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings. Please try again.'**
  String get settingsSaveError;

  /// No description provided for @maintenanceModeActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'App is under maintenance'**
  String get maintenanceModeActiveStatus;

  /// No description provided for @appWorkingNormally.
  ///
  /// In en, this message translates to:
  /// **'App is working normally'**
  String get appWorkingNormally;

  /// No description provided for @unblockUserTooltip.
  ///
  /// In en, this message translates to:
  /// **'Unblock User'**
  String get unblockUserTooltip;

  /// No description provided for @blockUserTooltip.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUserTooltip;

  /// No description provided for @editUserDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit User Details'**
  String get editUserDetailsTitle;

  /// No description provided for @userUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get userUpdatedSuccess;

  /// No description provided for @areYouSurePrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure about this action?'**
  String get areYouSurePrompt;

  /// No description provided for @accountStatusUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account status changed successfully'**
  String get accountStatusUpdatedSuccess;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @manageAdminsTitle.
  ///
  /// In en, this message translates to:
  /// **'Admins & Permissions Management'**
  String get manageAdminsTitle;

  /// No description provided for @manageAdminsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage admin accounts, define their roles, and control access permissions to the dashboard.'**
  String get manageAdminsSubtitle;

  /// No description provided for @addNewAdmin.
  ///
  /// In en, this message translates to:
  /// **'Add New Admin'**
  String get addNewAdmin;

  /// No description provided for @nameColumn.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameColumn;

  /// No description provided for @emailColumn.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailColumn;

  /// No description provided for @noRegisteredAdmins.
  ///
  /// In en, this message translates to:
  /// **'No registered admins currently.'**
  String get noRegisteredAdmins;

  /// No description provided for @editAdminRole.
  ///
  /// In en, this message translates to:
  /// **'Edit Admin Role'**
  String get editAdminRole;

  /// No description provided for @adminUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Admin details and role updated successfully!'**
  String get adminUpdatedSuccess;

  /// No description provided for @adminAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'New admin added successfully!'**
  String get adminAddedSuccess;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
