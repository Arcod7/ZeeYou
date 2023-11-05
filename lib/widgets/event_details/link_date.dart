import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeeyou/models/color_shade.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zeeyou/tools/string_extension.dart';
import 'package:zeeyou/widgets/event_details/external_link.dart';

class LinkDate extends StatefulWidget {
  const LinkDate({
    required this.colors,
    required this.onDatePicked,
    this.date,
    super.key,
  });

  final ColorShade colors;
  final void Function(DateTime date) onDatePicked;
  final DateTime? date;

  @override
  State<LinkDate> createState() => _LinkDateState();
}

class _LinkDateState extends State<LinkDate> {
  Future<void> _selectDate(BuildContext context, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
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
    return ExternalLink(
      text: widget.date != null
          ? DateFormat.yMMMMEEEEd(l10n.locale)
              .format(widget.date!)
              .capitalize()
          : l10n.chooseDate,
      icon: Icons.calendar_today_outlined,
      colors: widget.colors,
      onTap: () => _selectDate(context, widget.date),
      isNone: widget.date == null,
    );
  }
}
