import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentRedirectView extends StatelessWidget {
  final String url;

  const PaymentRedirectView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: WebViewWidget(
        controller:
            WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onNavigationRequest: (nav) {
                    if (nav.url.contains("success") ||
                        nav.url.contains("paid")) {
                      Navigator.pop(context); // Close WebView
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Payment completed successfully"),
                        ),
                      );
                    } else if (nav.url.contains("failed")) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment failed")),
                      );
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
