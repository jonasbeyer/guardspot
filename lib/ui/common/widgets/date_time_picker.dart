import 'package:flutter/material.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final bool Function(DateTime date) onChanged;

  DateTimePicker({
    this.initialDateTime,
    required this.onChanged,
  });

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime _selectedDateTime;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime ?? DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dateController = TextEditingController(
        text: context.getString(
      "date_medium",
      arguments: {"date": _selectedDateTime},
    ));
    _timeController = TextEditingController(
        text: context.getString(
      "time_long",
      arguments: {"date": _selectedDateTime},
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: () async => _updateDateTime(
              date: await showDatePicker(
                context: context,
                initialDate: _selectedDateTime,
                firstDate: DateTime(2015),
                lastDate: DateTime(2300),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _timeController,
            readOnly: true,
            onTap: () async => _updateDateTime(
              time: await showTimePicker(
                context: context,
                initialEntryMode: TimePickerEntryMode.input,
                initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateDateTime({DateTime? date, TimeOfDay? time}) {
    DateTime? newDateTime;
    if (date != null) newDateTime = _selectedDateTime.copyWithDate(date);
    if (time != null) newDateTime = _selectedDateTime.copyWithTime(time);

    if (newDateTime == null) return;
    if (widget.onChanged(newDateTime)) {
      _dateController.text =
          context.getString("date_medium", arguments: {"date": newDateTime});
      _timeController.text =
          context.getString("time_long", arguments: {"date": newDateTime});

      setState(() => _selectedDateTime = newDateTime!);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Ungültiges Zeitinterval")));
    }
  }
}
