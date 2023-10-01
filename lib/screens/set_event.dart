import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/screens/event_details.dart';
import 'package:zeeyou/models/color_shade.dart';
import 'package:zeeyou/tools/user_manager.dart';
import 'package:zeeyou/tools/text_input_decoration.dart';
import 'package:zeeyou/widgets/event_details/external_link.dart';
import 'package:zeeyou/widgets/event_details/link_date.dart';
import 'package:zeeyou/widgets/event_details/link_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget inputLabel(String label, double topMargin) => Container(
    width: double.infinity,
    margin: EdgeInsets.only(top: topMargin),
    alignment: Alignment.center,
    child: Text(label, style: const TextStyle(color: Colors.black45)));

class SetEventScreen extends StatefulWidget {
  const SetEventScreen({
    super.key,
    this.event,
  });

  final Event? event;

  @override
  State<SetEventScreen> createState() => _SetEventScreenState();
}

class _SetEventScreenState extends State<SetEventScreen>
    with SingleTickerProviderStateMixin {
  void _pickIcon(AppLocalizations l10n) async {
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
      title: Text(l10n.pickAnIcon),
      searchHintText: l10n.searchInEnglish,
    );

    if (icon != null) {
      setState(() => _newEvent.icon = icon);
    }
  }

  void _submit() async {
    setState(() => _isSubmitting = true);
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      setState(() => _isSubmitting = false);

      return;
    }

    _form.currentState!.save();

    final username = await getUsername(loggedUserId);

    final Map<String, dynamic> jsonEvent = {
      'title': _newEvent.title,
      ..._newEvent.description != null
          ? {'description': _newEvent.description}
          : {},
      'organizedBy': loggedUserId,
      'organizedByName': username,
      ..._newEvent.type != null ? {'type': _newEvent.type!.toString()} : {},
      ..._newEvent.icon != null
          ? {
              'icon': {
                'codePoint': _newEvent.icon!.codePoint,
                'fontFamily': _newEvent.icon!.fontFamily,
                'fontPackage': _newEvent.icon!.fontPackage,
              }
            }
          : {},
      'colorHue': _newEvent.colors.colorHue,
      ..._newEvent.date != null
          ? {'date': Timestamp.fromDate(_newEvent.date!)}
          : {},
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
      ..._newEvent.location != null
          ? {
              'location': {
                'lat': _newEvent.location!.latitude,
                'lng': _newEvent.location!.longitude,
                'address': _newEvent.location!.address,
              }
            }
          : {},
      'user_list': [loggedUserId],
      'links': _newEvent.links,
      'maxPeople': _newEvent.maxPeople,
    };

    if (_isModifying) {
      FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event!.id)
          .update(jsonEvent);
    } else {
      FirebaseFirestore.instance.collection('events').add(jsonEvent);
    }

    if (context.mounted) {
      Navigator.of(context).pop();
      if (_isModifying) {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => EventDetailsScreen(
                  event: _newEvent,
                )));
      }
    }
    setState(() => _isSubmitting = false);
  }

  @override
  void initState() {
    super.initState();
    _isModifying = widget.event != null;
    if (_isModifying) {
      _newEvent = widget.event!;
    } else {
      setState(() {
        _newEvent.colors = getColorShade(Random().nextDouble() * 255);
      });
    }
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        setState(() => _isActionButtonExtended = false);
      } else {
        setState(() => _isActionButtonExtended = true);
      }
    });
    _maxPeopleController.text = _newEvent.maxPeople.toString();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _maxPeopleController.dispose();
    super.dispose();
  }

  final _form = GlobalKey<FormState>();

  bool _isModifying = false;
  Event _newEvent = Event(
    title: '',
    organizedBy: loggedUserId,
    colors: getColorShade(30),
    links: {'Photos': '', 'Music': '', 'Meet': ''},
    id: '0',
  );
  final ScrollController _scrollController = ScrollController();
  bool _isActionButtonExtended = true;
  bool _isSubmitting = false;

  final TextEditingController _maxPeopleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_newEvent.maxPeople == 0) {
      _maxPeopleController.text = l10n.infinity;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _newEvent.colors.light,
        title: Text(_isModifying ? l10n.modifyYourEvent : l10n.createYourEvent),
      ),
      floatingActionButton: AnimatedScale(
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
          scale: _newEvent.title != '' ? 1 : 0,
          child: FloatingActionButton.extended(
            onPressed: _isSubmitting ? null : _submit,
            icon: _isSubmitting
                ? const CircularProgressIndicator.adaptive()
                : const Icon(Icons.check),
            label: Text(_isModifying ? l10n.modify : l10n.createThisEvent),
            isExtended: _isActionButtonExtended,
          )),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              TextFormField(
                initialValue: _isModifying ? widget.event!.title : null,
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
                onChanged: (value) => setState(() => _newEvent.title = value),
                textCapitalization: TextCapitalization.sentences,
              ),
              inputLabel('${l10n.color}: ', 10),
              Slider.adaptive(
                max: 255,
                activeColor: _newEvent.colors.primary,
                value: _newEvent.colors.colorHue,
                onChanged: (newColorHue) => setState(
                    () => _newEvent.colors = getColorShade(newColorHue)),
              ),
              const Divider(),
              const SizedBox(height: 20),
              Text('${l10n.useful} (${l10n.optional}) :',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 5),
              LinkDate(
                colors: _newEvent.colors,
                date: _newEvent.date,
                onDatePicked: (date) {
                  setState(() {
                    _newEvent.date = date;
                  });
                },
              ),
              LinkLocation(
                colors: _newEvent.colors,
                location: _newEvent.location,
                onLocationPicked: (newLoc) {
                  setState(() {
                    _newEvent.location = newLoc;
                  });
                },
                creatingEvent: true,
              ),
              ExternalLink(
                text: _newEvent.icon == null
                    ? l10n.chooseIcon
                    : l10n.greatChoice + _newEvent.icon.toString(),
                icon: _newEvent.icon ?? Icons.search,
                colors: _newEvent.colors,
                onTap: () => _pickIcon(l10n),
                isNone: _newEvent.icon == null,
              ),
              const SizedBox(height: 20),
              Text('${l10n.futile} (${l10n.optional}) :',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: _isModifying ? widget.event!.description : null,
                decoration: textInputDecoration(l10n.description),
                minLines: 1,
                maxLines: 5,
                onSaved: (value) {
                  _newEvent.description = value;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              // inputLabel(l10n.eventType, 20),
              // DropdownButtonFormField(
              //   value: _newEvent.type,
              //   items: [
              //     for (final type in EventType.values)
              //       DropdownMenuItem(
              //         value: type,
              //         child: Text(type.name.capitalize()),
              //       )
              //   ],
              //   onChanged: (value) {
              //     _newEvent.type = value!;
              //   },
              // ),
              const SizedBox(height: 20),
              inputLabel(
                  l10n.maxNumberPeople +
                      (_newEvent.maxPeople != 0
                          ? _newEvent.maxPeople.round().toString()
                          : l10n.infinity),
                  10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton.filledTonal(
                      onPressed: () {
                        if (_newEvent.maxPeople > 0) {
                          setState(() => _newEvent.maxPeople--);
                          _maxPeopleController.text =
                              _newEvent.maxPeople.toString();
                        }
                        if (_newEvent.maxPeople == 0) {
                          _maxPeopleController.text = l10n.infinity;
                        }
                      },
                      icon: Icon(MdiIcons.minus)),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: _maxPeopleController,
                      onSaved: (newValue) => _newEvent.maxPeople =
                          newValue != null ? int.tryParse(newValue)! : 0,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (number) {
                        setState(() {
                          _newEvent.maxPeople = int.tryParse(number) ?? 0;
                        });
                      },
                    ),
                  ),
                  IconButton.filledTonal(
                      onPressed: () {
                        setState(() => _newEvent.maxPeople++);
                        _maxPeopleController.text =
                            _newEvent.maxPeople.toString();
                      },
                      icon: Icon(MdiIcons.plus)),
                  IconButton.filledTonal(
                      onPressed: () {
                        setState(() => _newEvent.maxPeople = 0);
                        _maxPeopleController.text = l10n.infinity;
                      },
                      icon: Icon(MdiIcons.infinity)),
                ],
              ),
              // Slider.adaptive(
              //   activeColor: Colors.amber,
              //   min: 0.0,
              //   max: 101.0,
              //   divisions: 100,
              //   value: (_newEvent.maxPeople ?? 0).toDouble(),
              //   onChanged: (value) {
              //     if (value <= 0.1) {
              //       _newEvent.maxPeople = null;
              //     } else {
              //       setState(() => _newEvent.maxPeople = value.round());
              //     }
              //   },
              //   label: _newEvent.maxPeople != null
              //       ? _newEvent.maxPeople!.round().toString()
              //       : 'Nono josé',
              // ),
              inputLabel(l10n.putLinkIfYouWant, 20),
              const SizedBox(height: 10),
              ExternalLink(
                icon: Icons.photo_outlined,
                colors: _newEvent.colors,
                title: TextFormField(
                  initialValue:
                      _isModifying ? widget.event!.links['Photos'] : null,
                  decoration: externalLinkInputDecoration(
                      l10n.photos, _newEvent.colors),
                  autocorrect: false,
                  enableSuggestions: false,
                  onSaved: (value) {
                    _newEvent.links['Photos'] = value ?? '';
                  },
                ),
              ),
              ExternalLink(
                icon: MdiIcons.music,
                colors: _newEvent.colors,
                title: TextFormField(
                  initialValue:
                      _isModifying ? widget.event!.links['Music'] : null,
                  decoration:
                      externalLinkInputDecoration(l10n.music, _newEvent.colors),
                  enableSuggestions: false,
                  autocorrect: false,
                  onSaved: (value) {
                    _newEvent.links['Music'] = value ?? '';
                  },
                ),
              ),
              ExternalLink(
                icon: Icons.meeting_room_outlined,
                colors: _newEvent.colors,
                title: TextFormField(
                  initialValue:
                      _isModifying ? widget.event!.links['Meet'] : null,
                  decoration:
                      externalLinkInputDecoration(l10n.meet, _newEvent.colors),
                  enableSuggestions: false,
                  autocorrect: false,
                  onSaved: (value) {
                    _newEvent.links['Meet'] = value ?? '';
                  },
                ),
              ),
              const SizedBox(height: 200),
            ]),
          ),
        ),
      ),
    );
  }
}
