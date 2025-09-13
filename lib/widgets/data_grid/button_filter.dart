import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pm_ketoan/widgets/data_grid/container_filter.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ButtonFilter extends ConsumerStatefulWidget {
  final bool hide;
  final Map<String, bool> items;
  final String field;
  final void Function(Map<String, bool>)? onChanged;

  const ButtonFilter({super.key, this.hide = true, required this.items, required this.field, this.onChanged});

  @override
  ConsumerState createState() => _ButtonFilterState();
}

class _ButtonFilterState extends ConsumerState<ButtonFilter> {
  // final LayerLink _layerLink = LayerLink();
  // OverlayEntry? _overlayEntry;

  // void _open() {
  //   _overlayEntry = _createOverlay();
  //   Overlay.of(context).insert(_overlayEntry!);
  // }
  //
  // void _close() {
  //   _overlayEntry?.remove();
  //   _overlayEntry = null;
  // }

  @override
  Widget build(BuildContext context) {
    return IconButton.text(
      size: ButtonSize.small,
      onPressed: () {
        showCustomDialog(
          barrierDismissible: true,
          context,
          title: 'FILTER',
          width: 200,
          height: 350,
          child: ContainerFilter( items: widget.items, onChanged: widget.onChanged),
        );
      },
      icon: Icon(PhosphorIcons.funnel()),
    );
    // return CompositedTransformTarget(
    //   link: _layerLink,
    //   child: IconButton.text(
    //     size: ButtonSize.small,
    //     onPressed: _open,
    //     icon: Icon(PhosphorIcons.funnel(),),
    //   ),
    // );
  }

  // OverlayEntry _createOverlay() {
  //   final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //   final size = renderBox.size;
  //   return OverlayEntry(
  //     builder: (context) {
  //       return Stack(
  //         children: [
  //           GestureDetector(
  //             onTap: () {
  //               _close();
  //             },
  //           ),
  //           Positioned(
  //             width: 180,
  //             child: CompositedTransformFollower(
  //               link: _layerLink,
  //               showWhenUnlinked: true,
  //               // targetAnchor: Alignment.bottomLeft,
  //               offset: Offset(-80, size.height - 5),
  //               child: Container(
  //                 height: 300,
  //                 width: 180,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(3),
  //                   boxShadow: [BoxShadow(color: Colors.gray, blurRadius: 5, offset: Offset(0, 4))],
  //                 ),
  //                 child: ContainerFilter(overlayEntry: _overlayEntry, items: widget.items, onChanged: widget.onChanged),
  //                 // child: FilterWidget(
  //                 //   items: widget.items ?? {},
  //                 //   onChanged: widget.onChanged,
  //                 //   overlayEntry: _overlayEntry,
  //                 //   isNumber: widget.isNumber,
  //                 // ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
