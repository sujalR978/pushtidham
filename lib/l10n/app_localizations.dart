import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

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
    Locale('gu'),
    Locale('hi'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Pustidham'**
  String get app_title;

  /// No description provided for @welcome_tagline.
  ///
  /// In en, this message translates to:
  /// **'Jai Shree Krishna'**
  String get welcome_tagline;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to Divinity...'**
  String get connecting;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @continue_btn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_btn;

  /// No description provided for @search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search content...'**
  String get search_placeholder;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get nav_favorites;

  /// No description provided for @nav_notes.
  ///
  /// In en, this message translates to:
  /// **'Personal Notes'**
  String get nav_notes;

  /// No description provided for @nav_gallery.
  ///
  /// In en, this message translates to:
  /// **'Media Gallery'**
  String get nav_gallery;

  /// No description provided for @nav_offline.
  ///
  /// In en, this message translates to:
  /// **'Offline Content'**
  String get nav_offline;

  /// No description provided for @nav_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get nav_settings;

  /// No description provided for @grid_about_mahaprabhuji.
  ///
  /// In en, this message translates to:
  /// **'About Shri Mahaprabhuji'**
  String get grid_about_mahaprabhuji;

  /// No description provided for @grid_bethakji_list.
  ///
  /// In en, this message translates to:
  /// **'Shri Mahaprabhuji Bethakji List'**
  String get grid_bethakji_list;

  /// No description provided for @grid_kirtan.
  ///
  /// In en, this message translates to:
  /// **'Kirtan'**
  String get grid_kirtan;

  /// No description provided for @grid_pathavali.
  ///
  /// In en, this message translates to:
  /// **'Pathavali (Shodash Granth)'**
  String get grid_pathavali;

  /// No description provided for @grid_jap_mala.
  ///
  /// In en, this message translates to:
  /// **'Jap Mala Counter'**
  String get grid_jap_mala;

  /// No description provided for @grid_calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar (Tippani)'**
  String get grid_calendar;

  /// No description provided for @grid_84_vaishnav.
  ///
  /// In en, this message translates to:
  /// **'84 Vaishnav Varta'**
  String get grid_84_vaishnav;

  /// No description provided for @grid_84_vaishnav_vraj.
  ///
  /// In en, this message translates to:
  /// **'84 Vaishnav Varta (Vraj Bhasha)'**
  String get grid_84_vaishnav_vraj;

  /// No description provided for @grid_252_vaishnav.
  ///
  /// In en, this message translates to:
  /// **'252 Vaishnav Varta'**
  String get grid_252_vaishnav;

  /// No description provided for @grid_review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get grid_review;

  /// No description provided for @grid_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get grid_contact;

  /// No description provided for @theme_settings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get theme_settings;

  /// No description provided for @theme_system.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get theme_system;

  /// No description provided for @theme_day.
  ///
  /// In en, this message translates to:
  /// **'Saffron Dawn (Day)'**
  String get theme_day;

  /// No description provided for @theme_night.
  ///
  /// In en, this message translates to:
  /// **'Midnight Dhyaan (Night)'**
  String get theme_night;

  /// No description provided for @theme_mandir.
  ///
  /// In en, this message translates to:
  /// **'Sandstone Mandir (Traditional)'**
  String get theme_mandir;

  /// No description provided for @jap_active_mantra.
  ///
  /// In en, this message translates to:
  /// **'Active Mantra'**
  String get jap_active_mantra;

  /// No description provided for @jap_default_mantra.
  ///
  /// In en, this message translates to:
  /// **'Shri Krishna Sharanam Mamah'**
  String get jap_default_mantra;

  /// No description provided for @jap_bead_count.
  ///
  /// In en, this message translates to:
  /// **'Beads'**
  String get jap_bead_count;

  /// No description provided for @jap_total_mala.
  ///
  /// In en, this message translates to:
  /// **'Total Mala'**
  String get jap_total_mala;

  /// No description provided for @jap_tap_here.
  ///
  /// In en, this message translates to:
  /// **'TAP HERE'**
  String get jap_tap_here;

  /// No description provided for @jap_reset_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Counter?'**
  String get jap_reset_title;

  /// No description provided for @jap_reset_msg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset the counter to zero?'**
  String get jap_reset_msg;

  /// No description provided for @jap_completed_msg.
  ///
  /// In en, this message translates to:
  /// **'Jai Shree Krishna! 1 Mala completed. 🙏'**
  String get jap_completed_msg;

  /// No description provided for @btn_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get btn_submit;

  /// No description provided for @btn_open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get btn_open;

  /// No description provided for @btn_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get btn_delete;

  /// No description provided for @btn_read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get btn_read;

  /// No description provided for @btn_play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get btn_play;

  /// No description provided for @btn_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get btn_yes;

  /// No description provided for @btn_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get btn_no;

  /// No description provided for @btn_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get btn_undo;

  /// No description provided for @mahaprabhuji_bio_p1.
  ///
  /// In en, this message translates to:
  /// **'Shri Vallabhacharyaji Mahaprabhuji is the founder of Pushtimarg, the Path of Divine Grace. According to Pushtimarg tradition, He incarnated on Earth by the divine command of Bhagwan Shri Krishna to guide souls toward loving devotion, selfless seva, and complete surrender. His philosophy of Shuddhadvaita Brahmavad emphasizes that Bhagwan\'s grace is the highest means of attaining spiritual bliss.'**
  String get mahaprabhuji_bio_p1;

  /// No description provided for @mahaprabhuji_bio_p2.
  ///
  /// In en, this message translates to:
  /// **'Born on Chaitra Vad Ekadashi, Vikram Samvat 1535 (1479 CE) in Champaranya, Shri Mahaprabhuji was the son of Shri Lakshman Bhatt and Shrimati Illammagaru. Even as a child, He displayed extraordinary wisdom and mastered the Vedas, Upanishads, Puranas, and various philosophical traditions by the age of eleven. His remarkable knowledge and devotion earned Him great respect throughout India.'**
  String get mahaprabhuji_bio_p2;

  /// No description provided for @mahaprabhuji_bio_p3.
  ///
  /// In en, this message translates to:
  /// **'Throughout His life, Shri Mahaprabhuji travelled across India three times on foot, spreading the message of Pushtimarg and establishing the philosophy of Shuddhadvaita. He guided countless devotees through the sacred initiation of Brahmasambandh, teaching that true devotion begins with complete surrender of one\'s body, mind, wealth, and soul to Shri Krishna. His teachings continue to inspire devotees to perform seva with love, humility, and unwavering faith.'**
  String get mahaprabhuji_bio_p3;

  /// No description provided for @mahaprabhuji_bio_p4.
  ///
  /// In en, this message translates to:
  /// **'Shri Mahaprabhuji also composed many sacred scriptures, including the Shodash Granth, Shri Yamunashtakam, Siddhanta Rahasya, and Subodhiniji, which remain the foundation of Pushtimarg philosophy. Despite being honoured by kings and scholars, He lived a life of simplicity, dedicating every moment to Bhagwan and the spiritual upliftment of devotees.'**
  String get mahaprabhuji_bio_p4;

  /// No description provided for @mahaprabhuji_bio_p5.
  ///
  /// In en, this message translates to:
  /// **'After completing His divine mission, Shri Mahaprabhuji accepted the path of renunciation and spent His final days in Kashi. On Rath Yatra of Vikram Samvat 1587, at the age of 52, He entered the sacred River Ganga. According to Pushtimarg tradition, His divine form merged into a radiant light, signifying His return to the eternal abode of Bhagwan Shri Krishna. His life remains a timeless source of devotion, wisdom, and divine grace for followers of Pushtimarg around the world.'**
  String get mahaprabhuji_bio_p5;
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
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
