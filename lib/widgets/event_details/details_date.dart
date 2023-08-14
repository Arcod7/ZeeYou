import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeeyou/tools/hsl_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zeeyou/tools/string_extension.dart';

class EventDetailsDate extends StatefulWidget {
  const EventDetailsDate({
    required this.color,
    required this.onDatePicked,
    this.date,
    super.key,
  });

  final Color color;
  final void Function(DateTime date) onDatePicked;
  final DateTime? date;

  @override
  State<EventDetailsDate> createState() => _EventDetailsDateState();
}

class _EventDetailsDateState extends State<EventDetailsDate> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      locale: Locale(Localizations.localeOf(context).languageCode),
    );
    if (picked != null) {
      setState(() {
        widget.onDatePicked(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      onTap: () => _selectDate(context),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: changeColorLightness(widget.color, 0.85),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          Icons.calendar_today_outlined,
          color: widget.color,
          size: 23,
        ),
      ),
      title: Text(
        widget.date != null
            ? DateFormat.yMMMMEEEEd(
                    Localizations.localeOf(context).languageCode)
                .format(widget.date!)
                .capitalize()
            : l10n.chooseDate,
        style: TextStyle(
          color: widget.color,
        ),
      ),
    );
  }
}
