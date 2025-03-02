

import 'package:acomplus/common_function/common_snackbar_message.dart';
import 'package:acomplus/common_function/internet_connection_checker.dart';
import 'package:acomplus/view/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final WebViewController _webViewController = WebViewController();
  bool isLoading = true;
  bool hasInternetConnection = true;
  List<String> link = [];

  internetCheckerFunction() async {
    setState(() {});
    isLoading = true;
    hasInternetConnection = true;
    bool status = await ConnectionChecker.checkConnection();
    await Future.delayed(const Duration(seconds: 1));
    hasInternetConnection = status;
    if (hasInternetConnection) {
      _loadWebView(appUrl: widget.url);
    } else {
      CommonSnackBarMessage.noInternetConnection();
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    internetCheckerFunction();
    if (_webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_webViewController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
  }

  void _loadWebView({required String appUrl, bool? isBack}) async {
    try {
      _webViewController
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {
              if (isBack != null && isBack == true) {
                link.removeLast();
                debugPrint("----------  Remove  Remove Remove Remove Remove  Remove -----------");
              } else {
                link.add(appUrl);
                link.removeWhere((element) => element == url);
                debugPrint("----------  Add Add Add Add Add Add Add Add Add Add Add Add-----------");
              }
            },
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(appUrl));
      setState(() {});
    } catch (e) {
      debugPrint('===============================================Error loading web view: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (link.isNotEmpty) {
          debugPrint("=================   Link  ${link.length}     ============= ");
          _loadWebView(appUrl: link.last, isBack: true);
        } else {
          debugPrint("+++++++++++++++++++++       Popup   ============= ");
          Get.defaultDialog(
            title: 'Confirmation',
            titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            content: const Text('Do you want to exit the APP ?'),
            actions: [
              GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  SystemNavigator.pop();
                },
                child: Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
      child: isLoading  
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  
                   Image.asset("asset/loading.gif",height: 100,width: 100,fit: BoxFit.cover, ),

                    const SizedBox(height: 20),
                    const Text(
                      "Please Wait...",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            )
          : hasInternetConnection
              ? Scaffold(
                  appBar: const CustomAppBar(
                    
                    height: 50,
                    child: Text(""),
                  ),
                  body: WebViewWidget(controller: _webViewController),
                )
              : Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          color: Colors.red,
                        ),
                        const Text(
                          "Please ,Check Internet Connection",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height / 3,
                        ),
                        InkWell(
                            onTap: () {
                              internetCheckerFunction();
                            },
                            child: const Icon(Icons.refresh)),
                        const Text(
                          "Reload ",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height / 10,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
