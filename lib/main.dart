import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late Uri _url;
  String targetLanguage = 'Unknown';
  String targetCountry = 'Unknown';
  String targetPopulation = 'Unknown';
  String myLanguage = 'Unknown';
  String centsPerMinute = '?';
  late Contact newContact;

  Timer? timer;
  int timerDuration = 7;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    super.initState();
    setTimer();
    initPlatformState();
    initContact();
  }

  Future<void> initPlatformState() async {
    String? alpha2;
    String? fluentelPhoneNumber;

    try {
      alpha2 = await FlutterSimCountryCode.simCountryCode;
    } on PlatformException {
      alpha2 = 'Failed to get sim country code.';
    }

    switch (alpha2?.toLowerCase()) {
      case 'us':
        fluentelPhoneNumber = '+1-540-782-3352';
        targetLanguage = AppLocalizations.of(context)!.spanish;
        targetCountry = AppLocalizations.of(context)!.mexico;
        targetPopulation = AppLocalizations.of(context)!.mexicans;
        myLanguage = AppLocalizations.of(context)!.english;
        centsPerMinute = '12';
        break;
      case 'mx':
        fluentelPhoneNumber = '+52-55-9225-7010';
        targetLanguage = AppLocalizations.of(context)!.english;
        targetCountry = AppLocalizations.of(context)!.unitedStates;
        targetPopulation = AppLocalizations.of(context)!.americans;
        myLanguage = AppLocalizations.of(context)!.spanish;
        centsPerMinute = '6';
        break;
      default:
        fluentelPhoneNumber = '+1-501-444-2436';
        targetLanguage = AppLocalizations.of(context)!.unknownLanguage;
        targetCountry = AppLocalizations.of(context)!.unknownCountry;
        targetPopulation = AppLocalizations.of(context)!.unknownPopulation;
        myLanguage = AppLocalizations.of(context)!.unknownLanguage;
        centsPerMinute = '¯\\_(ツ)_/¯';
    }

    if (!mounted) return;

    setState(() {
      _url = Uri.parse('tel:$fluentelPhoneNumber');
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
      company: 'ACME',
      avatar: fluentelAvatar,
      emails: [
        Item(label: 'work', value: 'support@fluen.tel'),
      ],
      phones: [
        Item(label: 'work', value: '+15407823352'),
      ],
    );

    newContact = _newContact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add to Contacts',
            onPressed: () async {
              //TODO: add explicit Permission handling for Android
              // https://stackoverflow.com/questions/57969216/getting-this-error-unhandled-exception-formatexception-invalid-envelope-wh
              try {
                await ContactsService.addContact(newContact);
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
              message: AppLocalizations.of(context)!.faqAppOnlyCallsANumberAnswer(targetLanguage, targetCountry),
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.faqAppOnlyCallsANumber),
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
                      onPressed: _launchUrl,
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
