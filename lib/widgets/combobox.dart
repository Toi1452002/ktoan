
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart' as mt;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pm_ketoan/widgets/widget_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class Combobox extends mt.StatefulWidget {
  final dynamic value;
  final List<ComboboxItem> items;
  final void Function(dynamic value)? onChanged;
  final bool noSearch;
  final List<double>? columnWidth;
  final double? menuWidth;
  final double? width;
  final bool enabled;
  final bool noBorder;
  final void Function()? onTap;
  final void Function()? onDoubleTap;

  const Combobox({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.noSearch = true,
    this.columnWidth,
    this.menuWidth,
    this.width,
    this.enabled = true,
    this.noBorder = false,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  mt.State<Combobox> createState() => _ComboboxState();
}

class _ComboboxState extends mt.State<Combobox> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusDropDown = FocusNode();
  final FocusNode focusSearch = FocusNode();
  bool isOpen = false;
  @override
  void initState() {
    // TODO: implement initState
    focusDropDown.addListener(onChangedFocusDropdown);
    super.initState();
  }

  void onChangedFocusDropdown() {
    if (focusDropDown.hasFocus) {
      isOpen = true;
      if (!widget.noSearch) focusSearch.requestFocus();
    } else {
      isOpen = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectString = widget.items
        .firstWhere(
          (e) => e.value == widget.value,
          orElse: () => ComboboxItem(value: '0', text: ['']),
        )
        .text
        .first;

    return mt.DropdownButtonHideUnderline(
      child: DropdownButton2(
        focusNode: focusDropDown,
        onChanged: widget.enabled ? widget.onChanged : null,
        customButton: OutlinedContainer(
          borderWidth: widget.noBorder ? 0 : 1,
          backgroundColor: Colors.transparent,
          // borderColor: Colors.transparent,
          borderColor: widget.noBorder
              ? Colors.transparent
              : isOpen
              ? context.theme.colorScheme.primary
              : context.theme.colorScheme.border,
          padding: EdgeInsets.symmetric(horizontal: 5),
          // width: 300,
          height: 30,
          child: Row(
            children: [
              mt.InkWell(
                onDoubleTap: widget.onDoubleTap,
                child: Text(
                  selectString,
                  style: TextStyle(color: !widget.enabled ? Colors.gray.shade400:widget.onDoubleTap == null ? Colors.black : Colors.red),
                ),
              ),
              Spacer(),
              Icon(PhosphorIcons.caretUpDown(), size: 15, color: Colors.gray.shade400),
            ],
          ),
        ),
        style: TextStyle(fontSize: 14, color: Colors.black),
        value: widget.value,
        isExpanded: true,
        items: widget.items
            .map(
              (e) => mt.DropdownMenuItem(
                value: e.value,
                child: mt.Table(
                  columnWidths: widget.columnWidth == null
                      ? null
                      : Map.fromEntries([
                          for (int i = 0; i < widget.columnWidth!.length; i++)
                            MapEntry(i, mt.FixedColumnWidth(widget.columnWidth![i])),
                        ]),
                  children: [mt.TableRow(children: e.text.map((e) => Text(e, softWrap: false)).toList())],
                ),
              ),
            )
            .toList(),
        dropdownStyleData: DropdownStyleData(
          isOverButton: !widget.noSearch,
          width: widget.menuWidth,
          maxHeight: 225,
          padding: EdgeInsets.zero,
          elevation: 2,
          decoration: BoxDecoration(border: Border.all(width: .2)),
        ),

        menuItemStyleData: MenuItemStyleData(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 5),
          selectedMenuItemBuilder: (context, child) {
            return Container(color: Colors.blue.shade300, child: child);
          },
        ),
        dropdownSearchData: widget.noSearch
            ? null
            : DropdownSearchData(
                searchController: textEditingController,

                searchInnerWidgetHeight: 50,
                searchInnerWidget: mt.Padding(
                  padding: const EdgeInsets.all(5),
                  child: WidgetTextField(
                    hintText: 'Search',
                    focusNode: focusSearch,
                    autofocus: true,
                    controller: textEditingController,
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                },
              ),

        onMenuStateChange: (val) {
          if (val) widget.onTap?.call();
          setState(() {
            isOpen = val;
          });
          if (!val) textEditingController.clear();
        },
      ),
    );
  }
}

class ComboboxItem {
  final dynamic value;
  final List<String> text;

  const ComboboxItem({required this.value, required this.text});
}
