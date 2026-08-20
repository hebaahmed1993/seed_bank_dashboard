import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'custom_date_picker_button.dart'; // 👈 استدعاء الزر الذي صنعناه سابقاً

class CustomDateRangeFilter extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime? newStart, DateTime? newEnd) onChanged;

  const CustomDateRangeFilter({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  // 🎯 الدالة أصبحت معزولة هنا داخل المكون
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = (isStart ? startDate : endDate) ?? DateTime.now();
    final primaryColor = Theme.of(context).colorScheme.primary;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      if (isStart) {
        onChanged(selectedDate, endDate); // تحديث البداية والاحتفاظ بالنهاية
      } else {
        onChanged(startDate, selectedDate); // تحديث النهاية والاحتفاظ بالبداية
      }
    }
  }

  // 🎯 دالة المسح أصبحت معزولة أيضاً
  void _clearDate(bool isStart) {
    if (isStart) {
      onChanged(null, endDate);
    } else {
      onChanged(startDate, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomDatePickerButton(
            label: startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : 'من: تاريخ',
            icon: Icons.calendar_today_outlined,
            isSelected: startDate != null,
            onTap: () => _selectDate(context, true),
            onClear: () => _clearDate(true),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomDatePickerButton(
            label: endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : 'إلى: تاريخ',
            icon: Icons.calendar_month_outlined,
            isSelected: endDate != null,
            onTap: () => _selectDate(context, false),
            onClear: () => _clearDate(false),
          ),
        ),
      ],
    );
  }
}