import 'package:pm_ketoan/widgets/combobox.dart';

class PhieuThuComponent {
  Combobox cbbMaKhach(
    List<Map<String, dynamic>> items, {
    dynamic value,
    void Function(dynamic)? onChanged,
    bool enabled = true,
  }) {
    return Combobox(
      menuWidth: 300,
      columnWidth: [100, 200],
      value: value,
      enabled: enabled,
      noSearch: false,
      items: items.map((e) => ComboboxItem(value: e['MaKhach'], text: [e['MaKhach'], e['TenKH']])).toList(),
      onChanged: onChanged,
    );
  }

  Combobox cbbBTK(
    List<Map<String, dynamic>> items, {
    dynamic value,
    void Function(dynamic)? onChanged,
    bool enabled = true,
  }) {
    return Combobox(
      menuWidth: 300,
      columnWidth: [50, 250],
      value: value,
      enabled: enabled,
      noSearch: false,
      items: items.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
      onChanged: onChanged,
    );
  }

  Combobox cbbPTTT({void Function(dynamic)? onChanged, dynamic value, bool enabled = true}) {
    return Combobox(
      value: value,
      enabled: enabled,
      onChanged: onChanged,
      items: [
        ComboboxItem(value: 'TM', text: ['Tiền mặt']),
        ComboboxItem(value: 'CK', text: ['Chuyển khoản']),
      ],
    );
  }
}
