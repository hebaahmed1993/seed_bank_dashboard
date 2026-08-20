import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seed_bank_dashboard/features/suppliers/presentation/pages/widgets/supplier_form_dialog.dart';

import '../../../../../core/constants/app_error_messages.dart';
import '../../../../../core/enums/request_status.dart';
import '../../../../../core/widgets/custom_edit_button.dart';
import '../../../../../core/widgets/custom_table.dart';
import '../../../../../core/widgets/custom_pagination_controls.dart';
import '../../../../../core/widgets/custom_switch.dart';
import '../../providers/suppliers_provider.dart';

class SuppliersTableSection extends ConsumerWidget {
  const SuppliersTableSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(suppliersNotifierProvider);
    final pagination = state.pagination;
    final suppliers = pagination.items;
    final currentPage = pagination.currentPage;
    final limit = ref.read(suppliersNotifierProvider.notifier).limit;

    final isLoading = state.fetchStatus == RequestStatus.loading;

    // 🎯 1. عرض خطأ عام للمستخدم في حال فشل الجلب وكانت الشاشة فارغة تماماً
    if (state.fetchStatus == RequestStatus.error && suppliers.isEmpty) {
      return Center(
        child: Text(
          AppErrorMessages.initialFetchError, // 🎯 استخدام الرسالة الموحدة
        ),
      );
    }

    // أعمدة الجدول
    final columns = const [
      DataColumn(label: Text("#")),
      DataColumn(label: Text("اسم المورد / الشركة")),
      DataColumn(label: Text("المدينة")),
      DataColumn(label: Text("جهة الاتصال")),
      DataColumn(label: Text("رقم الهاتف")),
      DataColumn(label: Text("تفعيل / إلغاء التفعيل")),
      DataColumn(label: Text("الإجراءات")),
    ];

    // تجهيز الصفوف
    final rows = suppliers.asMap().entries.map((entry) {
      final index = (currentPage - 1) * limit + (entry.key + 1);
      final supplier = entry.value;

      return DataRow(
        cells: [
          DataCell(Text('$index')),
          DataCell(Text(supplier.companyName.isNotEmpty ? supplier.companyName : 'غير محدد')),
          DataCell(Text(supplier.city.isNotEmpty ? supplier.city : 'غير محدد')),
          DataCell(Text(supplier.name.isNotEmpty ? supplier.name : 'غير محدد')),
          DataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(supplier.phone.isNotEmpty ? supplier.phone : 'غير محدد'),
                if (supplier.phone2.isNotEmpty) Text(supplier.phone2),
              ],
            ),
          ),
          DataCell(
            CustomSwitch(
              value: supplier.isActive,
              onChanged: (val) {
                final updatedSupplier = supplier.copyWith(isActive: val);
                ref.read(suppliersNotifierProvider.notifier).updateSupplier(updatedSupplier);
              },
            ),
          ),
          DataCell(
            CustomEditButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => SupplierFormDialog(supplierToEdit: supplier),
                );
              },
            ),
          ),
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CustomTable(
            columns: columns,
            rows: rows,
            isLoading: isLoading && suppliers.isEmpty,
            emptyMessage: "لا توجد نتائج مطابقة.", // 🎯 2. التعامل السليم مع القائمة الفارغة هنا
          ),
        ),

        CustomPaginationControls(
          currentPage: currentPage,
          hasNextPage: pagination.hasNextPage,
          isLoadingPage: isLoading,
          onPreviousPressed: () {
            if (!isLoading && pagination.hasPreviousPage) {
              ref.read(suppliersNotifierProvider.notifier).goToPreviousPage();
            }
          },
          onNextPressed: () {
            if (!isLoading && pagination.hasNextPage) {
              ref.read(suppliersNotifierProvider.notifier).goToNextPage();
            }
          },
        ),
      ],
    );
  }
}