import 'package:flutter/material.dart';

class Connection {
  final String name;
  String brand;
  final Icon icon;
  Image logo;
  String webview;

  Connection.card({this.name, this.brand, this.icon, this.webview});
  Connection.list({this.name, this.icon, this.logo, this.webview});
}
