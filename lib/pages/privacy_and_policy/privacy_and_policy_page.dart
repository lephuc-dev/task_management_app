import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../resources/resources.dart';

class PrivacyAndPolicyPage extends StatefulWidget {
  const PrivacyAndPolicyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyAndPolicyPage> createState() => _PrivacyAndPolicyPageState();
}

class _PrivacyAndPolicyPageState extends State<PrivacyAndPolicyPage> {
  double progress = 0.0;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      preferredContentMode: UserPreferredContentMode.MOBILE,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Privacy & Policy",
          style: Theme.of(context).textTheme.headline5?.copyWith(
            fontSize: 19,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryBlack),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse("https://sites.google.com/gm.uit.edu.vn/privacy-policy-taskez/home"),
            ),
            initialOptions: options,
            onWebViewCreated: (controller) {},
            onLoadStart: (controller, url) {},
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {},
            onLoadError: (controller, url, code, message) {
              print('Loading Terms & Conditions page error ::: $message');
            },
            onLoadHttpError: (controller, url, statusCode, description) {
              print('Loading Terms & Conditions page error ::: $description');
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100.0;
              });
            },
            onConsoleMessage: (controller, consoleMessage) {
              print('WebView console message ::: $consoleMessage');
            },
          ),
          progress < 1.0
              ? LinearProgressIndicator(
            value: progress,
            color: AppColors.mediumPersianBlue,
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
