import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/tools/hsl_color.dart';
import 'package:zeeyou/tools/user_manager.dart';
import 'package:zeeyou/tools/string_extension.dart';
import 'package:zeeyou/tools/text_input_decoration.dart';
import 'package:zeeyou/widgets/event_details/details_date.dart';
import 'package:zeeyou/widgets/event_details/details_location.dart';
import 'package:zeeyou/widgets/zee_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget inputLabel(String label, double topMargin) => Container(
    width: double.infinity,
    margin: EdgeInsets.only(top: topMargin),
    alignment: Alignment.center,
    child: Text(label, style: const TextStyle(color: Colors.black45)));

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();

  String _enteredTitle = '';
  String? _enteredDescription;
  double _enteredMaxPeople = 2.0;
  double _enteredColorHue = 1.0;
  EventType? _enteredEventType;
  DateTime? _enteredDate;
  PlaceLocation? _enteredLocation;
  Color _enteredColor = changeColorLigntness(
    const Color.fromARGB(255, 255, 199, 135),
    0.3,
  );
  Color get _enteredColorLight => changeColorLigntness(_enteredColor, 0.85);
  IconData? _enteredIcon;

  void updateColorHue(double newColorHue) {
    setState(() {
      _enteredColorHue = newColorHue;
      _enteredColor = changeColorLigntness(
          changeColorHue(
            _enteredColor,
            _enteredColorHue,
          ),
          0.3);
    });
  }

  void _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(
      context,
      customIconPack: iconMap,
      iconPackModes: [
        IconPack.cupertino,
        IconPack.fontAwesomeIcons,
        IconPack.lineAwesomeIcons,
        IconPack.material,
      ],
      showTooltips: true,
      adaptiveDialog: true,
    );

    if (icon != null) {
      setState(() => _enteredIcon = icon);
    }
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    final username = await getUsername(loggedUserId);

    // Faudrait d'abbord vérifier que l'id existe pas déjà
    FirebaseFirestore.instance.collection('events').add({
      'title': _enteredTitle,
      ..._enteredDescription != null
          ? {'description': _enteredDescription}
          : {},
      'organizedBy': loggedUserId,
      'organizedByName': username,
      'type': _enteredEventType.toString(),
      ..._enteredIcon != null
          ? {
              'icon': {
                'codePoint': _enteredIcon!.codePoint,
                'fontFamily': _enteredIcon!.fontFamily,
                'fontPackage': _enteredIcon!.fontPackage,
              }
            }
          : {},
      'color': [_enteredColor.red, _enteredColor.green, _enteredColor.blue],
      ..._enteredDate != null
          ? {'date': Timestamp.fromDate(_enteredDate!)}
          : {},
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
      ..._enteredLocation != null
          ? {
              'location': {
                'lat': _enteredLocation!.latitude,
                'lng': _enteredLocation!.longitude,
                'address': _enteredLocation!.address,
              }
            }
          : {},
      'user_list': [loggedUserId],
    });

    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Navigator.of(context).pop(Event(
    //   title: _enteredTitle,
    //   description: _enteredDescription,
    //   organizedBy: myUserName,
    //   type: _enteredEventType,
    //   icon: _enteredIcon,
    //   color: _enteredColor,
    //   date: _enteredDate,
    //   location: _enteredLocation,
    //   id: const Uuid().v4(),
    // ));
  }

  @override
  void initState() {
    super.initState();
    updateColorHue(Random().nextDouble() * 255);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _enteredColorLight,
        title: Text(l10n.createYourEvent),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ZeeButton(text: l10n.createThisEvent, onPressed: _submit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              TextFormField(
                decoration: textInputDecoration(l10n.nameOfEvent),
                enableSuggestions: false,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 2) {
                    return l10n.minLetter(2);
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredTitle = value!;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              inputLabel('${l10n.color}: ', 10),
              Slider.adaptive(
                max: 255,
                activeColor: _enteredColor,
                value: _enteredColorHue,
                onChanged: (newColorHue) => updateColorHue(newColorHue),
              ),
              Text('${l10n.useful} (${l10n.optional}) :',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 5),
              EventDetailsDate(
                color: _enteredColor,
                date: _enteredDate,
                onDatePicked: (date) {
                  setState(() {
                    _enteredDate = date;
                  });
                },
              ),
              EventDetailsLocation(
                color: _enteredColor,
                lightColor: _enteredColorLight,
                location: _enteredLocation,
                onLocationPicked: (newLoc) {
                  setState(() {
                    _enteredLocation = newLoc;
                  });
                },
                creatingEvent: true,
              ),
              ElevatedButton.icon(
                  onPressed: _pickIcon,
                  icon: Icon(_enteredIcon ?? Icons.search),
                  label: Text(l10n.chooseIcon)),
              const SizedBox(height: 20),
              Text('${l10n.futile} (${l10n.optional}) :',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 15),
              TextFormField(
                decoration: textInputDecoration(l10n.description),
                enableSuggestions: false,
                onSaved: (value) {
                  _enteredDescription = value;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              inputLabel(l10n.eventType, 20),
              DropdownButtonFormField(
                value: _enteredEventType,
                items: [
                  for (final type in EventType.values)
                    DropdownMenuItem(
                      value: type,
                      child: Text(type.name.capitalize()),
                    )
                ],
                onChanged: (value) {
                  _enteredEventType = value!;
                },
              ),
              const SizedBox(height: 20),
              inputLabel(
                  l10n.maxNumberPeople + _enteredMaxPeople.round().toString(),
                  10),
              Slider.adaptive(
                activeColor: Colors.amber,
                min: 1.0,
                max: 101.0,
                divisions: 100,
                value: _enteredMaxPeople,
                onChanged: (value) {
                  setState(() => _enteredMaxPeople = value);
                },
                label: _enteredMaxPeople.round().toString(),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
