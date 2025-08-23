import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class ThongTinHangHoaComponent {
  Widget view(BuildContext context, List<Widget> items) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: items),
      ),
    );
  }

  Combobox cbbNhaCung(String? value, List<Map<String, dynamic>> items, {void Function(dynamic)? onChanged}) {
    return Combobox(
      noSearch: false,
      menuWidth: 300,
      columnWidth: [50, 250],
      onChanged: onChanged,
      value: value,
      items: items.map((e) => ComboboxItem(value: e['MaKhach'], text: [e['MaKhach'], e['TenKH']])).toList(),
    );
  }


  Combobox cbbKho(String? value, List<Map<String, dynamic>> items, {void Function(dynamic)? onChanged}) {
    return Combobox(
      menuWidth: 300,
      columnWidth: [50, 250],
      onChanged: onChanged,
      value: value,
      items: items.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
    );
  }

  Row rCheck(bool b1, bool b2,{required void Function(CheckboxState)? c1,required void Function(CheckboxState)? c2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Checkbox(
          state: b1 ? CheckboxState.checked : CheckboxState.unchecked,
          onChanged: c1,
          trailing: Text('Tính toán tồn kho'),
        ),
        Checkbox(
          state: b2 ? CheckboxState.checked : CheckboxState.unchecked,
          onChanged: c2,
          trailing: Text('Mặc hàng đang theo dõi'),
        ),
      ],
    );
  }
}
