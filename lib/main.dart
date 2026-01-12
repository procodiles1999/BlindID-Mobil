import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlindWebScreen(),
    theme: ThemeData.dark(),
  ));
}

class BlindWebScreen extends StatefulWidget {
  @override
  _BlindWebScreenState createState() => _BlindWebScreenState();
}

class _BlindWebScreenState extends State<BlindWebScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    izinIste();
    
    // BURAYA KENDİ LİNKİNİ YAPIŞTIR
    String siteLink = 'https://blind-id-server--procodiles3.replit.app'; 

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            print('Sayfa Yüklendi: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Hata oluştu: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(siteLink));
  }

  Future<void> izinIste() async {
    await Permission.microphone.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
