import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

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
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @lang.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get lang;

  /// No description provided for @locale.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get locale;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add an Image'**
  String get addImage;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send a message...'**
  String get sendMessage;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an Account'**
  String get alreadyHaveAccount;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

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

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @useful.
  ///
  /// In en, this message translates to:
  /// **'Useful'**
  String get useful;

  /// No description provided for @futile.
  ///
  /// In en, this message translates to:
  /// **'Futile'**
  String get futile;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @createYourEvent.
  ///
  /// In en, this message translates to:
  /// **'Create your event !'**
  String get createYourEvent;

  /// No description provided for @createThisEvent.
  ///
  /// In en, this message translates to:
  /// **'Create this event'**
  String get createThisEvent;

  /// No description provided for @nameOfEvent.
  ///
  /// In en, this message translates to:
  /// **'Event\'s name'**
  String get nameOfEvent;

  /// No description provided for @modifyYourEvent.
  ///
  /// In en, this message translates to:
  /// **'Modify your event'**
  String get modifyYourEvent;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @noMessagesForNow.
  ///
  /// In en, this message translates to:
  /// **'No messages for now.'**
  String get noMessagesForNow;

  /// No description provided for @noEventsForNow.
  ///
  /// In en, this message translates to:
  /// **'No events for now.'**
  String get noEventsForNow;

  /// No description provided for @noLocationForNow.
  ///
  /// In en, this message translates to:
  /// **'No location for now.'**
  String get noLocationForNow;

  /// No description provided for @noUsersForNow.
  ///
  /// In en, this message translates to:
  /// **'No users for now.'**
  String get noUsersForNow;

  /// No description provided for @nobodyFound.
  ///
  /// In en, this message translates to:
  /// **'Nobody found.'**
  String get nobodyFound;

  /// No description provided for @failedToConnect.
  ///
  /// In en, this message translates to:
  /// **'You didn\'t make it and we don\'t know why'**
  String get failedToConnect;

  /// No description provided for @validEmailPlease.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email.'**
  String get validEmailPlease;

  /// No description provided for @minLetter.
  ///
  /// In en, this message translates to:
  /// **'At lease {number} characters minimum'**
  String minLetter(Object number);

  /// No description provided for @errorPlaceHolder.
  ///
  /// In en, this message translates to:
  /// **'You\'ve got into some trouble: '**
  String get errorPlaceHolder;

  /// No description provided for @waitHere.
  ///
  /// In en, this message translates to:
  /// **'Wait !'**
  String get waitHere;

  /// No description provided for @reallyWantToDelete.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this event ?'**
  String get reallyWantToDelete;

  /// No description provided for @reallyWantToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete your account ? It won\'t be possible to recover it.\n'**
  String get reallyWantToDeleteAccount;

  /// No description provided for @adminChat.
  ///
  /// In en, this message translates to:
  /// **'King\'s chat'**
  String get adminChat;

  /// No description provided for @staffChat.
  ///
  /// In en, this message translates to:
  /// **'Chat with us'**
  String get staffChat;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting location...'**
  String get gettingLocation;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get chooseIcon;

  /// No description provided for @greatChoice.
  ///
  /// In en, this message translates to:
  /// **'Great choice !'**
  String get greatChoice;

  /// No description provided for @maxNumberPeople.
  ///
  /// In en, this message translates to:
  /// **'Max number of people : '**
  String get maxNumberPeople;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @eventType.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get eventType;

  /// No description provided for @organizedBy.
  ///
  /// In en, this message translates to:
  /// **' organized by '**
  String get organizedBy;

  /// No description provided for @createNewEvent.
  ///
  /// In en, this message translates to:
  /// **'Create a new event'**
  String get createNewEvent;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get chooseDate;

  /// No description provided for @chooseLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose a location'**
  String get chooseLocation;

  /// No description provided for @yourPos.
  ///
  /// In en, this message translates to:
  /// **'Your position'**
  String get yourPos;

  /// No description provided for @searchFriend.
  ///
  /// In en, this message translates to:
  /// **'Search a friend !'**
  String get searchFriend;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @deleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get deleteForever;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @addUsersToEvent.
  ///
  /// In en, this message translates to:
  /// **'Add users to your event !'**
  String get addUsersToEvent;

  /// No description provided for @removeUsersToEvent.
  ///
  /// In en, this message translates to:
  /// **'Remove users to your event'**
  String get removeUsersToEvent;

  /// No description provided for @addUsers.
  ///
  /// In en, this message translates to:
  /// **'Add users'**
  String get addUsers;

  /// No description provided for @removeUsers.
  ///
  /// In en, this message translates to:
  /// **'Remove users'**
  String get removeUsers;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get added;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'removed'**
  String get removed;

  /// No description provided for @infinity.
  ///
  /// In en, this message translates to:
  /// **'Infinity'**
  String get infinity;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @meet.
  ///
  /// In en, this message translates to:
  /// **'Meet'**
  String get meet;

  /// No description provided for @putLinkIfYouWant.
  ///
  /// In en, this message translates to:
  /// **'Give access to links if you want'**
  String get putLinkIfYouWant;

  /// No description provided for @pickAnIcon.
  ///
  /// In en, this message translates to:
  /// **'Pick an Icon'**
  String get pickAnIcon;

  /// No description provided for @searchInEnglish.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchInEnglish;

  /// No description provided for @pleasePickAnImage.
  ///
  /// In en, this message translates to:
  /// **'Please pick an image'**
  String get pleasePickAnImage;

  /// No description provided for @howGoodMemory.
  ///
  /// In en, this message translates to:
  /// **'How good is your memory ?'**
  String get howGoodMemory;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @signInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInGoogle;

  /// No description provided for @signInApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInApple;

  /// No description provided for @leaveEvent.
  ///
  /// In en, this message translates to:
  /// **'Leave the event'**
  String get leaveEvent;
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
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
