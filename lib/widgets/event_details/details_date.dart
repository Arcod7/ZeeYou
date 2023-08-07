import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeeyou/tools/hsl_color.dart';

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
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        widget.onDatePicked(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _selectDate(context),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: changeColorLigntness(widget.color, 0.85),
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
            ? DateFormat.yMMMMEEEEd().format(widget.date!)
            : 'Choisis une date ;)',
        style: TextStyle(
          color: widget.color,
        ),
      ),
    );
  }
}
