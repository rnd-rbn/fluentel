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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Call Fluentel',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchUrl,
        tooltip: 'Call',
        child: const Icon(Icons.phone),
      ),
    );
  }
}
