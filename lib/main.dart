import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DebugScreen(),
    theme: ThemeData.dark(),
  ));
}

class DebugScreen extends StatefulWidget {
  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  late final WebViewController controller;
  String durumMesaji = "Başlatılıyor...";
  bool hataVarMi = false;

  @override
  void initState() {
    super.initState();
    izinIste();

    // TEST İÇİN GOOGLE'I KULLANIYORUZ
    String testLink = 'https://www.google.com';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFF0000)) // Arka plan KIRMIZI (Test için)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              durumMesaji = "Yükleniyor: $url";
            });
          },
          onPageFinished: (String url) {
            setState(() {
              durumMesaji = ""; // Yüklendi, yazıyı kaldır
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              hataVarMi = true;
              durumMesaji = "HATA: ${error.description}";
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(testLink));
  }

  Future<void> izinIste() async {
    await Permission.microphone.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // En arka plan siyah
      body: SafeArea(
        child: Stack(
          children: [
            // 1. KATMAN: WEB SİTESİ
            WebViewWidget(controller: controller),
            
            // 2. KATMAN: BİLGİ EKRANI (Sadece yüklenirken veya hata varsa görünür)
            if (durumMesaji.isNotEmpty)
              Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: hataVarMi ? Colors.red : Colors.black54,
                  child: Text(
                    durumMesaji,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
