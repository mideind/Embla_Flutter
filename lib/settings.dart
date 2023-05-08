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

/// Settings route

import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:embla_core/embla_core.dart' show AudioPlayer;

import './common.dart';
import './prefs.dart' show Prefs;
import './voices.dart' show VoiceSelectionRoute;
import './asr.dart' show ASRSelectionRoute;
import './info.dart';
import './theme.dart';

// UI string constants
const String kPrivacyModeMessage =
    'Í einkaham sendir forritið engar upplýsingar frá sér nema fyrirspurnarupptöku. '
    'Þetta kemur í veg fyrir að svarþjónn geti nýtt staðsetningu, eldri fyrirspurnir, '
    'gerð tækis o.fl. til þess að bæta svör.';

const String kClearHistoryAlertText =
    'Þessi aðgerð hreinsar alla fyrirspurnasögu þessa tækis. Fyrirspurnir eru '
    'aðeins vistaðar í 30 daga og gögnin einungis nýtt til þess að bæta svör.';

const String kClearAllAlertText =
    'Þessi aðgerð hreinsar öll vistuð gögn sem tengjast þessu tæki. Gögnin eru '
    'einungis nýtt til þess að bæta svör.';

/// Switch control widget associated with a boolean value pref
class SettingsSwitchWidget extends StatefulWidget {
  final String label;
  final String prefKey;

  const SettingsSwitchWidget({Key? key, required this.label, required this.prefKey})
      : super(key: key);

  @override
  SettingsSwitchWidgetState createState() => SettingsSwitchWidgetState();
}

class SettingsSwitchWidgetState extends State<SettingsSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    String prefKey = widget.prefKey;
    return MergeSemantics(
      child: ListTile(
        title: Text(widget.label),
        trailing: CupertinoSwitch(
          value: Prefs().boolForKey(prefKey),
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool value) {
            setState(() {
              Prefs().setBoolForKey(prefKey, value);
            });
          },
        ),
        onTap: () {
          setState(() {
            Prefs().setBoolForKey(prefKey, !Prefs().boolForKey(prefKey));
          });
        },
      ),
    );
  }
}

/// Special switch control for privacy mode, presents a confirmation alert prompt
class SettingsPrivacySwitchWidget extends StatefulWidget {
  final String label;
  final String prefKey;

  const SettingsPrivacySwitchWidget({Key? key, required this.label, required this.prefKey})
      : super(key: key);

  @override
  SettingsPrivacySwitchWidgetState createState() => SettingsPrivacySwitchWidgetState();
}

class SettingsPrivacySwitchWidgetState extends State<SettingsPrivacySwitchWidget> {
  Future<void> _showPromptDialog(BuildContext context) async {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Virkja einkaham?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(kPrivacyModeMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hætta við'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Virkja'),
              onPressed: () {
                setState(() {
                  Prefs().setBoolForKey(widget.prefKey, true);
                  Prefs().setBoolForKey("share_location", false);
                });
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String prefKey = widget.prefKey;
    return MergeSemantics(
      child: ListTile(
        title: Text(widget.label),
        trailing: CupertinoSwitch(
          value: Prefs().boolForKey(prefKey),
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool value) {
            if (value == true) {
              _showPromptDialog(context);
            } else {
              setState(() {
                Prefs().setBoolForKey(prefKey, false);
              });
            }
          },
        ),
        onTap: () {
          if (Prefs().boolForKey(prefKey) == false) {
            _showPromptDialog(context);
          } else {
            setState(() {
              Prefs().setBoolForKey(prefKey, true);
            });
          }
        },
      ),
    );
  }
}

/// Slider widget associated with a pref float value
class SettingsSliderWidget extends StatefulWidget {
  final String label;
  final String prefKey;
  final double minValue;
  final double maxValue;
  final double stepSize;
  final void Function(double)? onChangeEnd;

  const SettingsSliderWidget(
      {Key? key,
      required this.label,
      required this.prefKey,
      required this.minValue,
      required this.maxValue,
      required this.stepSize,
      this.onChangeEnd})
      : super(key: key);

  @override
  SettingsSliderWidgetState createState() => SettingsSliderWidgetState();
}

class SettingsSliderWidgetState extends State<SettingsSliderWidget> {
  double currVal = 1.0;

  double _constrainValue(double pval) {
    pval = pval > widget.maxValue ? widget.maxValue : pval;
    pval = pval < widget.minValue ? widget.maxValue : pval;
    if (widget.stepSize > 0) {
      pval = (pval / widget.stepSize).round() * widget.stepSize;
    }
    return pval;
  }

  String genSliderLabel() {
    double val = Prefs().doubleForKey(widget.prefKey) ?? 1.0;
    String valStr = val.toStringAsFixed(2);
    if (valStr.endsWith("0")) {
      valStr = valStr.substring(0, valStr.length - 1);
    }
    valStr = valStr.replaceAll('.', ',');
    return "${widget.label} (${valStr}x)";
  }

  @override
  Widget build(BuildContext context) {
    currVal = _constrainValue(Prefs().doubleForKey(widget.prefKey) ?? 1.0);
    return ListTile(
        title: Text(genSliderLabel()),
        trailing: CupertinoSlider(
            onChangeEnd: widget.onChangeEnd ?? (double value) {},
            onChanged: (double value) {
              setState(() {
                currVal = _constrainValue(value);
                Prefs().setDoubleForKey(widget.prefKey, currVal);
              });
            },
            value: currVal,
            min: widget.minValue,
            max: widget.maxValue));
  }
}

/// Button that presents an alert with an action name + handler
class SettingsButtonPromptWidget extends StatelessWidget {
  final String label;
  final String alertText;
  final String buttonTitle;
  final void Function() handler;

  const SettingsButtonPromptWidget(
      {Key? key,
      required this.label,
      required this.alertText,
      required this.buttonTitle,
      required this.handler})
      : super(key: key);

  Future<void> _showPromptDialog(BuildContext context) async {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("$label?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(alertText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hætta við'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(buttonTitle),
              onPressed: () {
                handler();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showPromptDialog(context);
      },
      child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Text(label, style: const TextStyle(fontSize: defaultFontSize))),
    );
  }
}

/// Widget that controls query server prefs i.e. text field
/// and the presets presented in a segmented control.
class SettingsServerSelectionWidget extends StatefulWidget {
  final List<List<String>> items;
  final String prefKey;

  const SettingsServerSelectionWidget({Key? key, required this.items, required this.prefKey})
      : super(key: key);

  @override
  SettingsServerSelectionWidgetState createState() => SettingsServerSelectionWidgetState();
}

class SettingsServerSelectionWidgetState extends State<SettingsServerSelectionWidget> {
  String text = "";
  TextEditingController? textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: Prefs().stringForKey(widget.prefKey));
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    textController?.dispose();
    super.dispose();
  }

  Map<int, Widget> _genChildren() {
    Map<int, Widget> wlist = {};
    for (int i = 0; i < widget.items.length; i++) {
      wlist[i] = Padding(padding: const EdgeInsets.all(10.0), child: Text(widget.items[i][0]));
    }
    return wlist;
  }

  int selectedSegment() {
    for (int i = 0; i < widget.items.length; i++) {
      if (Prefs().stringForKey(widget.prefKey) == widget.items[i][1]) {
        return i;
      }
    }
    return 0;
  }

  void _onChange(var val) {
    String finalVal = '';
    if (val is String) {
      finalVal = val;
    } else {
      finalVal = widget.items[val][1];
    }

    setState(() {
      text = finalVal;
      Prefs().setStringForKey(widget.prefKey, text);
      textController?.value = TextEditingValue(
          text: text, selection: TextSelection(baseOffset: text.length, extentOffset: text.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    text = Prefs().stringForKey(widget.prefKey) ?? '';
    return Column(children: [
      Padding(
          padding: standardEdgeInsets,
          child: TextField(
            controller: textController,
            onSubmitted:
                _onChange, /*style: TextStyle(color: lightTextColor, fontSize: defaultFontSize)*/
          )),
      CupertinoSegmentedControl(
          children: _genChildren(), groupValue: selectedSegment(), onValueChanged: _onChange),
    ]);
  }
}

/// Widget that displays a label and a value
class SettingsLabelValueWidget extends StatelessWidget {
  final String label;
  final String value;
  final dynamic onTapRoute;

  const SettingsLabelValueWidget(this.label, this.value, {this.onTapRoute, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget trailing = Text(value, style: Theme.of(context).textTheme.bodySmall);
    if (onTapRoute != null) {
      // Add arrow if tapping label performs an action
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          trailing,
          const Icon(Icons.arrow_right),
        ],
      );
    }

    return MergeSemantics(
        child: ListTile(
      title: Text(label, style: Theme.of(context).textTheme.bodySmall),
      trailing: trailing,
      onTap: () {
        if (onTapRoute != null) {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) {
              return onTapRoute;
            }),
          );
        }
      },
    ));
  }
}

class SettingsFullTextLabelWidget extends StatelessWidget {
  final String label;

  const SettingsFullTextLabelWidget(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
        child: ListTile(
      title: SelectableText(label, style: Theme.of(context).textTheme.bodySmall),
    ));
  }
}

/// Widget that displays a label and a value that is fetched asynchronously
class SettingsAsyncFullTextLabelWidget extends StatelessWidget {
  final Future<String> future;

  const SettingsAsyncFullTextLabelWidget(this.future, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: future,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return SettingsFullTextLabelWidget(snapshot.data!);
          }
          return const SettingsFullTextLabelWidget('…');
        });
  }
}

/// Widget that displays a label and a value that is fetched asynchronously
class SettingsAsyncLabelValueWidget extends StatelessWidget {
  final String label;
  final Future<String> future;
  final Widget? onTapRoute;

  const SettingsAsyncLabelValueWidget(this.label, this.future, {this.onTapRoute, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: future,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return SettingsLabelValueWidget(label, snapshot.data!, onTapRoute: onTapRoute);
          }
          return SettingsLabelValueWidget(label, '…');
        });
  }
}

/// Voice selection widget
class SettingsVoiceSelectionWidget extends StatefulWidget {
  final String label;

  const SettingsVoiceSelectionWidget({Key? key, required this.label}) : super(key: key);

  @override
  SettingsVoiceSelectionWidgetState createState() => SettingsVoiceSelectionWidgetState();
}

class SettingsVoiceSelectionWidgetState extends State<SettingsVoiceSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.label, style: menuTextStyle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Prefs().stringForKey('voice_id') ?? "(engin rödd valin)",
                style: Theme.of(context).textTheme.bodySmall),
            const Icon(Icons.arrow_right),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const VoiceSelectionRoute(),
            ),
          ).then((val) {
            // Trigger re-render since voice selection may have changed
            setState(() {});
          });
        });
  }
}

/// Voice selection widget
class SettingsASRSelectionWidget extends StatefulWidget {
  final String label;

  const SettingsASRSelectionWidget({Key? key, required this.label}) : super(key: key);

  @override
  SettingsASRSelectionWidgetState createState() => SettingsASRSelectionWidgetState();
}

class SettingsASRSelectionWidgetState extends State<SettingsASRSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.label, style: menuTextStyle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Prefs().stringForKey('asr_engine') ?? "(ekkert valið)",
                style: Theme.of(context).textTheme.bodySmall),
            const Icon(Icons.arrow_right),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const ASRSelectionRoute(),
            ),
          ).then((val) {
            // Trigger re-render since ASR engine selection may have changed
            setState(() {});
          });
        });
  }
}

Timer? voiceSpeedTimer;

Future<void> playVoiceSpeed() async {
  if (voiceSpeedTimer != null) {
    voiceSpeedTimer!.cancel();
  }
  AudioPlayer().stop();
  voiceSpeedTimer = Timer(const Duration(milliseconds: 300), () {
    AudioPlayer().playSound('voicespeed', Prefs().stringForKey('voice_id') ?? kDefaultVoiceID, null,
        Prefs().doubleForKey("voice_speed") ?? kDefaultVoiceSpeed);
  });
}

// Generate list of settings widgets
List<Widget> _settings(BuildContext context) {
  final divider = Divider(height: 40, color: color4ctx(context));

  // Basic settings widgets
  final List<Widget> settingsWidgets = [
    const SettingsSwitchWidget(label: 'Raddvirkjun', prefKey: 'hotword_activation'),
    const SettingsSwitchWidget(label: 'Deila staðsetningu', prefKey: 'share_location'),
    const SettingsPrivacySwitchWidget(label: 'Einkahamur', prefKey: 'privacy_mode'),
    const SettingsVoiceSelectionWidget(label: 'Rödd'),
    SettingsSliderWidget(
        label: 'Talhraði',
        prefKey: 'voice_speed',
        minValue: kVoiceSpeedMin,
        maxValue: kVoiceSpeedMax,
        stepSize: 0.05,
        onChangeEnd: (double val) {
          playVoiceSpeed();
        }),
    SettingsAsyncLabelValueWidget('Útgáfa', getHumanFriendlyVersionString(),
        onTapRoute: const VersionRoute()),
  ];

  // Only include query server selection widget in debug builds
  // if (kDebugMode) {
  settingsWidgets.addAll([
    const SettingsASRSelectionWidget(label: 'Talgreining'),
    divider,
    const SettingsFullTextLabelWidget('Ratatoskur:'),
    const SettingsServerSelectionWidget(
        items: kRatatoskurServerPresetOptions, prefKey: 'ratatoskur_server'),
    divider,
    const SettingsFullTextLabelWidget('Fyrirspurnaþjónn:'),
    const SettingsServerSelectionWidget(items: kQueryServerPresetOptions, prefKey: 'query_server'),
    const Padding(padding: EdgeInsets.only(top: 0, bottom: 0), child: Text(''))
  ]);
  // }

  // Add clear history buttons
  settingsWidgets.addAll([
    divider,
    SettingsButtonPromptWidget(
        label: 'Hreinsa fyrirspurnasögu',
        alertText: kClearHistoryAlertText,
        buttonTitle: 'Hreinsa',
        handler: () {
          // TODO: Do this via EmblaCore
          //QueryService.clearUserData(false);
        }),
    SettingsButtonPromptWidget(
        label: 'Hreinsa öll gögn',
        alertText: kClearAllAlertText,
        buttonTitle: 'Hreinsa',
        handler: () {
          // TODO: Do this via EmblaCore
          //QueryService.clearUserData(true);
        }),
    const Padding(padding: EdgeInsets.only(top: 30, bottom: 30), child: Text(''))
  ]);

  return settingsWidgets;
}

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: standardAppBar,
        body: ListView(padding: standardEdgeInsets, children: _settings(context)));
  }
}
