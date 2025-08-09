import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pm_ketoan/widgets/widget_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class GroupButtonNumberPage extends StatelessWidget {
  final void Function()? first;
  final void Function()? back;
  final void Function()? next;
  final void Function()? last;
  final String text;

  const GroupButtonNumberPage({
    super.key,
    required this.text,
    required this.first,
    required this.last,
    required this.back,
    required this.next,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        IconButton.secondary(
          icon: Icon(PhosphorIcons.rewind()),
          onPressed: first,
          // enabled: enabled,
          size: ButtonSize(.7),
        ),
        IconButton.secondary(icon: Icon(PhosphorIcons.skipBack()), onPressed: back, size: ButtonSize(.7)),
        SizedBox(
          width: 100,
          child: ColoredBox(
            color: context.theme.colorScheme.card,
            child: WidgetTextField(
              readOnly: true,
              textAlign: TextAlign.center,
              controller: TextEditingController(text: text),
            ),
          ),
        ),
        IconButton.secondary(
          icon: Icon(PhosphorIcons.skipForward()),
          onPressed: next,
          size: ButtonSize(.7),
        ),
        IconButton.secondary(
          icon: Icon(PhosphorIcons.fastForward()),
          onPressed: last,
          size: ButtonSize(.7),
        )
      ],
    );
  }
}
