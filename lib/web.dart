/*
 * This file is part of the Embla Flutter app
 * Copyright (c) 2020-2023 Miðeind ehf. <mideind@mideind.is>
 * Original author: Sveinbjorn Thordarson
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

// Documentation web views.

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import './theme.dart' show standardAppBar;

const String kDocsDir = 'docs';
const String kLoadingHTMLFilePath = "$kDocsDir/loading.html";
const String kLoadingDarkHTMLFilePath = "$kDocsDir/loading_dark.html";

/// Standard web view route used for displaying HTML documentation files.
class WebViewRoute extends StatefulWidget {
  final String initialURL;

  const WebViewRoute({super.key, required this.initialURL});

  @override
  WebViewRouteState createState() => WebViewRouteState();
}

class WebViewRouteState extends State<WebViewRoute> {
  /// Add dark=1 query parameter to URL.
  /// This param is used to style the HTML document for dark mode via JS.
  String _darkURLForURL(String url) {
    return "$url?dark=1";
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = (MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final finalURL = darkMode ? _darkURLForURL(widget.initialURL) : widget.initialURL;

    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(finalURL));

    return Scaffold(appBar: standardAppBar, body: WebViewWidget(controller: controller));
  }
}
