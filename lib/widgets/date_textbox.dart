import 'package:flutter/material.dart';
import 'package:pm_ketoan/widgets/widget_textfield.dart';

import '../core/utils/helper.dart';

class DateTextbox extends StatefulWidget {
  DateTextbox({super.key, required this.onChanged, this.enabled = true, this.initialDate, this.label = '', this.showClear = false, this.spacing = 5});
  final bool  showClear;
  final String label;
  final ValueChanged<DateTime?> onChanged;
  DateTime? initialDate;
  final double spacing;
  final bool enabled;
  @override
  State<DateTextbox> createState() => _DateTextboxState();
}

class _DateTextboxState extends State<DateTextbox> {
  final controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    if(widget.initialDate!=null){
      controller.text = Helper.dMy(widget.initialDate!);
    }
    return WidgetTextField(
      controller: controller,
      spacing: widget.spacing,
      enabled: widget.enabled,
      hintText: 'dd/mm/yyyy',
      readOnly: true,

      trailing: !widget.showClear? null :InkWell(
        child: const Icon(
          Icons.clear,
          size: 15,
        ),
        onTap: () {
          setState(() {
            widget.initialDate = null;
            controller.clear();
            widget.onChanged.call(null);

          });
        },
      ),
      onTap: !widget.enabled ? null :  () async {

        final date = await showDatePicker(
          builder: (context, child){
            return Theme(data: ThemeData(
              colorSchemeSeed: Colors.blue,
              datePickerTheme: DatePickerThemeData(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)
                  )
              ),
            ), child: child!);
          },
          context: context,
          helpText: widget.label,
          initialDate: widget.initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(3000),
        );

        if (date != null) {
          widget.onChanged.call(date);
          controller.text = Helper.dMy(date);
        }
      },
    );
  }
}
