import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../dm_khachhang/thong_tin_kh_view.dart';

class PhieuNhapComponent {
  WidgetDateBox ngayXuat({required void Function(DateTime?) onChanged, DateTime? initialDate, bool enabled = true}) {
    return WidgetDateBox(onChanged: onChanged, showClear: false, initialDate: initialDate, enabled: enabled);
  }

  Combobox kieuNhap(
    List<Map<String, dynamic>> item, {
    void Function(dynamic)? onChanged,
    dynamic value,
    bool enabled = true,
  }) {
    return Combobox(
      enabled: enabled,
      items: item.map((e) => ComboboxItem(value: e['MaNV'], text: [e['MoTa']])).toList(),
      onChanged: onChanged,
      value: value,
    );
  }

  Widget pttt({void Function(dynamic)? onChanged, dynamic value, bool enabled = true}) {
    return Combobox(
      value: value,
      enabled: enabled,
      items: [
        ComboboxItem(value: 'TM', text: ['TM']),
        ComboboxItem(value: 'CK', text: ['CK']),
        ComboboxItem(value: 'TM/CK', text: ['TM/CK']),
      ],
      onChanged: onChanged,
    ).expanded();
  }

  Combobox maKhach(
    List<Map<String, dynamic>> item,
    BuildContext context,
    WidgetRef ref, {
    void Function(dynamic)? onChanged,
    dynamic value,
    bool enabled = true,
  }) {
    return Combobox(
      noSearch: false,
      menuWidth: 400,
      columnWidth: [100, 300],
      value: value,
      items: item.map((e) => ComboboxItem(value: e['MaKhach'], text: [e['MaKhach'], e['TenKH']])).toList(),
      onChanged: onChanged,
      enabled: enabled,
      onDoubleTap: () async {
        final khach = await KhachHangRepository().getKhach(value);
        if (context.mounted) {
          ThongTinKHView.show(context, khach: KhachHangModel.fromMap(khach), isUpdate: false);
        }
      },
    );
  }

  Combobox tKhoan(
    List<Map<String, dynamic>> item, {
    void Function(dynamic)? onChanged,
    dynamic value,
    bool enabled = true,
  }) {
    return Combobox(
      noSearch: false,
      menuWidth: 300,
      columnWidth: [50, 250],
      items: item.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
      onChanged: onChanged,
      value: value,
      enabled: enabled,
    );
  }

  Map<int, double>? wR1() {
    return {0: 80, 2: 100, 4: 120, 8: 100};
  }

  Map<int, double>? wR2() {
    return {
      0: 80,
      1: 160,
      2: 485,
      3: 142,
      4: 142,
    };
  }

  Map<int, double>? wR3() {
    return {0: 80, 1: 645, 2: 142, 3: 142};
  }

  Map<int, double>? wR4() {
    return {
      0: 70,
      1: 100,
      2: 100,
      3: 100,
      4: 100,
      5: 120,
    };
  }

  Map<int, double>? wR5() {
    return {
      0: 70,
      1: 100,
      2: 100,
      3: 130,
      4: 100,
      5: 90,
    };
  }
}
