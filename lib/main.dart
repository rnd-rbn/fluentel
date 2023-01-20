import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluentel',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('es', '')],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Fluentel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late Uri _urlFluentelPhone;
  late String fluentelPhoneNumber;
  late Uri _urlFluentelMentorForm;
  late String fluentelMentorForm;
  String targetCountry = 'Unknown';
  String targetPopulation = 'Unknown';
  String myLanguage = 'Unknown';
  String centsPerMinute = '?';
  String supportEmail = 'support@fluen.tel';
  late Contact newContact;

  Timer? timer;
  int timerDuration = 7;

  Future<void> _launchUrlFluentelPhone() async {
    if (!await launchUrl(_urlFluentelPhone)) {
      throw 'Could not launch $_urlFluentelPhone';
    }
  }

  Future<void> _launchUrlFluentelMentorForm() async {
    if (!await launchUrl(_urlFluentelMentorForm)) {
      throw 'Could not launch $_urlFluentelMentorForm';
    }
  }

  @override
  void initState() {
    super.initState();
    setTimer();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String? alpha2;

    try {
      alpha2 = await FlutterSimCountryCode.simCountryCode;
    } on PlatformException {
      alpha2 = 'Failed to get sim country code.';
    }

    switch (alpha2?.toLowerCase()) {
      case 'us':
        fluentelPhoneNumber = '+15407823352';
        fluentelMentorForm = 'https://call.fluen.tel/mentor-usa';
        targetCountry = AppLocalizations.of(context)!.mexico;
        targetPopulation = AppLocalizations.of(context)!.mexicans;
        myLanguage = AppLocalizations.of(context)!.english;
        supportEmail = 'support@fluen.tel';
        centsPerMinute = '12';
        break;
      case 'mx':
        fluentelPhoneNumber = '+525592257010';
        fluentelMentorForm = 'https://call.fluen.tel/mentor-mex';
        targetCountry = AppLocalizations.of(context)!.unitedStates;
        targetPopulation = AppLocalizations.of(context)!.americans;
        myLanguage = AppLocalizations.of(context)!.spanish;
        supportEmail = 'ayuda@fluen.tel';
        centsPerMinute = '6';
        break;
      default:
        fluentelPhoneNumber = '+15014442436';
        fluentelMentorForm = 'https://www.fluen.tel';
        targetCountry = AppLocalizations.of(context)!.unknownCountry;
        targetPopulation = AppLocalizations.of(context)!.unknownPopulation;
        myLanguage = AppLocalizations.of(context)!.unknownLanguage;
        supportEmail = 'support@fluen.tel';
        centsPerMinute = '¯\\_(ツ)_/¯';
    }

    if (!mounted) return;

    setState(() {
      _urlFluentelPhone = Uri.parse('tel:$fluentelPhoneNumber');
      _urlFluentelMentorForm = Uri.parse(fluentelMentorForm);
    });
  }

  setTimer() {
    timer = Timer(Duration(seconds: timerDuration), () => updateTimerDuration());
  }

  updateTimerDuration() {
    timer?.cancel();
    setState(() {
      timerDuration = 7 == timerDuration ? 3 : 7;
    });
    setTimer();
  }

  callToActionText(int timerDuration) {
    if (7 == timerDuration) {
      return [
        const WidgetSpan(child: Icon(Icons.person_search_outlined), alignment: PlaceholderAlignment.middle),
        const TextSpan(text: ' '),
        TextSpan(text: AppLocalizations.of(context)!.tapToFindALanguagePartner),
      ];
    } else {
      return [
        const WidgetSpan(child: Icon(Icons.volunteer_activism_outlined), alignment: PlaceholderAlignment.middle),
        const TextSpan(text: ' '),
        TextSpan(text: AppLocalizations.of(context)!.tapToHelpOthers(targetPopulation, myLanguage)),
      ];
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  initContact() async {
    final ByteData bytes = await rootBundle.load('assets/launch_icon_iOS.png');
    final Uint8List fluentelAvatar = bytes.buffer.asUint8List();

    Contact _newContact = Contact(
      company: 'Fluentel',
      avatar: fluentelAvatar,
      emails: [
        Item(label: 'work', value: supportEmail),
      ],
      phones: [
        Item(label: 'work', value: fluentelPhoneNumber),
      ],
    );

    newContact = _newContact;
  }

  findOrAddContact() async {
    List<Contact> _contacts = await ContactsService.getContactsForPhone(fluentelPhoneNumber);

    if (_contacts.isEmpty) {
      await initContact();
      await ContactsService.addContact(newContact);
      var _snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.contactAdded));
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    } else {
      var _snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.contactAlreadyExists));
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }
  }

  handleAddContact() async {
    var status = await Permission.contacts.status;

    switch (status) {
      case PermissionStatus.denied:
        if (await Permission.contacts.request().isGranted) {
          findOrAddContact();
        }
        break;
      case PermissionStatus.granted:
        findOrAddContact();
        break;
      case PermissionStatus.restricted:
        var _snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.contactRestricted));
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
        break;
      case PermissionStatus.permanentlyDenied:
        var _snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.contactPermanentlyDenied));
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
        openAppSettings();
        break;
      default:
        var _snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.sorrySomethingWentWrong));
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_repeat),
            tooltip: AppLocalizations.of(context)!.tooltipSetMentoringSchedule,
            onPressed: () {
              try {
                _launchUrlFluentelMentorForm();
              } catch (e) {
                print("Caught error: $e");
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: AppLocalizations.of(context)!.tooltipAddToContacts,
            onPressed: () {
              try {
                handleAddContact();
              } catch (e) {
                print("Caught error: $e");
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                AppLocalizations.of(context)!.frequentlyAskedQuestions,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: AppLocalizations.of(context)!.faqWhatHappensWhenICallAnswer,
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.faqWhatHappensWhenICall),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: AppLocalizations.of(context)!.faqHowDoISearchForALanguagePartnerAnswer,
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.faqHowDoISearchForALanguagePartner),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: AppLocalizations.of(context)!.faqHowDoIMessageALanguagePartnerAnswer,
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.faqHowDoIMessageALanguagePartner),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: AppLocalizations.of(context)!.faqHowMuchDoesItCostAnswer(centsPerMinute),
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.faqHowMuchDoesItCost),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: AppLocalizations.of(context)!.faqHowCanIHelpAnswer(targetCountry),
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.faqHowCanIHelp(targetCountry, myLanguage)),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: 'www.fluen.tel',
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.faqWhereCanILearnMore),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: 'https://call.fluen.tel/github',
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.faqWhereIsTheCode),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: callToActionText(timerDuration),
                      ),
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FloatingActionButton.large(
                      onPressed: _launchUrlFluentelPhone,
                      tooltip: AppLocalizations.of(context)!.call,
                      child: const Icon(Icons.phone),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
