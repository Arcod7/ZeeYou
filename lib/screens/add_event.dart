import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/tools/hsl_color.dart';
import 'package:zeeyou/tools/sesson_manager.dart';
import 'package:zeeyou/tools/string_extension.dart';
import 'package:zeeyou/tools/text_input_decoration.dart';
import 'package:zeeyou/widgets/event_details/details_date.dart';
import 'package:zeeyou/widgets/event_details/details_location.dart';
import 'package:zeeyou/widgets/zee_button.dart';

Widget inputLabel(String label, double topMargin) => Container(
    width: double.infinity,
    margin: EdgeInsets.only(top: topMargin),
    alignment: Alignment.centerLeft,
    child: Text(label, style: const TextStyle(color: Colors.black45)));

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _form = GlobalKey<FormState>();

  String _enteredTitle = '';
  String? _enteredDescription;
  double _enteredMaxPeople = 2.0;
  double _enteredColorHue = 1.0;
  EventType _enteredEventType = EventType.aucun;
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

    final username = await SessionManager().getUsername();

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

    Navigator.of(context).pop();

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
    updateColorHue(Random().nextDouble() * 255);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _enteredColorLight,
        title: const Text('Crée ton événement !'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ZeeButton(
          text: 'Créer cet événement',
          onPressed: _submit,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              TextFormField(
                decoration: textInputDecoration("Nom de l'événement"),
                enableSuggestions: false,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 2) {
                    return '2 lettres minimum stp';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredTitle = value!;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: textInputDecoration("Description (optionnel)"),
                enableSuggestions: false,
                onSaved: (value) {
                  _enteredDescription = value;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
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
              inputLabel(
                  'Nombre maximum de personnes : ${_enteredMaxPeople.round()}',
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
                label: '${_enteredMaxPeople.round()}',
              ),
              inputLabel('Couleur: ', 0),
              Slider.adaptive(
                max: 255,
                activeColor: _enteredColor,
                value: _enteredColorHue,
                onChanged: (newColorHue) => updateColorHue(newColorHue),
              ),
              inputLabel("Type d'événement", 5),
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
              ElevatedButton.icon(
                  onPressed: _pickIcon,
                  icon: Icon(_enteredIcon ?? Icons.search),
                  label: const Text('Choisis une icône')),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }
}
