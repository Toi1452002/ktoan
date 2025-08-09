import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../data/data.dart';
import '../../../widgets/widgets.dart';
import '../../khachhang/thong_tin_kh_view.dart';

class PhieuXuatComponent {
  Combobox kieuXuat(
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


  Map<int, TableColumnWidth>? wR1() {
    return {0: FixedColumnWidth(80), 2: FixedColumnWidth(100), 4: FixedColumnWidth(120), 8: FixedColumnWidth(100)};
  }

  Map<int, TableColumnWidth>? wR2() {
    return {
      0: FixedColumnWidth(80),
      1: FixedColumnWidth(160),
      2: FixedColumnWidth(485),
      3: FixedColumnWidth(142),
      4: FixedColumnWidth(142),
    };
  }

  Map<int, TableColumnWidth>? wR3() {
    return {0: FixedColumnWidth(80), 1: FixedColumnWidth(645), 2: FixedColumnWidth(142), 3: FixedColumnWidth(142)};
  }

  Map<int, TableColumnWidth>? wR4() {
    return {
      0: FixedColumnWidth(70),
      1: FixedColumnWidth(100),
      2: FixedColumnWidth(100),
      3: FixedColumnWidth(170),
      4: FixedColumnWidth(30),
      5: FixedColumnWidth(120),
    };
  }
  Map<int, TableColumnWidth>? wR5() {
    return {
      0: FixedColumnWidth(70),
      1: FixedColumnWidth(100),
      2: FixedColumnWidth(100),
      3: FixedColumnWidth(100),
      4: FixedColumnWidth(100),
      5: FixedColumnWidth(120),
    };
  }

  Map<int, TableColumnWidth>? wR6() {
    return {
      0: FixedColumnWidth(70),
      1: FixedColumnWidth(100),
      2: FixedColumnWidth(100),
      3: FixedColumnWidth(130),
      4: FixedColumnWidth(100),
      5: FixedColumnWidth(90),
    };
  }
}
