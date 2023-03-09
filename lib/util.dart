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

// Various utility functions and custom class extensions

import 'dart:convert';

import 'package:flutter/material.dart' show Color;

import './keys.dart' show queryAPIKey;

// String extensions
extension StringExtension on String {
  // Does string end with standard punctuation?
  bool isPunctuationTerminated() {
    if (length == 0) {
      return false;
    }
    List<String> punctuation = [
      '.',
      ".'",
      '."',
      '.“',
      '?',
      "?'",
      '?"',
      '?“',
      '!',
      "!'",
      '!"',
      '!“',
      '…',
      "…'",
      '…"',
      '…“'
    ];
    for (String p in punctuation) {
      if (endsWith(p)) {
        return true;
      }
    }
    return false;
  }

  // Return period-terminated string if not already ending w. punctuation
  String periodTerminated() {
    if (isPunctuationTerminated() == false) {
      return "$this.";
    }
    return this;
  }

  // Return string with first character capitalized.
  // Why isn't this part of of the standard library?
  String sentenceCapitalized() {
    if (length == 0) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension HexColor on Color {
  // Get standard Flutter Color object from hex string in the
  // format "aabbcc", with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

String _cachedQueryAPIKey = '';

// Read and cache query server key
String readQueryServerKey() {
  if (_cachedQueryAPIKey == '') {
    _cachedQueryAPIKey = utf8.decode(base64.decode(queryAPIKey));
  }
  return _cachedQueryAPIKey;
}
