import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluentel',
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

    switch (alpha2) {
      case 'us':
        fluentelPhoneNumber = '+1-540-782-3352';
        break;
      case 'mx':
        fluentelPhoneNumber = '+52-55-9225-7010';
        break;
      default:
        fluentelPhoneNumber = '+1-501-444-2436';
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
                'Frequently Asked Questions',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: '''
Yes! Fluentel is a language partner phone hotline. Call the phone number any
time you want to practice speaking Spanish and it will try to connect you with
a native Spanish speaker from Mexico.
              '''
                  .replaceAll("\n", " "),
              child: const ListTile(
                title: Text('All this app does is dial a phone number?'),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: '''
First, verify your phone number. Then you have two options: 1.
find a language partner, or 2. sign up to help others.
              '''
                  .replaceAll("\n", " "),
              child: const ListTile(
                title: Text('What happens when I call Fluentel?'),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: '''
You don't! Fluentel finds a language partner for you.
              '''
                  .replaceAll("\n", " "),
              child: const ListTile(
                title: Text('How do I search for a language partner?'),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: '''
You don't! Skip the courtship and get straight to the action. Fluentel gets you
speaking faster than any language exchange app or service.
              '''
                  .replaceAll("\n", " "),
              child: const ListTile(
                title: Text('How do I message a language partner?'),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: '''
Your first 60 minutes are free, and then 12 cents per minute after that. You can
purchase minutes directly over the phone in a secure PCI-compliant environment.
              '''
                  .replaceAll("\n", " "),
              child: const ListTile(
                title: Text('How much does it cost?'),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: '''
When you call the Fluentel hotline, choose the option to set your availability.
You will provide your timezone and a daily 3-hour availability window.
Then, when someone from Mexico calls Fluentel during your availability window,
we will text you asking if you'd like to help them. Reply to that text message
to be connected. If you're busy at that time, simply ignore the text message.
              '''
                  .replaceAll("\n", " "),
              child: const ListTile(
                title: Text('How can I help people from Mexico practice English?'),
              ),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 60),
              message: '''
www.fluen.tel
              '''
                  .replaceAll("\n", " "),
              child: const ListTile(
                title: Text('Where can I learn more?'),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tap to find a language partner',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 32,
            ),
            FloatingActionButton.large(
              onPressed: _launchUrl,
              tooltip: 'Call',
              child: const Icon(Icons.phone),
            ),
          ],
        ),
      ),
    );
  }
}
