/*
 * This file is part of the Embla Flutter app
 * Copyright (c) 2020 Miðeind ehf.
 * Author: Sveinbjorn Thordarson
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

// Menu view

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './settings.dart' show SettingsRoute;
import './web.dart';
import './common.dart';

var menuContext;

void _pushSettings() {
  Navigator.push(
    menuContext,
    MaterialPageRoute(
      builder: (context) => SettingsRoute(),
    ),
  );
}

void _pushAbout() {
  Navigator.push(
    menuContext,
    MaterialPageRoute(
      builder: (context) => WebViewRoute(initialURL: kAboutURL),
    ),
  );
}

void _pushInstructions() {
  Navigator.push(
    menuContext,
    MaterialPageRoute(
      builder: (context) => WebViewRoute(initialURL: kInstructionsURL),
    ),
  );
}

void _pushPrivacy() {
  Navigator.push(
    menuContext,
    MaterialPageRoute(
      builder: (context) => WebViewRoute(initialURL: kPrivacyURL),
    ),
  );
}

ListTile _generateTile(String name, Function onTapFunc) {
  return ListTile(
    title: Text(name, style: TextStyle(fontSize: 18.0, color: Colors.red)),
    //leading: const Icon(CupertinoIcons.gear),
    leading: Image(image: AssetImage('assets/images/cube.png')),
    trailing: Icon(Icons.arrow_right, color: Colors.red),
    onTap: onTapFunc,
  );
}

// List of menu tiles
var list = ListView(
  padding: const EdgeInsets.all(8),
  children: <Widget>[
    _generateTile("Stillingar", _pushSettings),
    _generateTile("Um Emblu", _pushAbout),
    _generateTile("Leiðbeiningar", _pushInstructions),
    _generateTile("Persónuvernd", _pushPrivacy),
  ],
);

class MenuRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    menuContext = context;
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          //leading: const Text("Til baka"),
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: list);
  }
}
