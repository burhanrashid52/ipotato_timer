import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipotato_timer/util/app_extension.dart';

class DurationSelector extends StatefulWidget {
  const DurationSelector({
    super.key,
    required this.onDurationChanged,
  });

  final Function(Duration) onDurationChanged;

  @override
  _DurationSelectorState createState() => _DurationSelectorState();
}

class _DurationSelectorState extends State<DurationSelector> {
  final TextEditingController _hoursController =
      TextEditingController(text: '0');
  final TextEditingController _minutesController =
      TextEditingController(text: '0');
  final TextEditingController _secondsController =
      TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildDurationField('HH', _hoursController),
        SizedBox(
          width: 32,
          height: 32,
          child: Text(
            " : ",
            textAlign: TextAlign.center,
            style: context.theme.textTheme.titleSmall,
          ),
        ),
        _buildDurationField('MM', _minutesController),
        SizedBox(
          width: 32,
          height: 32,
          child: Text(
            " : ",
            textAlign: TextAlign.center,
            style: context.theme.textTheme.titleSmall,
          ),
        ),
        _buildDurationField('SS', _secondsController),
      ],
    );
  }

  Widget _buildDurationField(String label, TextEditingController controller) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 65,
          height: 65,
          child: Center(
            child: TextField(
              key: ValueKey('text_field_$label'),
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                _DurationRangeFormatter(),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                fillColor: context.theme.colorScheme.secondaryContainer,
                filled: true,
                isDense: true,
                border: InputBorder.none,
              ),
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headlineMedium,
              onChanged: (_) => widget.onDurationChanged(_buildDuration()),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: context.theme.textTheme.titleMedium,
        ),
      ],
    );
  }

  Duration _buildDuration() {
    final hoursText = _hoursController.text;
    final hours = hoursText.isEmpty ? 0 : int.parse(hoursText);

    final minutesText = _minutesController.text;
    final minutes = minutesText.isEmpty ? 0 : int.parse(minutesText);

    final secondText = _secondsController.text;
    final seconds = secondText.isEmpty ? 0 : int.parse(secondText);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }
}

class _DurationRangeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > 2) {
      return oldValue;
    }
    return newValue;
  }
}
