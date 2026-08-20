import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class OrdersHeaderWidget extends StatelessWidget {
  const OrdersHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "إدارة الطلبات",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        // ButtonApp(
        //   text: "إضافة مورد جديد",
        //   onPressed: () => showDialog(
        //     context: context,
        //     builder: (context) => const SupplierFormDialog(),
        //   ),
        // ),
      ],
    );
  }
}