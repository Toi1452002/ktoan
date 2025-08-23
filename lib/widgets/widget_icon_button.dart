import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

enum IconType { add, delete, print, excel, play, filter }

class WidgetIconButton extends StatelessWidget {
  final IconType type;
  final void Function()? onPressed;
  final bool enabled;
  final ButtonSize size;

  const WidgetIconButton({
    super.key,
    required this.type,
    this.onPressed,
    this.enabled = true,
    this.size = ButtonSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    Icon icon = Icon(PhosphorIcons.filePlus());
    if (type == IconType.delete) icon = Icon(PhosphorIcons.trash(), color: Colors.red);
    if (type == IconType.print) {
      icon = Icon(PhosphorIcons.printer(PhosphorIconsStyle.fill), color: Colors.blue.shade800);
    }
    if (type == IconType.excel) {
      icon = Icon(PhosphorIcons.microsoftExcelLogo(PhosphorIconsStyle.fill), color: Colors.green.shade700);
    }
    if (type == IconType.play) {
      icon = Icon(PhosphorIcons.play(PhosphorIconsStyle.fill), size: 15, color: Colors.gray.shade700);
    }
    if (type == IconType.filter) icon = Icon(PhosphorIcons.funnel());
    return IconButton.outline(onPressed: onPressed, icon: icon, enabled: enabled, size: size);
  }
}
