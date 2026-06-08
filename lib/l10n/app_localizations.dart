import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettings;

  /// No description provided for @sendSuccessNotification.
  ///
  /// In en, this message translates to:
  /// **'We have sent you an email. Please check it and follow the instructions.'**
  String get sendSuccessNotification;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @sendPasswordResetInstructions.
  ///
  /// In en, this message translates to:
  /// **'Please enter your registration email.\nWe will send instructions to change your password to this email.'**
  String get sendPasswordResetInstructions;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @withGoogle.
  ///
  /// In en, this message translates to:
  /// **'With Google'**
  String get withGoogle;

  /// No description provided for @withFacebook.
  ///
  /// In en, this message translates to:
  /// **'With Facebook'**
  String get withFacebook;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @logInWithSocial.
  ///
  /// In en, this message translates to:
  /// **'Log in with one of the following to book and manage your appointments.'**
  String get logInWithSocial;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset successfully. Please log in.'**
  String get passwordResetSuccess;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password for your account.'**
  String get pleaseEnterNewPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password *'**
  String get enterNewPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password *'**
  String get confirmNewPassword;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @registerYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Register your account'**
  String get registerYourAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and policies to continue.'**
  String get acceptTerms;

  /// No description provided for @agreeToTerms1.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to Healio\'s '**
  String get agreeToTerms1;

  /// No description provided for @agreeToTerms2.
  ///
  /// In en, this message translates to:
  /// **'terms of service'**
  String get agreeToTerms2;

  /// No description provided for @agreeToTerms3.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get agreeToTerms3;

  /// No description provided for @agreeToTerms4.
  ///
  /// In en, this message translates to:
  /// **'privacy policy.'**
  String get agreeToTerms4;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'You already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @passwordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated successfully. Please log in.'**
  String get passwordUpdateSuccess;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password *'**
  String get enterCurrentPassword;

  /// No description provided for @forgotPasswordOption1.
  ///
  /// In en, this message translates to:
  /// **'If you forgot your password, '**
  String get forgotPasswordOption1;

  /// No description provided for @forgotPasswordOption2.
  ///
  /// In en, this message translates to:
  /// **'you can reset by clicking on this link.'**
  String get forgotPasswordOption2;

  /// No description provided for @emailVerification.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerification;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'We have sent code to your email: \n'**
  String get enterVerificationCode;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didNotReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @verifyAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify Account'**
  String get verifyAccount;

  /// No description provided for @enterFullCode.
  ///
  /// In en, this message translates to:
  /// **'Enter full code'**
  String get enterFullCode;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddress;

  /// No description provided for @addressName.
  ///
  /// In en, this message translates to:
  /// **'Address name *'**
  String get addressName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @commune.
  ///
  /// In en, this message translates to:
  /// **'Commune'**
  String get commune;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @province.
  ///
  /// In en, this message translates to:
  /// **'Province *'**
  String get province;

  /// No description provided for @updateAddressSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update address successfully'**
  String get updateAddressSuccess;

  /// No description provided for @addAddressSuccess.
  ///
  /// In en, this message translates to:
  /// **'Add address successfully'**
  String get addAddressSuccess;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @treatments.
  ///
  /// In en, this message translates to:
  /// **'Treatments'**
  String get treatments;

  /// No description provided for @hairAndStyling.
  ///
  /// In en, this message translates to:
  /// **'Hair & styling'**
  String get hairAndStyling;

  /// No description provided for @nails.
  ///
  /// In en, this message translates to:
  /// **'Nails'**
  String get nails;

  /// No description provided for @eyebrowsAndEyelashes.
  ///
  /// In en, this message translates to:
  /// **'Eyebrows & eyelashes'**
  String get eyebrowsAndEyelashes;

  /// No description provided for @massage.
  ///
  /// In en, this message translates to:
  /// **'Massage'**
  String get massage;

  /// No description provided for @spaAndSauna.
  ///
  /// In en, this message translates to:
  /// **'Spa & sauna'**
  String get spaAndSauna;

  /// No description provided for @barbering.
  ///
  /// In en, this message translates to:
  /// **'Barbering'**
  String get barbering;

  /// No description provided for @makeup.
  ///
  /// In en, this message translates to:
  /// **'Makeup'**
  String get makeup;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @aesthetics.
  ///
  /// In en, this message translates to:
  /// **'Aesthetics'**
  String get aesthetics;

  /// No description provided for @tattooAndPiercing.
  ///
  /// In en, this message translates to:
  /// **'Tattoo & piercing'**
  String get tattooAndPiercing;

  /// No description provided for @facialAndSkincare.
  ///
  /// In en, this message translates to:
  /// **'Facial & skincare'**
  String get facialAndSkincare;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'We didn\'t find a match'**
  String get noResultsFound;

  /// No description provided for @tryNewSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a new search'**
  String get tryNewSearch;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @zeroResults.
  ///
  /// In en, this message translates to:
  /// **'0 results'**
  String get zeroResults;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationPermission.
  ///
  /// In en, this message translates to:
  /// **'You have not allowed access to your current location. For the most accurate search results please adjust location settings.'**
  String get locationPermission;

  /// No description provided for @myAddresses.
  ///
  /// In en, this message translates to:
  /// **'My addresses'**
  String get myAddresses;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @addHome.
  ///
  /// In en, this message translates to:
  /// **'Add home'**
  String get addHome;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @addWork.
  ///
  /// In en, this message translates to:
  /// **'Add work'**
  String get addWork;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top categories'**
  String get topCategories;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @noTimeSelected.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t selected a time yet'**
  String get noTimeSelected;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get dateAndTime;

  /// No description provided for @selectDay.
  ///
  /// In en, this message translates to:
  /// **'Select day'**
  String get selectDay;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @anytime.
  ///
  /// In en, this message translates to:
  /// **'Anytime'**
  String get anytime;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @hairSalons.
  ///
  /// In en, this message translates to:
  /// **'Hair salons'**
  String get hairSalons;

  /// No description provided for @barbers.
  ///
  /// In en, this message translates to:
  /// **'Barbers'**
  String get barbers;

  /// No description provided for @medspas.
  ///
  /// In en, this message translates to:
  /// **'Medspas'**
  String get medspas;

  /// No description provided for @noRatingYet.
  ///
  /// In en, this message translates to:
  /// **'No rating yet'**
  String get noRatingYet;

  /// No description provided for @bestMatch.
  ///
  /// In en, this message translates to:
  /// **'Best match'**
  String get bestMatch;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @onlyVerified.
  ///
  /// In en, this message translates to:
  /// **'Only verified'**
  String get onlyVerified;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @seeAllServices.
  ///
  /// In en, this message translates to:
  /// **'See all services'**
  String get seeAllServices;

  /// No description provided for @venuesNearby.
  ///
  /// In en, this message translates to:
  /// **'Venues nearby'**
  String get venuesNearby;

  /// No description provided for @reviewAndConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review and confirm'**
  String get reviewAndConfirm;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @withh.
  ///
  /// In en, this message translates to:
  /// **'with'**
  String get withh;

  /// No description provided for @discountCode.
  ///
  /// In en, this message translates to:
  /// **'Discount code'**
  String get discountCode;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get discounts;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get payNow;

  /// No description provided for @payAtVenue.
  ///
  /// In en, this message translates to:
  /// **'Pay at venue'**
  String get payAtVenue;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @cancellationPolicy1.
  ///
  /// In en, this message translates to:
  /// **'Cancellation policy'**
  String get cancellationPolicy1;

  /// No description provided for @cancellationPolicy2.
  ///
  /// In en, this message translates to:
  /// **'Please cancel at least '**
  String get cancellationPolicy2;

  /// No description provided for @cancellationPolicy3.
  ///
  /// In en, this message translates to:
  /// **'3 hours before'**
  String get cancellationPolicy3;

  /// No description provided for @cancellationPolicy4.
  ///
  /// In en, this message translates to:
  /// **' appointment.'**
  String get cancellationPolicy4;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Include comments or requests about your booking here.'**
  String get notesPlaceholder;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @addDiscount.
  ///
  /// In en, this message translates to:
  /// **'Add a discount'**
  String get addDiscount;

  /// No description provided for @discountCodePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter the discount or promo code you have.'**
  String get discountCodePlaceholder;

  /// No description provided for @continuee.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @recentlyViewed.
  ///
  /// In en, this message translates to:
  /// **'Recently viewed'**
  String get recentlyViewed;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @newToHealia.
  ///
  /// In en, this message translates to:
  /// **'New to Healia'**
  String get newToHealia;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @reviews1.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews1;

  /// No description provided for @reviews2.
  ///
  /// In en, this message translates to:
  /// **'review'**
  String get reviews2;

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter by'**
  String get filterBy;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @selectProfessional.
  ///
  /// In en, this message translates to:
  /// **'Select professional'**
  String get selectProfessional;

  /// No description provided for @noPreference.
  ///
  /// In en, this message translates to:
  /// **'No preference'**
  String get noPreference;

  /// No description provided for @forMaximumAvailability.
  ///
  /// In en, this message translates to:
  /// **'for maximum availability'**
  String get forMaximumAvailability;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get bookNow;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @openingTimes.
  ///
  /// In en, this message translates to:
  /// **'Opening times'**
  String get openingTimes;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional information'**
  String get additionalInformation;

  /// No description provided for @instantConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Instant confirmation'**
  String get instantConfirmation;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get directions'**
  String get getDirections;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @forYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get forYou;

  /// No description provided for @landingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Easy Search'**
  String get landingTitle1;

  /// No description provided for @landingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Find spas, hair salons, nail salons,... near you.'**
  String get landingDescription1;

  /// No description provided for @landingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Complete Beauty Package'**
  String get landingTitle2;

  /// No description provided for @landingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Book your nail, makeup, or tattoo appointment in an instant.'**
  String get landingDescription2;

  /// No description provided for @landingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Beautiful Hair Every Day'**
  String get landingTitle3;

  /// No description provided for @landingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Haircut, shampoo, blow-dry... at reputable salons.'**
  String get landingDescription3;

  /// No description provided for @landingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Shine Now'**
  String get landingTitle4;

  /// No description provided for @landingDescription4.
  ///
  /// In en, this message translates to:
  /// **'Start exploring and book your appointment today.'**
  String get landingDescription4;

  /// No description provided for @startExploring.
  ///
  /// In en, this message translates to:
  /// **'Start exploring'**
  String get startExploring;

  /// No description provided for @invalidDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid date format'**
  String get invalidDateFormat;

  /// No description provided for @editProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit profile details'**
  String get editProfileDetails;

  /// No description provided for @fullNameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Full name cannot be empty'**
  String get fullNameCannotBeEmpty;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @phoneNumberCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty'**
  String get phoneNumberCannotBeEmpty;

  /// No description provided for @invalidPhoneNumberFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get invalidPhoneNumberFormat;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Select option'**
  String get selectOption;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something wrong happened.'**
  String get somethingWentWrong;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get noFavorites;

  /// No description provided for @noFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your favorites list is empty. Let\'s fill it up!'**
  String get noFavoritesMessage;

  /// No description provided for @startSearching.
  ///
  /// In en, this message translates to:
  /// **'Start searching'**
  String get startSearching;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @newsletterSubscription.
  ///
  /// In en, this message translates to:
  /// **'We will send you updates about your appointments, news and offers from Healia.'**
  String get newsletterSubscription;

  /// No description provided for @appointmentNotifications.
  ///
  /// In en, this message translates to:
  /// **'Appointment notifications'**
  String get appointmentNotifications;

  /// No description provided for @textMessage.
  ///
  /// In en, this message translates to:
  /// **'Text message'**
  String get textMessage;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @forms.
  ///
  /// In en, this message translates to:
  /// **'Forms'**
  String get forms;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of\nthis account.'**
  String get logoutMessage;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @socialLogins.
  ///
  /// In en, this message translates to:
  /// **'Social logins'**
  String get socialLogins;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @termsAndPolicy.
  ///
  /// In en, this message translates to:
  /// **'Terms and policy'**
  String get termsAndPolicy;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @termsOfUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Healia terms of use'**
  String get termsOfUseTitle;

  /// No description provided for @termsOfUseHeader1.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get termsOfUseHeader1;

  /// No description provided for @termsOfUseBody1.
  ///
  /// In en, this message translates to:
  /// **'These are the terms and conditions of use for the Healia app (Terms) and all affiliated services. By using the Site or App, you agree to be bound by them.\n\n\n These terms apply strictly to your use of the Healia platform. They DO NOT apply to the third-party goods and services (e.g., nail, spa, and beauty services) available for booking on our App. The booking-related services are provided entirely by the independent Partner Salons.\','**
  String get termsOfUseBody1;

  /// No description provided for @termsOfUseHeader2.
  ///
  /// In en, this message translates to:
  /// **'1. Accessing our App'**
  String get termsOfUseHeader2;

  /// No description provided for @termsOfUseBody2.
  ///
  /// In en, this message translates to:
  /// **'We do not guarantee that our App, or any content on it, will always be available or be uninterrupted. We reserve the right to suspend, withdraw, or restrict the availability of all or any part of our App for business, operational, or maintenance reasons without prior notice.'**
  String get termsOfUseBody2;

  /// No description provided for @termsOfUseHeader3.
  ///
  /// In en, this message translates to:
  /// **'2. User Accounts & Security'**
  String get termsOfUseHeader3;

  /// No description provided for @termsOfUseBody3.
  ///
  /// In en, this message translates to:
  /// **'To access certain features, you must register for an account. You must provide accurate and complete information. If you choose, or you are provided with, a user identification code, password, or any other piece of information as part of our security procedures, you must treat such information as strictly confidential. You are solely responsible for all activities that occur under your account.'**
  String get termsOfUseBody3;

  /// No description provided for @termsOfUseHeader4.
  ///
  /// In en, this message translates to:
  /// **'3. Prohibited Activities'**
  String get termsOfUseHeader4;

  /// No description provided for @termsOfUseBody4.
  ///
  /// In en, this message translates to:
  /// **'You may use our App only for lawful purposes. You may not use our App in any way that breaches any applicable local, national, or international law or regulation; in any way that is unlawful or fraudulent; or to transmit, or procure the sending of, any unsolicited or unauthorized advertising or promotional material (spam).'**
  String get termsOfUseBody4;

  /// No description provided for @termsOfUseHeader5.
  ///
  /// In en, this message translates to:
  /// **'4. Intellectual Property'**
  String get termsOfUseHeader5;

  /// No description provided for @termsOfUseBody5.
  ///
  /// In en, this message translates to:
  /// **'We are the owner or the licensee of all intellectual property rights in our App, and in the material published on it. Those works are protected by copyright laws and treaties around the world. All such rights are reserved. You must not use any part of the content on our App for commercial purposes without obtaining a license to do so from us or our licensors.'**
  String get termsOfUseBody5;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Healia privacy policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyHeader1.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get privacyPolicyHeader1;

  /// No description provided for @privacyPolicyBody1.
  ///
  /// In en, this message translates to:
  /// **'At Healia, we are committed to protecting and respecting your privacy. This comprehensive policy explains how we collect, process, use, and share your personal data when you interact with our mobile application to discover and book beauty appointments. By using our app, you consent to the practices described in this policy. We encourage you to read it carefully to understand how we handle your information and your rights regarding your data.'**
  String get privacyPolicyBody1;

  /// No description provided for @privacyPolicyHeader2.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get privacyPolicyHeader2;

  /// No description provided for @privacyPolicyBody2.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly to us when creating an account, such as your full name, email address, phone number, profile picture, and demographic information. We also collect transactional data including your appointment history, preferred services, and interactions with Partner Salons. Additionally, we may collect technical data such as your device information, IP address, and app usage patterns to improve our services and ensure security.'**
  String get privacyPolicyBody2;

  /// No description provided for @privacyPolicyHeader3.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get privacyPolicyHeader3;

  /// No description provided for @privacyPolicyBody3.
  ///
  /// In en, this message translates to:
  /// **'Your data is primarily used to facilitate seamless bookings with our Partner Salons, send vital appointment reminders via push notifications, and process payments securely. Additionally, we may analyze aggregated usage data to troubleshoot software bugs, improve UX/UI design, and develop new platform features. We may also use your information to send you promotional offers and updates about our services, but only if you have opted in to receive such communications. You can manage your communication preferences in your account settings.'**
  String get privacyPolicyBody3;

  /// No description provided for @privacyPolicyHeader4.
  ///
  /// In en, this message translates to:
  /// **'3. Data Sharing and Third Parties'**
  String get privacyPolicyHeader4;

  /// No description provided for @privacyPolicyBody4.
  ///
  /// In en, this message translates to:
  /// **'When you book an appointment, we must share essential details (such as your name and phone number) with the specific Partner Salon to fulfill the service. We do not sell, rent, or trade your personal data to unauthorized third parties. We may use trusted third-party service providers (like Supabase and payment gateways) strictly to operate our business securely. These providers are contractually obligated to protect your data and use it only for the purposes we specify. We may also disclose your information if required by law or to protect our rights and safety.'**
  String get privacyPolicyBody4;

  /// No description provided for @privacyPolicyHeader5.
  ///
  /// In en, this message translates to:
  /// **'4. Data Security & Retention'**
  String get privacyPolicyHeader5;

  /// No description provided for @privacyPolicyBody5.
  ///
  /// In en, this message translates to:
  /// **'We implement robust technical and organizational security measures to protect your personal data from unauthorized access, alteration, disclosure, or destruction. We will only retain your personal data for as long as necessary to fulfill the purposes we collected it for, including for the purposes of satisfying any legal, accounting, or reporting requirements.'**
  String get privacyPolicyBody5;

  /// No description provided for @privacyPolicyHeader6.
  ///
  /// In en, this message translates to:
  /// **'5. Your Privacy Rights'**
  String get privacyPolicyHeader6;

  /// No description provided for @privacyPolicyBody6.
  ///
  /// In en, this message translates to:
  /// **'Depending on your jurisdiction, you have the right to request access to the personal data we hold about you, request corrections to inaccurate data, or request the deletion of your account and associated personal data through the App settings or by contacting our support team.'**
  String get privacyPolicyBody6;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Healia terms of service'**
  String get termsOfServiceTitle;

  /// No description provided for @termsOfServiceHeader1.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get termsOfServiceHeader1;

  /// No description provided for @termsOfServiceBody1.
  ///
  /// In en, this message translates to:
  /// **'These Terms of Service specifically govern the booking functionality, appointment management, and payments made through the Healia platform. By confirming a booking through our App, you enter into a legally binding contract directly with the Partner Salon.'**
  String get termsOfServiceBody1;

  /// No description provided for @termsOfServiceHeader2.
  ///
  /// In en, this message translates to:
  /// **'1. Booking Appointments'**
  String get termsOfServiceHeader2;

  /// No description provided for @termsOfServiceBody2.
  ///
  /// In en, this message translates to:
  /// **'The App allows you to browse, select, and book beauty services with Partner Salons. All bookings are subject to the availability of the Salon. You will receive an in-app notification and/or email confirming your booking status. The Salon reserves the right to accept, decline, or request modifications to your appointment.'**
  String get termsOfServiceBody2;

  /// No description provided for @termsOfServiceHeader3.
  ///
  /// In en, this message translates to:
  /// **'2. Cancellations and No-Shows'**
  String get termsOfServiceHeader3;

  /// No description provided for @termsOfServiceBody3.
  ///
  /// In en, this message translates to:
  /// **'We strictly enforce the cancellation policies set by each Partner Salon. If you need to cancel or reschedule, you must do so within the permitted time frame displayed during the booking process. Failure to show up for an appointment (No-Show) or canceling at the last minute negatively impacts the Salon\'s business and may result in a non-refundable cancellation fee charged to your account, or a temporary suspension of your booking privileges.'**
  String get termsOfServiceBody3;

  /// No description provided for @termsOfServiceHeader4.
  ///
  /// In en, this message translates to:
  /// **'3. Payments and Fees'**
  String get termsOfServiceHeader4;

  /// No description provided for @termsOfServiceBody4.
  ///
  /// In en, this message translates to:
  /// **'Certain Salons may require a deposit or full payment upfront to secure an appointment. All financial transactions made through the App are processed by secure, PCI-compliant third-party payment processors. Healia is not responsible for any overdraft fees or bank charges incurred from transactions.'**
  String get termsOfServiceBody4;

  /// No description provided for @termsOfServiceHeader5.
  ///
  /// In en, this message translates to:
  /// **'4. Quality of Service & Disclaimers'**
  String get termsOfServiceHeader5;

  /// No description provided for @termsOfServiceBody5.
  ///
  /// In en, this message translates to:
  /// **'Healia operates solely as a technology platform connecting users with independent beauty professionals. We do not employ the salon staff and are not responsible for the quality, safety, outcome, or exact timing of the services provided. Any disputes, claims for refunds, or complaints regarding the physical service, injuries, or allergic reactions must be resolved directly with the Partner Salon.'**
  String get termsOfServiceBody5;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @suggestedLanguage.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get suggestedLanguage;

  /// No description provided for @defaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'System default (English)'**
  String get defaultLanguage;

  /// No description provided for @allLanguages.
  ///
  /// In en, this message translates to:
  /// **'All languages'**
  String get allLanguages;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments'**
  String get noAppointments;

  /// No description provided for @noAppointmentsMessage.
  ///
  /// In en, this message translates to:
  /// **'Your upcoming and past appointments will\nappear here when you book your first one!'**
  String get noAppointmentsMessage;

  /// No description provided for @manageAppointments.
  ///
  /// In en, this message translates to:
  /// **'Log in or sign up to manage your upcoming and\npast appointments'**
  String get manageAppointments;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Log in or sign up'**
  String get loginSignUp;

  /// No description provided for @needSupport.
  ///
  /// In en, this message translates to:
  /// **'I already have a business account and need support'**
  String get needSupport;

  /// No description provided for @joinBusiness.
  ///
  /// In en, this message translates to:
  /// **'I\'m interested in joining Helia as a business'**
  String get joinBusiness;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get helpCenter;

  /// No description provided for @bookedAppointment.
  ///
  /// In en, this message translates to:
  /// **'I booked an appointment with a business on Helia'**
  String get bookedAppointment;

  /// No description provided for @accountSetup.
  ///
  /// In en, this message translates to:
  /// **'Account setup'**
  String get accountSetup;

  /// No description provided for @addonsIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Add-ons and integrations'**
  String get addonsIntegrations;

  /// No description provided for @billingFees.
  ///
  /// In en, this message translates to:
  /// **'Billing and fees'**
  String get billingFees;

  /// No description provided for @paymentsPayouts.
  ///
  /// In en, this message translates to:
  /// **'Payments and payouts'**
  String get paymentsPayouts;

  /// No description provided for @technicalSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical support'**
  String get technicalSupport;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @myAppointments.
  ///
  /// In en, this message translates to:
  /// **'My appointments'**
  String get myAppointments;

  /// No description provided for @paymentsPurchases.
  ///
  /// In en, this message translates to:
  /// **'Payments and purchases'**
  String get paymentsPurchases;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @nailSalon.
  ///
  /// In en, this message translates to:
  /// **'Nail salon'**
  String get nailSalon;

  /// No description provided for @barbershop.
  ///
  /// In en, this message translates to:
  /// **'Barbershop'**
  String get barbershop;

  /// No description provided for @beautySalon.
  ///
  /// In en, this message translates to:
  /// **'Beauty Salon'**
  String get beautySalon;

  /// No description provided for @imageSizeExceeded.
  ///
  /// In en, this message translates to:
  /// **'Image size exceeded. Please select an image smaller than 10MB.'**
  String get imageSizeExceeded;

  /// No description provided for @imageUploadError.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed. Please try again.'**
  String get imageUploadError;

  /// No description provided for @businessSupport.
  ///
  /// In en, this message translates to:
  /// **'Support mail for business account'**
  String get businessSupport;

  /// No description provided for @emailAppError.
  ///
  /// In en, this message translates to:
  /// **'Failed to open email app. Please try again.'**
  String get emailAppError;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected. Please choose an image to upload.'**
  String get noImageSelected;

  /// No description provided for @selectReason.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for contacting support.'**
  String get selectReason;

  /// No description provided for @pleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get pleaseSelect;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get emailUs;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help? *'**
  String get howCanWeHelp;

  /// No description provided for @enterEmail2.
  ///
  /// In en, this message translates to:
  /// **'If you have a Helia account, enter the email address you log in with'**
  String get enterEmail2;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailRequired;

  /// No description provided for @attachScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Attach screenshots'**
  String get attachScreenshots;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get chooseFile;

  /// No description provided for @fileType.
  ///
  /// In en, this message translates to:
  /// **'File type .jpg, .png • max size 10 MB'**
  String get fileType;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get sendEmail;

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Reason for contacting support *'**
  String get reasonRequired;

  /// No description provided for @describeYourIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe what you need help with *'**
  String get describeYourIssue;

  /// No description provided for @fullName2.
  ///
  /// In en, this message translates to:
  /// **'Full name *'**
  String get fullName2;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name *'**
  String get fullNameRequired;

  /// No description provided for @mobileNumber2.
  ///
  /// In en, this message translates to:
  /// **'Mobile number *'**
  String get mobileNumber2;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get businessName;

  /// No description provided for @businessNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Business name is required.'**
  String get businessNameRequired;

  /// No description provided for @businessType.
  ///
  /// In en, this message translates to:
  /// **'Business type *'**
  String get businessType;

  /// No description provided for @generalInquiry.
  ///
  /// In en, this message translates to:
  /// **'Is there anything in particular you want to know about Helia? *'**
  String get generalInquiry;

  /// No description provided for @queryDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide us with a description of your query, including your appointment reference, gift card code or invoice number *'**
  String get queryDescription;

  /// No description provided for @businessAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Required information mail for business account'**
  String get businessAccountInfo;

  /// No description provided for @selectBusinessType.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t selected a business type yet. Please select one to proceed.'**
  String get selectBusinessType;

  /// No description provided for @supportMail.
  ///
  /// In en, this message translates to:
  /// **'Support mail for account'**
  String get supportMail;

  /// No description provided for @needSupportAbout.
  ///
  /// In en, this message translates to:
  /// **'I need support about'**
  String get needSupportAbout;

  /// No description provided for @selectReasonType.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t selected a reason type yet. Please select one to proceed.'**
  String get selectReasonType;

  /// No description provided for @fillAllInformation.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t filled in all the information.'**
  String get fillAllInformation;

  /// No description provided for @confirmAppointment.
  ///
  /// In en, this message translates to:
  /// **'Confirm this appointment.'**
  String get confirmAppointment;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your appointment has been successfully booked'**
  String get bookingSuccess;

  /// No description provided for @slotBooked.
  ///
  /// In en, this message translates to:
  /// **'This time slot has just been booked by another customer. Please choose a different time!'**
  String get slotBooked;

  /// No description provided for @bookingFail.
  ///
  /// In en, this message translates to:
  /// **'Booking fail! Please try again later'**
  String get bookingFail;

  /// No description provided for @services2.
  ///
  /// In en, this message translates to:
  /// **'services'**
  String get services2;

  /// No description provided for @closeDay.
  ///
  /// In en, this message translates to:
  /// **'The store is closed on this day'**
  String get closeDay;

  /// No description provided for @errorCheckCalendar.
  ///
  /// In en, this message translates to:
  /// **'Error when checking for available calendar slots'**
  String get errorCheckCalendar;

  /// No description provided for @slotFull.
  ///
  /// In en, this message translates to:
  /// **'The store is full on this day'**
  String get slotFull;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @updateAppointmentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment updated successfully'**
  String get updateAppointmentSuccess;

  /// No description provided for @appointmentDetail.
  ///
  /// In en, this message translates to:
  /// **'Appointment detail'**
  String get appointmentDetail;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get createdAt;

  /// No description provided for @specialist.
  ///
  /// In en, this message translates to:
  /// **'Specialist'**
  String get specialist;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethods;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get yourReview;

  /// No description provided for @reviewAppointment.
  ///
  /// In en, this message translates to:
  /// **'Review appointment'**
  String get reviewAppointment;

  /// No description provided for @cancelAppointmentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get cancelAppointmentConfirmation;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancellation request'**
  String get cancelRequest;

  /// No description provided for @cancelRequest1.
  ///
  /// In en, this message translates to:
  /// **'This appointment is scheduled to take place soon. Please provide a reason for your cancellation request.'**
  String get cancelRequest1;

  /// No description provided for @reasonPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'E.g. Traffic jam, sudden illness...'**
  String get reasonPlaceholder;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @enterReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason'**
  String get enterReason;

  /// No description provided for @requestHasBeenSent.
  ///
  /// In en, this message translates to:
  /// **'Request has been sent'**
  String get requestHasBeenSent;

  /// No description provided for @anErrorOccurredWhenSendingRequest.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when sending request'**
  String get anErrorOccurredWhenSendingRequest;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @cancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment'**
  String get cancelAppointment;

  /// No description provided for @requestCancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Request cancel appointment'**
  String get requestCancelAppointment;

  /// No description provided for @rateYourAppointment.
  ///
  /// In en, this message translates to:
  /// **'Rate your appointment'**
  String get rateYourAppointment;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @enterYourComments.
  ///
  /// In en, this message translates to:
  /// **'Enter your comments or feedback...'**
  String get enterYourComments;

  /// No description provided for @currentlyYouDontHaveAnyAppointments.
  ///
  /// In en, this message translates to:
  /// **'Currently, you don\'t have any appointments.'**
  String get currentlyYouDontHaveAnyAppointments;

  /// No description provided for @editAppointment.
  ///
  /// In en, this message translates to:
  /// **'Edit Appointment'**
  String get editAppointment;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @noAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this date.'**
  String get noAvailableSlots;

  /// No description provided for @anySpecialRequests.
  ///
  /// In en, this message translates to:
  /// **'Any special requests...'**
  String get anySpecialRequests;

  /// No description provided for @saveChange.
  ///
  /// In en, this message translates to:
  /// **'Save change'**
  String get saveChange;

  /// No description provided for @personalAccount.
  ///
  /// In en, this message translates to:
  /// **'Personal account'**
  String get personalAccount;

  /// No description provided for @selectAccountType.
  ///
  /// In en, this message translates to:
  /// **'Select account type'**
  String get selectAccountType;

  /// No description provided for @accountSetupDescription.
  ///
  /// In en, this message translates to:
  /// **'This will help us set up your account correctly'**
  String get accountSetupDescription;

  /// No description provided for @independentAccount.
  ///
  /// In en, this message translates to:
  /// **'I\'m an independent'**
  String get independentAccount;

  /// No description provided for @teamAccount.
  ///
  /// In en, this message translates to:
  /// **'I have a team'**
  String get teamAccount;

  /// No description provided for @teamAccountExampleDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ll add \'Wendy\' as an example employee so you can see how the system works. You can manage employees later once you\'re in!'**
  String get teamAccountExampleDesc;

  /// No description provided for @calendarViews.
  ///
  /// In en, this message translates to:
  /// **'Calendar Views'**
  String get calendarViews;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @personalInfoUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Personal information updated successfully'**
  String get personalInfoUpdatedSuccessfully;

  /// No description provided for @failedToUpdateInfo.
  ///
  /// In en, this message translates to:
  /// **'Failed to update information: '**
  String get failedToUpdateInfo;

  /// No description provided for @editPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit personal information'**
  String get editPersonalInfo;

  /// No description provided for @dobRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get dobRequired;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @emailLoginDescription.
  ///
  /// In en, this message translates to:
  /// **'This email address is being used to log in to your account.'**
  String get emailLoginDescription;

  /// No description provided for @invalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmailAddress;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @appointmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Appointment Status'**
  String get appointmentStatus;

  /// No description provided for @booked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get booked;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @arrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrived;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @noShow.
  ///
  /// In en, this message translates to:
  /// **'No show'**
  String get noShow;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @partiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially paid'**
  String get partiallyPaid;

  /// No description provided for @fullyPaid.
  ///
  /// In en, this message translates to:
  /// **'Fully paid'**
  String get fullyPaid;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @vietnam.
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get vietnam;

  /// No description provided for @availableLanguages.
  ///
  /// In en, this message translates to:
  /// **'Available languages'**
  String get availableLanguages;

  /// No description provided for @unitedStates.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get unitedStates;

  /// No description provided for @personalArea.
  ///
  /// In en, this message translates to:
  /// **'Personal area'**
  String get personalArea;

  /// No description provided for @signInAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Sign in and security'**
  String get signInAndSecurity;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and support'**
  String get helpAndSupport;

  /// No description provided for @englishEn.
  ///
  /// In en, this message translates to:
  /// **'English (EN)'**
  String get englishEn;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **'day ago'**
  String get dayAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get hoursAgo;

  /// No description provided for @hourAgo.
  ///
  /// In en, this message translates to:
  /// **'hour ago'**
  String get hourAgo;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'minutes ago'**
  String get minutesAgo;

  /// No description provided for @minuteAgo.
  ///
  /// In en, this message translates to:
  /// **'minute ago'**
  String get minuteAgo;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @youDoNotHaveAnyNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'You do not have any notifications yet.'**
  String get youDoNotHaveAnyNotificationsYet;

  /// No description provided for @failedToLoadUserInfo.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user info'**
  String get failedToLoadUserInfo;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInformation;

  /// No description provided for @customizePersonalDetails.
  ///
  /// In en, this message translates to:
  /// **'Customize your personal details and how we can contact you.'**
  String get customizePersonalDetails;

  /// No description provided for @yourProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Your profile picture'**
  String get yourProfilePicture;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get personalDetails;

  /// No description provided for @keyInformationAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Key information about yourself that is displayed to others.'**
  String get keyInformationAboutYourself;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @loginAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Login & Security'**
  String get loginAndSecurity;

  /// No description provided for @updateYourPasswordAndSecureYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Update your password and secure your account.'**
  String get updateYourPasswordAndSecureYourAccount;

  /// No description provided for @loginDetails.
  ///
  /// In en, this message translates to:
  /// **'Login details'**
  String get loginDetails;

  /// No description provided for @socialMediaAccountsAreLinked.
  ///
  /// In en, this message translates to:
  /// **'Social media accounts are linked and passwords are used to log in.'**
  String get socialMediaAccountsAreLinked;

  /// No description provided for @yourAccountRegisteredThroughDifferentMethod.
  ///
  /// In en, this message translates to:
  /// **'Your account was registered through a different method.'**
  String get yourAccountRegisteredThroughDifferentMethod;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @errorConnectingGoogle.
  ///
  /// In en, this message translates to:
  /// **'Error connecting Google: '**
  String get errorConnectingGoogle;

  /// No description provided for @hiHowCanWeHelpYou.
  ///
  /// In en, this message translates to:
  /// **'Hi {userName}, how can we help you?'**
  String hiHowCanWeHelpYou(Object userName);

  /// No description provided for @usuallyRespondsWithin2Days.
  ///
  /// In en, this message translates to:
  /// **'Usually responds within 2 days.'**
  String get usuallyRespondsWithin2Days;

  /// No description provided for @phoneCall.
  ///
  /// In en, this message translates to:
  /// **'Phone call'**
  String get phoneCall;

  /// No description provided for @typicalResponseTimeIs2Minutes.
  ///
  /// In en, this message translates to:
  /// **'The typical response time is 2 minutes.'**
  String get typicalResponseTimeIs2Minutes;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add client'**
  String get addClient;

  /// No description provided for @addClientsToContinueCreateAppointment.
  ///
  /// In en, this message translates to:
  /// **'Add clients to continue create appointment.'**
  String get addClientsToContinueCreateAppointment;

  /// No description provided for @selectProfessionalForAppointment.
  ///
  /// In en, this message translates to:
  /// **'Select a professional for this appointment.'**
  String get selectProfessionalForAppointment;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professional;

  /// No description provided for @once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get once;

  /// No description provided for @addServicesToSaveAppointments.
  ///
  /// In en, this message translates to:
  /// **'Add services to save appointments.'**
  String get addServicesToSaveAppointments;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get addService;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @addAnotherService.
  ///
  /// In en, this message translates to:
  /// **'Add another service'**
  String get addAnotherService;

  /// No description provided for @haveToPay.
  ///
  /// In en, this message translates to:
  /// **'Have to pay'**
  String get haveToPay;

  /// No description provided for @updatedAppointmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Updated appointment status'**
  String get updatedAppointmentStatus;

  /// No description provided for @errorUpdatingAppointmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Error updating appointment status'**
  String get errorUpdatingAppointmentStatus;

  /// No description provided for @updatedPayment.
  ///
  /// In en, this message translates to:
  /// **'Updated payment'**
  String get updatedPayment;

  /// No description provided for @errorUpdatingPayment.
  ///
  /// In en, this message translates to:
  /// **'Error updating payment'**
  String get errorUpdatingPayment;

  /// No description provided for @couldNotLaunchPhoneApp.
  ///
  /// In en, this message translates to:
  /// **'Could not launch phone app'**
  String get couldNotLaunchPhoneApp;

  /// No description provided for @noPhoneNumberAvailable.
  ///
  /// In en, this message translates to:
  /// **'No phone number available'**
  String get noPhoneNumberAvailable;

  /// No description provided for @couldNotLaunchEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Could not launch email app'**
  String get couldNotLaunchEmailApp;

  /// No description provided for @noEmailAvailable.
  ///
  /// In en, this message translates to:
  /// **'No email available'**
  String get noEmailAvailable;

  /// No description provided for @professionalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Professional updated'**
  String get professionalUpdated;

  /// No description provided for @errorUpdatingProfessional.
  ///
  /// In en, this message translates to:
  /// **'Error updating professional'**
  String get errorUpdatingProfessional;

  /// No description provided for @timeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Time updated'**
  String get timeUpdated;

  /// No description provided for @errorUpdatingTime.
  ///
  /// In en, this message translates to:
  /// **'Error updating time'**
  String get errorUpdatingTime;

  /// No description provided for @updatedAppointmentServices.
  ///
  /// In en, this message translates to:
  /// **'Updated appointment services'**
  String get updatedAppointmentServices;

  /// No description provided for @errorUpdatingAppointmentServices.
  ///
  /// In en, this message translates to:
  /// **'Error updating appointment services'**
  String get errorUpdatingAppointmentServices;

  /// No description provided for @confirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Confirm cancel'**
  String get confirmCancel;

  /// No description provided for @sureToCancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get sureToCancelAppointment;

  /// No description provided for @refundedForThisCustomer.
  ///
  /// In en, this message translates to:
  /// **'Refunded for this customer'**
  String get refundedForThisCustomer;

  /// No description provided for @customerInfo.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER INFO'**
  String get customerInfo;

  /// No description provided for @timeAndProfessional.
  ///
  /// In en, this message translates to:
  /// **'TIME & PROFESSIONAL'**
  String get timeAndProfessional;

  /// No description provided for @appointmentStatusTracking.
  ///
  /// In en, this message translates to:
  /// **'APPOINTMENT STATUS'**
  String get appointmentStatusTracking;

  /// No description provided for @serviceDetails.
  ///
  /// In en, this message translates to:
  /// **'SERVICE DETAILS'**
  String get serviceDetails;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT'**
  String get payment;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @professionalPrefix.
  ///
  /// In en, this message translates to:
  /// **'Professional: '**
  String get professionalPrefix;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Status: Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusNoShow.
  ///
  /// In en, this message translates to:
  /// **'Status: No show'**
  String get statusNoShow;

  /// No description provided for @cancellationRequested.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Requested'**
  String get cancellationRequested;

  /// No description provided for @cancelReason.
  ///
  /// In en, this message translates to:
  /// **'Reason:'**
  String get cancelReason;

  /// No description provided for @noReasonProvided.
  ///
  /// In en, this message translates to:
  /// **'No reason provided'**
  String get noReasonProvided;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @btnCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get btnCompleted;

  /// No description provided for @noAvailableTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'No available time slots'**
  String get noAvailableTimeSlots;

  /// No description provided for @registrationNotComplete.
  ///
  /// In en, this message translates to:
  /// **'Registration not yet complete'**
  String get registrationNotComplete;

  /// No description provided for @registrationNotCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account has not yet completed store registration. Do you wish to continue the setup process?'**
  String get registrationNotCompleteDesc;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @setPhysicalLocation.
  ///
  /// In en, this message translates to:
  /// **'Set your venue\'s physical location'**
  String get setPhysicalLocation;

  /// No description provided for @addPrimaryBusinessLocation.
  ///
  /// In en, this message translates to:
  /// **'Add your primary business location so your clients can easily find you. Additional locations can be added later.'**
  String get addPrimaryBusinessLocation;

  /// No description provided for @whereIsBusinessLocated.
  ///
  /// In en, this message translates to:
  /// **'Where\'s your business located?'**
  String get whereIsBusinessLocated;

  /// No description provided for @postedOn.
  ///
  /// In en, this message translates to:
  /// **'Posted on '**
  String get postedOn;

  /// No description provided for @mostPopularMarketplace.
  ///
  /// In en, this message translates to:
  /// **'most popular \nmarketplace'**
  String get mostPopularMarketplace;

  /// No description provided for @toGrowYourBusiness.
  ///
  /// In en, this message translates to:
  /// **' to grow your business'**
  String get toGrowYourBusiness;

  /// No description provided for @getToKnowBusiness.
  ///
  /// In en, this message translates to:
  /// **'Let’s get to know your business'**
  String get getToKnowBusiness;

  /// No description provided for @shareBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Share some basic information like your business name, location, and opening hours'**
  String get shareBasicInfo;

  /// No description provided for @createOnlinePresence.
  ///
  /// In en, this message translates to:
  /// **'Create an online presence'**
  String get createOnlinePresence;

  /// No description provided for @addPhotosDescription.
  ///
  /// In en, this message translates to:
  /// **'Add photos of your location, choose a few highlights, and write a captivating description to make your profile more attractive'**
  String get addPhotosDescription;

  /// No description provided for @startAcceptingOnlineAppointments.
  ///
  /// In en, this message translates to:
  /// **'Start accepting online appointments'**
  String get startAcceptingOnlineAppointments;

  /// No description provided for @readyToAcceptAppointments.
  ///
  /// In en, this message translates to:
  /// **'With a complete profile, you’re ready to start accepting online appointments directly and on the Healio marketplace'**
  String get readyToAcceptAppointments;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @payWithStripe.
  ///
  /// In en, this message translates to:
  /// **'Pay with Stripe'**
  String get payWithStripe;

  /// No description provided for @marketplaceRegistrationFee.
  ///
  /// In en, this message translates to:
  /// **'Marketplace Registration Fee'**
  String get marketplaceRegistrationFee;

  /// No description provided for @registrationFeeDescription.
  ///
  /// In en, this message translates to:
  /// **'To publish your store on the Healio Marketplace and start accepting online appointments, a one-time registration fee is required. This fee covers platform onboarding and verification.'**
  String get registrationFeeDescription;

  /// No description provided for @registrationFee.
  ///
  /// In en, this message translates to:
  /// **'Registration Fee'**
  String get registrationFee;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @payAndPublishStore.
  ///
  /// In en, this message translates to:
  /// **'Pay & Publish Store'**
  String get payAndPublishStore;

  /// No description provided for @storePublishedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Store published successfully!'**
  String get storePublishedSuccessfully;

  /// No description provided for @paymentCanceled.
  ///
  /// In en, this message translates to:
  /// **'Payment canceled'**
  String get paymentCanceled;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed: '**
  String get paymentFailed;

  /// No description provided for @guideToLocationImages.
  ///
  /// In en, this message translates to:
  /// **'Guide to location images'**
  String get guideToLocationImages;

  /// No description provided for @highQualityImagesDescription.
  ///
  /// In en, this message translates to:
  /// **'High-quality images that highlight the beauty, comfort, and professionalism of your business are the best way to attract the attention of potential customers immediately. '**
  String get highQualityImagesDescription;

  /// No description provided for @acceptable.
  ///
  /// In en, this message translates to:
  /// **'Acceptable'**
  String get acceptable;

  /// No description provided for @clearImagesInterior.
  ///
  /// In en, this message translates to:
  /// **'Clear images of the interior of your space'**
  String get clearImagesInterior;

  /// No description provided for @atLeast3Images.
  ///
  /// In en, this message translates to:
  /// **'At least 3 images'**
  String get atLeast3Images;

  /// No description provided for @highResolutionImages.
  ///
  /// In en, this message translates to:
  /// **'High-resolution images (2727 x 1545)'**
  String get highResolutionImages;

  /// No description provided for @unacceptable.
  ///
  /// In en, this message translates to:
  /// **'Unacceptable'**
  String get unacceptable;

  /// No description provided for @stockPhotos.
  ///
  /// In en, this message translates to:
  /// **'Stock photos'**
  String get stockPhotos;

  /// No description provided for @brandLogosAndImages.
  ///
  /// In en, this message translates to:
  /// **'Brand logos and images'**
  String get brandLogosAndImages;

  /// No description provided for @closeUpPhotos.
  ///
  /// In en, this message translates to:
  /// **'Close-up photos of your products (e.g., nails, eyes)'**
  String get closeUpPhotos;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step1;

  /// No description provided for @tellUsAboutYourBusiness.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your business.'**
  String get tellUsAboutYourBusiness;

  /// No description provided for @provideBasicInformation.
  ///
  /// In en, this message translates to:
  /// **'Provide basic information about your business, including your name, contact phone number, email address, and location. This information helps customers understand you better and contact you when they need assistance.'**
  String get provideBasicInformation;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get step2;

  /// No description provided for @introduceUniqueness.
  ///
  /// In en, this message translates to:
  /// **'Introduce the uniqueness of the location'**
  String get introduceUniqueness;

  /// No description provided for @makeProfileVibrant.
  ///
  /// In en, this message translates to:
  /// **'Make your profile vibrant and outstanding with eye-catching photos and unique descriptions. Highlight the special features of your business to attract and impress customers.'**
  String get makeProfileVibrant;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'Step 3'**
  String get step3;

  /// No description provided for @allowOnlineBooking.
  ///
  /// In en, this message translates to:
  /// **'Allow online booking on Healio marketplace'**
  String get allowOnlineBooking;

  /// No description provided for @newClients.
  ///
  /// In en, this message translates to:
  /// **'New clients'**
  String get newClients;

  /// No description provided for @byEnablingOnlineBooking.
  ///
  /// In en, this message translates to:
  /// **'By enabling online booking on Healio, your location will be published for customers to discover through the Healio marketplace, allowing them to book your services directly. '**
  String get byEnablingOnlineBooking;

  /// No description provided for @acceptOnlineAppointments.
  ///
  /// In en, this message translates to:
  /// **'Accept online appointments on Healio marketplace'**
  String get acceptOnlineAppointments;

  /// No description provided for @withCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'With a complete profile, you are ready to start receiving online appointments directly and on the Healio marketplace.'**
  String get withCompleteProfile;

  /// No description provided for @tellUsAboutThisPlace.
  ///
  /// In en, this message translates to:
  /// **'Please tell us a little bit about this place.'**
  String get tellUsAboutThisPlace;

  /// No description provided for @effectiveDescriptions.
  ///
  /// In en, this message translates to:
  /// **'The most effective descriptions help to present key details about the business and highlight the unique features of the location in order to attract and engage customers.'**
  String get effectiveDescriptions;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @provideShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide a short description of the location'**
  String get provideShortDescription;

  /// No description provided for @minimum200Characters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 200 characters required.'**
  String get minimum200Characters;

  /// No description provided for @businessInformation.
  ///
  /// In en, this message translates to:
  /// **'Business information'**
  String get businessInformation;

  /// No description provided for @pleaseProvideBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Please provide basic information about your business.'**
  String get pleaseProvideBasicInfo;

  /// No description provided for @enterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Enter business name'**
  String get enterBusinessName;

  /// No description provided for @pleaseEnterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Please enter business name'**
  String get pleaseEnterBusinessName;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get enterEmailAddress;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enterAddress;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get pleaseEnterAddress;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get saveAndContinue;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get deletePhoto;

  /// No description provided for @pleaseSelectAtLeast3Photos.
  ///
  /// In en, this message translates to:
  /// **'Please select at least 3 photos.'**
  String get pleaseSelectAtLeast3Photos;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// No description provided for @addCoverAndGalleryPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add cover photo and up to 9 photos for your photo library.'**
  String get addCoverAndGalleryPhotos;

  /// No description provided for @photoFormatRequirement.
  ///
  /// In en, this message translates to:
  /// **'Format: .jpg, .png • Max: 10 MB'**
  String get photoFormatRequirement;

  /// No description provided for @addCoverPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add cover photo'**
  String get addCoverPhoto;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get choosePhoto;

  /// No description provided for @coverPhoto.
  ///
  /// In en, this message translates to:
  /// **'Cover photo'**
  String get coverPhoto;

  /// No description provided for @selectCategoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Select categories that best describe your business'**
  String get selectCategoriesDescription;

  /// No description provided for @choosePrimaryAndRelated.
  ///
  /// In en, this message translates to:
  /// **'Choose your primary and up to 3 related service type'**
  String get choosePrimaryAndRelated;

  /// No description provided for @categorySelectionLimit.
  ///
  /// In en, this message translates to:
  /// **'You can only choose 1 main service and a maximum of 1 secondary services'**
  String get categorySelectionLimit;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @whatIsBusinessName.
  ///
  /// In en, this message translates to:
  /// **'What\'s your business name?'**
  String get whatIsBusinessName;

  /// No description provided for @brandNameDescription.
  ///
  /// In en, this message translates to:
  /// **'This is the brand name your clients will see. Your billing and legal name can be added later.'**
  String get brandNameDescription;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website '**
  String get website;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get optional;

  /// No description provided for @howDidYouHearAboutFresha.
  ///
  /// In en, this message translates to:
  /// **'How did you hear about Healia?'**
  String get howDidYouHearAboutFresha;

  /// No description provided for @recommendedByFriend.
  ///
  /// In en, this message translates to:
  /// **'Recommended by a friend'**
  String get recommendedByFriend;

  /// No description provided for @searchEngine.
  ///
  /// In en, this message translates to:
  /// **'Search engine (e.g. Google, Bing)'**
  String get searchEngine;

  /// No description provided for @socialMedia.
  ///
  /// In en, this message translates to:
  /// **'Social media'**
  String get socialMedia;

  /// No description provided for @advertInMail.
  ///
  /// In en, this message translates to:
  /// **'Advert in the mail'**
  String get advertInMail;

  /// No description provided for @magazineAd.
  ///
  /// In en, this message translates to:
  /// **'Magazine ad'**
  String get magazineAd;

  /// No description provided for @ratingsWebsite.
  ///
  /// In en, this message translates to:
  /// **'Ratings website (e.g. Capterra, Trustpilot)'**
  String get ratingsWebsite;

  /// No description provided for @aiChatbot.
  ///
  /// In en, this message translates to:
  /// **'AI Chatbot (e.g. ChatGPT, Gemini, DeepSeek)'**
  String get aiChatbot;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @storeIsBeingSetUp.
  ///
  /// In en, this message translates to:
  /// **'Your store is being set up...'**
  String get storeIsBeingSetUp;

  /// No description provided for @whatIsTeamSize.
  ///
  /// In en, this message translates to:
  /// **'What\'s your team size?'**
  String get whatIsTeamSize;

  /// No description provided for @twoToFivePeople.
  ///
  /// In en, this message translates to:
  /// **'2-5 people'**
  String get twoToFivePeople;

  /// No description provided for @sixToTenPeople.
  ///
  /// In en, this message translates to:
  /// **'6-10 people'**
  String get sixToTenPeople;

  /// No description provided for @elevenPlusPeople.
  ///
  /// In en, this message translates to:
  /// **'11+ people'**
  String get elevenPlusPeople;

  /// No description provided for @forProfessionals.
  ///
  /// In en, this message translates to:
  /// **'Healia for professionals'**
  String get forProfessionals;

  /// No description provided for @loginToManageBusiness.
  ///
  /// In en, this message translates to:
  /// **'Create an account or log in to manage your business.'**
  String get loginToManageBusiness;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @addNewClient.
  ///
  /// In en, this message translates to:
  /// **'Add new client'**
  String get addNewClient;

  /// No description provided for @managingClientPersonalProfile.
  ///
  /// In en, this message translates to:
  /// **'Managing client personal profile'**
  String get managingClientPersonalProfile;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @egHan.
  ///
  /// In en, this message translates to:
  /// **'Eg: Han'**
  String get egHan;

  /// No description provided for @egTran.
  ///
  /// In en, this message translates to:
  /// **'Eg: Tran'**
  String get egTran;

  /// No description provided for @egPhone.
  ///
  /// In en, this message translates to:
  /// **'Eg: 123 456 7890'**
  String get egPhone;

  /// No description provided for @exampleDomain.
  ///
  /// In en, this message translates to:
  /// **'example@domain.com'**
  String get exampleDomain;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @selectOne.
  ///
  /// In en, this message translates to:
  /// **'Select one'**
  String get selectOne;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @unknownService.
  ///
  /// In en, this message translates to:
  /// **'Unknown Service'**
  String get unknownService;

  /// No description provided for @clientDetails.
  ///
  /// In en, this message translates to:
  /// **'Client details'**
  String get clientDetails;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @allFilters.
  ///
  /// In en, this message translates to:
  /// **'All filters'**
  String get allFilters;

  /// No description provided for @nameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get nameAZ;

  /// No description provided for @nameZA.
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get nameZA;

  /// No description provided for @creationDateOldest.
  ///
  /// In en, this message translates to:
  /// **'Creation date (oldest first)'**
  String get creationDateOldest;

  /// No description provided for @creationDateNewest.
  ///
  /// In en, this message translates to:
  /// **'Creation date (newest first)'**
  String get creationDateNewest;

  /// No description provided for @clientsList.
  ///
  /// In en, this message translates to:
  /// **'Clients list'**
  String get clientsList;

  /// No description provided for @manageClientsDesc.
  ///
  /// In en, this message translates to:
  /// **'View, add, edit and delete your client\'s details.'**
  String get manageClientsDesc;

  /// No description provided for @searchClientsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter name or email to search'**
  String get searchClientsHint;

  /// No description provided for @noClientsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No clients available.'**
  String get noClientsAvailable;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get exportData;

  /// No description provided for @exportedClientList.
  ///
  /// In en, this message translates to:
  /// **'Exported Client List'**
  String get exportedClientList;

  /// No description provided for @deleteClient.
  ///
  /// In en, this message translates to:
  /// **'Delete Client'**
  String get deleteClient;

  /// No description provided for @confirmDeleteClient.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this client?'**
  String get confirmDeleteClient;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @editClientInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit client information'**
  String get editClientInfo;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviewsYet;

  /// No description provided for @noCustomerReviewsDesc.
  ///
  /// In en, this message translates to:
  /// **'No customer reviews have been left yet.'**
  String get noCustomerReviewsDesc;

  /// No description provided for @noComment.
  ///
  /// In en, this message translates to:
  /// **'No comment'**
  String get noComment;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @noTransactionsDesc.
  ///
  /// In en, this message translates to:
  /// **'No transactions have been created with this customer'**
  String get noTransactionsDesc;

  /// No description provided for @appointmentPayment.
  ///
  /// In en, this message translates to:
  /// **'Appointment payment'**
  String get appointmentPayment;

  /// No description provided for @secondName.
  ///
  /// In en, this message translates to:
  /// **'Second Name'**
  String get secondName;

  /// No description provided for @egPhone2.
  ///
  /// In en, this message translates to:
  /// **'Eg: +84 234 567 8901'**
  String get egPhone2;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @newService.
  ///
  /// In en, this message translates to:
  /// **'New service'**
  String get newService;

  /// No description provided for @basicDetails.
  ///
  /// In en, this message translates to:
  /// **'Basic details'**
  String get basicDetails;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get serviceName;

  /// No description provided for @addServiceNameHint.
  ///
  /// In en, this message translates to:
  /// **'Add service name, e.g. Men\'s haircut'**
  String get addServiceNameHint;

  /// No description provided for @menuCategory.
  ///
  /// In en, this message translates to:
  /// **'Menu category'**
  String get menuCategory;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @categoryDisplayDesc.
  ///
  /// In en, this message translates to:
  /// **'The category displayed for you and your clients online'**
  String get categoryDisplayDesc;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @addShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a short description'**
  String get addShortDescription;

  /// No description provided for @pricingAndDuration.
  ///
  /// In en, this message translates to:
  /// **'Pricing and duration'**
  String get pricingAndDuration;

  /// No description provided for @selectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select duration'**
  String get selectDuration;

  /// No description provided for @serviceNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Service name cannot be empty'**
  String get serviceNameEmptyError;

  /// No description provided for @selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategoryError;

  /// No description provided for @validPriceError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get validPriceError;

  /// No description provided for @selectDurationError.
  ///
  /// In en, this message translates to:
  /// **'Please select duration'**
  String get selectDurationError;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @last3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get last3Months;

  /// No description provided for @last6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get last6Months;

  /// No description provided for @lastYear.
  ///
  /// In en, this message translates to:
  /// **'Last year'**
  String get lastYear;

  /// No description provided for @customDate.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customDate;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @csvHeaderAppointments.
  ///
  /// In en, this message translates to:
  /// **'Ref. No.,Client,Staff,Status,Created date,Service,Duration,Time slot,Net sales\n'**
  String get csvHeaderAppointments;

  /// No description provided for @noService.
  ///
  /// In en, this message translates to:
  /// **'No Service'**
  String get noService;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @exportedAppointmentsList.
  ///
  /// In en, this message translates to:
  /// **'Exported Appointments List'**
  String get exportedAppointmentsList;

  /// No description provided for @csv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get csv;

  /// No description provided for @appointmentList.
  ///
  /// In en, this message translates to:
  /// **'Appointment list'**
  String get appointmentList;

  /// No description provided for @completeListOfBookedAppointments.
  ///
  /// In en, this message translates to:
  /// **'Complete list of booked appointments.'**
  String get completeListOfBookedAppointments;

  /// No description provided for @refNo.
  ///
  /// In en, this message translates to:
  /// **'Ref. No.'**
  String get refNo;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created date'**
  String get createdDate;

  /// No description provided for @timeSlot.
  ///
  /// In en, this message translates to:
  /// **'Time slot'**
  String get timeSlot;

  /// No description provided for @netSales.
  ///
  /// In en, this message translates to:
  /// **'Net sales'**
  String get netSales;

  /// No description provided for @appointmentSummary.
  ///
  /// In en, this message translates to:
  /// **'Appointment Summary'**
  String get appointmentSummary;

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View report'**
  String get viewReport;

  /// No description provided for @vsCompPeriod.
  ///
  /// In en, this message translates to:
  /// **'vs comp period'**
  String get vsCompPeriod;

  /// No description provided for @notCompleted.
  ///
  /// In en, this message translates to:
  /// **'Not completed'**
  String get notCompleted;

  /// No description provided for @noShows.
  ///
  /// In en, this message translates to:
  /// **'No shows'**
  String get noShows;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @editBusinessDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit business details'**
  String get editBusinessDetails;

  /// No description provided for @businessInfo.
  ///
  /// In en, this message translates to:
  /// **'Business info'**
  String get businessInfo;

  /// No description provided for @editBusinessInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the name displayed on your online booking profile, sales receipts and messages to clients.'**
  String get editBusinessInfoDesc;

  /// No description provided for @enterBusinessNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a business name'**
  String get enterBusinessNameError;

  /// No description provided for @storeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Store not found'**
  String get storeNotFound;

  /// No description provided for @businessDetails.
  ///
  /// In en, this message translates to:
  /// **'Business details'**
  String get businessDetails;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @vietNam.
  ///
  /// In en, this message translates to:
  /// **'Viet Nam'**
  String get vietNam;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @vnd.
  ///
  /// In en, this message translates to:
  /// **'VND'**
  String get vnd;

  /// No description provided for @teamDefaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'Team default language'**
  String get teamDefaultLanguage;

  /// No description provided for @vietnameseVI.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese (VI)'**
  String get vietnameseVI;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @manageLocationInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage info and preferences of locations within your business.'**
  String get manageLocationInfoDesc;

  /// No description provided for @noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYet;

  /// No description provided for @editLocation.
  ///
  /// In en, this message translates to:
  /// **'Edit location'**
  String get editLocation;

  /// No description provided for @enterAddressError.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get enterAddressError;

  /// No description provided for @provinceCity.
  ///
  /// In en, this message translates to:
  /// **'Province / City'**
  String get provinceCity;

  /// No description provided for @enterProvinceError.
  ///
  /// In en, this message translates to:
  /// **'Please enter province'**
  String get enterProvinceError;

  /// No description provided for @loadDataError.
  ///
  /// In en, this message translates to:
  /// **'Load data error'**
  String get loadDataError;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get openingHours;

  /// No description provided for @openingHoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Opening hours are the default working hours for your team and will be displayed to your customers.'**
  String get openingHoursDesc;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @editHoliday.
  ///
  /// In en, this message translates to:
  /// **'Edit holiday'**
  String get editHoliday;

  /// No description provided for @addHoliday.
  ///
  /// In en, this message translates to:
  /// **'Add holiday'**
  String get addHoliday;

  /// No description provided for @holidayName.
  ///
  /// In en, this message translates to:
  /// **'Holiday name'**
  String get holidayName;

  /// No description provided for @enterHolidayName.
  ///
  /// In en, this message translates to:
  /// **'Enter holiday name'**
  String get enterHolidayName;

  /// No description provided for @enterHolidayNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter holiday name'**
  String get enterHolidayNameError;

  /// No description provided for @holidayDate.
  ///
  /// In en, this message translates to:
  /// **'Holiday date'**
  String get holidayDate;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @holidaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Holiday schedule'**
  String get holidaySchedule;

  /// No description provided for @holidayScheduleDesc.
  ///
  /// In en, this message translates to:
  /// **'Business closing times for events such as holidays.'**
  String get holidayScheduleDesc;

  /// No description provided for @noHolidaysFound.
  ///
  /// In en, this message translates to:
  /// **'No holidays found'**
  String get noHolidaysFound;

  /// No description provided for @holiday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get holiday;

  /// No description provided for @businessSetup.
  ///
  /// In en, this message translates to:
  /// **'Business setup'**
  String get businessSetup;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// No description provided for @storePictures.
  ///
  /// In en, this message translates to:
  /// **'Store Pictures'**
  String get storePictures;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @singleService.
  ///
  /// In en, this message translates to:
  /// **'Single service'**
  String get singleService;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanently;

  /// No description provided for @serviceMenu.
  ///
  /// In en, this message translates to:
  /// **'Service menu'**
  String get serviceMenu;

  /// No description provided for @serviceMenuDesc.
  ///
  /// In en, this message translates to:
  /// **'View and manage the services offered by your business.'**
  String get serviceMenuDesc;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @searchServiceName.
  ///
  /// In en, this message translates to:
  /// **'Search service name'**
  String get searchServiceName;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No services found.'**
  String get noServicesFound;

  /// No description provided for @categoryUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get categoryUpdatedSuccess;

  /// No description provided for @categoryAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Category added successfully'**
  String get categoryAddedSuccess;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description...'**
  String get enterDescription;

  /// No description provided for @customerSummary.
  ///
  /// In en, this message translates to:
  /// **'Customer Summary'**
  String get customerSummary;

  /// No description provided for @newCustomers.
  ///
  /// In en, this message translates to:
  /// **'New Customers'**
  String get newCustomers;

  /// No description provided for @onlineBookings.
  ///
  /// In en, this message translates to:
  /// **'Online bookings'**
  String get onlineBookings;

  /// No description provided for @walkIns.
  ///
  /// In en, this message translates to:
  /// **'Walk-ins'**
  String get walkIns;

  /// No description provided for @editStaff.
  ///
  /// In en, this message translates to:
  /// **'Edit Staff'**
  String get editStaff;

  /// No description provided for @addStaff.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get addStaff;

  /// No description provided for @managingEmployeeRecords.
  ///
  /// In en, this message translates to:
  /// **'Managing employee personal records'**
  String get managingEmployeeRecords;

  /// No description provided for @fullNameIsRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameIsRequiredError;

  /// No description provided for @emailIsRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequiredError;

  /// No description provided for @enterValidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmailError;

  /// No description provided for @birthDay.
  ///
  /// In en, this message translates to:
  /// **'Birth day'**
  String get birthDay;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get jobTitle;

  /// No description provided for @displayToOnlineCustomers.
  ///
  /// In en, this message translates to:
  /// **'Display to online customers'**
  String get displayToOnlineCustomers;

  /// No description provided for @jobDetails.
  ///
  /// In en, this message translates to:
  /// **'Job details'**
  String get jobDetails;

  /// No description provided for @manageEmployeeJobDetails.
  ///
  /// In en, this message translates to:
  /// **'Manage employee start dates and job details.'**
  String get manageEmployeeJobDetails;

  /// No description provided for @addPersonalNotesDesc.
  ///
  /// In en, this message translates to:
  /// **'Add personal notes that are only visible to the employee list.'**
  String get addPersonalNotesDesc;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change image'**
  String get changeImage;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete image'**
  String get deleteImage;

  /// No description provided for @updateLocationPictures.
  ///
  /// In en, this message translates to:
  /// **'Update location pictures'**
  String get updateLocationPictures;

  /// No description provided for @fileTypeAndSizeInfo.
  ///
  /// In en, this message translates to:
  /// **'File types: .jpg, .png • Minimum size: 916x500 pixels • Maximum size: 10 MB'**
  String get fileTypeAndSizeInfo;

  /// No description provided for @addYourPicture.
  ///
  /// In en, this message translates to:
  /// **'Add your picture'**
  String get addYourPicture;

  /// No description provided for @chooseAFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get chooseAFile;

  /// No description provided for @coverImage.
  ///
  /// In en, this message translates to:
  /// **'Cover image'**
  String get coverImage;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Save error'**
  String get saveError;

  /// No description provided for @editOpeningHours.
  ///
  /// In en, this message translates to:
  /// **'Edit opening hours'**
  String get editOpeningHours;

  /// No description provided for @openingHoursDesc2.
  ///
  /// In en, this message translates to:
  /// **'They are displayed on your marketplace profile but do not affect scheduled work shifts.'**
  String get openingHoursDesc2;

  /// No description provided for @toTime.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get toTime;

  /// No description provided for @financeSummary.
  ///
  /// In en, this message translates to:
  /// **'Finance Summary'**
  String get financeSummary;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @grossSales.
  ///
  /// In en, this message translates to:
  /// **'Gross sales'**
  String get grossSales;

  /// No description provided for @refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refunds;

  /// No description provided for @addToWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Add to workspace'**
  String get addToWorkspace;

  /// No description provided for @catalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalog;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @businessSettings.
  ///
  /// In en, this message translates to:
  /// **'Business settings'**
  String get businessSettings;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @reportSummary.
  ///
  /// In en, this message translates to:
  /// **'Report summary'**
  String get reportSummary;

  /// No description provided for @reportSummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Overview of your business.'**
  String get reportSummaryDesc;

  /// No description provided for @appointmentSummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Overview of your scheduled appointments and bookings.'**
  String get appointmentSummaryDesc;

  /// No description provided for @financeSummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Dashboard of your financial performance and revenue.'**
  String get financeSummaryDesc;

  /// No description provided for @customerSummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Key metrics and insights about your customer base.'**
  String get customerSummaryDesc;

  /// No description provided for @appointmentListDesc.
  ///
  /// In en, this message translates to:
  /// **'Detailed list of all past and upcoming appointments.'**
  String get appointmentListDesc;

  /// No description provided for @transactionList.
  ///
  /// In en, this message translates to:
  /// **'Transaction list'**
  String get transactionList;

  /// No description provided for @transactionListDesc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive record of all business transactions.'**
  String get transactionListDesc;

  /// No description provided for @recentSales.
  ///
  /// In en, this message translates to:
  /// **'Recent sales'**
  String get recentSales;

  /// No description provided for @sevenDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'7 days ago'**
  String get sevenDaysAgo;

  /// No description provided for @paymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentLabel;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming appointments'**
  String get upcomingAppointments;

  /// No description provided for @next7Days.
  ///
  /// In en, this message translates to:
  /// **'Next 7 days'**
  String get next7Days;

  /// No description provided for @yourScheduleIsFree.
  ///
  /// In en, this message translates to:
  /// **'Your schedule is free'**
  String get yourScheduleIsFree;

  /// No description provided for @createAppointmentsToDisplay.
  ///
  /// In en, this message translates to:
  /// **'Create some appointments to show data schedule'**
  String get createAppointmentsToDisplay;

  /// No description provided for @appointmentActivities.
  ///
  /// In en, this message translates to:
  /// **'Appointment activities'**
  String get appointmentActivities;

  /// No description provided for @noActivitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No activities found'**
  String get noActivitiesFound;

  /// No description provided for @todaysNextAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s next appointments'**
  String get todaysNextAppointments;

  /// No description provided for @noAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'There are no appointments today'**
  String get noAppointmentsToday;

  /// No description provided for @accessSection.
  ///
  /// In en, this message translates to:
  /// **'Access section '**
  String get accessSection;

  /// No description provided for @toAddAppointments.
  ///
  /// In en, this message translates to:
  /// **' to add some appointments'**
  String get toAddAppointments;

  /// No description provided for @unknownCustomer.
  ///
  /// In en, this message translates to:
  /// **'Unknown Customer'**
  String get unknownCustomer;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @deleteStaff.
  ///
  /// In en, this message translates to:
  /// **'Delete Staff'**
  String get deleteStaff;

  /// No description provided for @confirmDeleteStaff.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this staff?'**
  String get confirmDeleteStaff;

  /// No description provided for @staffDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Staff deleted successfully'**
  String get staffDeletedSuccessfully;

  /// No description provided for @searchStaff.
  ///
  /// In en, this message translates to:
  /// **'Search staff'**
  String get searchStaff;

  /// No description provided for @noStaffFound.
  ///
  /// In en, this message translates to:
  /// **'No staff found.'**
  String get noStaffFound;

  /// No description provided for @jobTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get jobTitleLabel;

  /// No description provided for @workInformation.
  ///
  /// In en, this message translates to:
  /// **'Work Information'**
  String get workInformation;

  /// No description provided for @employmentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Employment Period'**
  String get employmentPeriod;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @employmentType.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get employmentType;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @employeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeId;

  /// No description provided for @locationImages.
  ///
  /// In en, this message translates to:
  /// **'Location images'**
  String get locationImages;

  /// No description provided for @storePicturesTip.
  ///
  /// In en, this message translates to:
  /// **'Profiles with more than 5 images will rank higher in marketplace searches and receive up to 50% more appointments. You can add up to 10 high-quality images to your profile.'**
  String get storePicturesTip;

  /// No description provided for @storePicturesRequirements.
  ///
  /// In en, this message translates to:
  /// **'File types: .jpg, .png • Minimum size: 916x500 pixels • Maximum size: 10 MB'**
  String get storePicturesRequirements;

  /// No description provided for @addYourImage.
  ///
  /// In en, this message translates to:
  /// **'Add your image'**
  String get addYourImage;

  /// No description provided for @selectAFile.
  ///
  /// In en, this message translates to:
  /// **'Select a file'**
  String get selectAFile;

  /// No description provided for @last7days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7days;

  /// No description provided for @last30days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30days;

  /// No description provided for @last3months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get last3months;

  /// No description provided for @last6months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get last6months;

  /// No description provided for @transactionCode.
  ///
  /// In en, this message translates to:
  /// **'Transaction code'**
  String get transactionCode;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction date'**
  String get transactionDate;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @exportedTransactionsList.
  ///
  /// In en, this message translates to:
  /// **'Exported Transactions List'**
  String get exportedTransactionsList;

  /// No description provided for @errorExportingData.
  ///
  /// In en, this message translates to:
  /// **'Error exporting data: '**
  String get errorExportingData;

  /// No description provided for @completeListTransactions.
  ///
  /// In en, this message translates to:
  /// **'Complete list of business transactions.'**
  String get completeListTransactions;

  /// No description provided for @walkIn.
  ///
  /// In en, this message translates to:
  /// **'Walk-in'**
  String get walkIn;

  /// No description provided for @editServices.
  ///
  /// In en, this message translates to:
  /// **'Edit services'**
  String get editServices;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// No description provided for @confirmRefund.
  ///
  /// In en, this message translates to:
  /// **'Confirm Refund'**
  String get confirmRefund;

  /// No description provided for @areYouSureYouWantToRefundThisTransaction.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to refund this transaction?'**
  String get areYouSureYouWantToRefundThisTransaction;

  /// No description provided for @noAvailableProfessionalsForThisTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'No available professionals for this time slot.'**
  String get noAvailableProfessionalsForThisTimeSlot;

  /// No description provided for @changeDate.
  ///
  /// In en, this message translates to:
  /// **'Change Date'**
  String get changeDate;

  /// No description provided for @selectService.
  ///
  /// In en, this message translates to:
  /// **'Select Service'**
  String get selectService;

  /// No description provided for @searchByServiceName.
  ///
  /// In en, this message translates to:
  /// **'Search by service name'**
  String get searchByServiceName;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Appointment Requests'**
  String get requests;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @cancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get cancellation;

  /// No description provided for @noRequestsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No requests available'**
  String get noRequestsAvailable;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @servicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'services available'**
  String get servicesAvailable;
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
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
