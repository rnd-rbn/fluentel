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

class _MyHomePageState extends State<MyHomePage> {
  late Uri _url;
  String targetLanguage = 'Unknown';
  String targetCountry = 'Unknown';
  String myLanguage = 'Unknown';
  String centsPerMinute = '?';

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
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
        myLanguage = AppLocalizations.of(context)!.english;
        centsPerMinute = '12';
        break;
      case 'mx':
        fluentelPhoneNumber = '+52-55-9225-7010';
        targetLanguage = AppLocalizations.of(context)!.english;
        targetCountry = AppLocalizations.of(context)!.unitedStates;
        myLanguage = AppLocalizations.of(context)!.spanish;
        centsPerMinute = '6';
        break;
      default:
        fluentelPhoneNumber = '+1-501-444-2436';
        targetLanguage = AppLocalizations.of(context)!.unknownLanguage;
        targetCountry = AppLocalizations.of(context)!.unknownCountry;
        myLanguage = AppLocalizations.of(context)!.unknownLanguage;
        centsPerMinute = '¯\\_(ツ)_/¯';
    }

    if (!mounted) return;

    setState(() {
      _url = Uri.parse('tel:$fluentelPhoneNumber');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.tapToFindALanguagePartner,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              FloatingActionButton.large(
                onPressed: _launchUrl,
                tooltip: AppLocalizations.of(context)!.call,
                child: const Icon(Icons.phone),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
