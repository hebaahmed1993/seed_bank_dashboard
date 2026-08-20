import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/home_section_type.dart';
import '../../../../../core/enums/request_status.dart';
import '../../../../../core/enums/selection_mode.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/widgets/custom_delete_button.dart';
import '../../../../../core/widgets/custom_edit_button.dart';
import '../../../../../core/widgets/custom_table.dart';
import '../../../../../core/widgets/custom_switch.dart';

import '../../../data/models/home_section_model.dart';
import '../../providers/home_sections_provider.dart';
import '../../providers/home_sections_state.dart';
import 'add_edit_section_dialog.dart';
import 'filter_cell.dart';

class HomeSectionsTableSection extends ConsumerWidget {
  const HomeSectionsTableSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeSectionsNotifierProvider);
    final theme = Theme.of(context);

    ref.listen<HomeSectionsState>(homeSectionsNotifierProvider, (prev, next) {
      if (prev?.deleteStatus != next.deleteStatus) {
        if (next.deleteStatus == RequestStatus.success) {
          CustomSnackBar.showSuccess(
            context: context,
            message: 'تم حذف القسم بنجاح',
          );
          ref.read(homeSectionsNotifierProvider.notifier).resetDeleteStatus();
        } else if (next.deleteStatus == RequestStatus.failure) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? 'فشل حذف القسم',
          );
        }
      }

      if (prev?.updateStatus != next.updateStatus) {
        if (next.updateStatus == RequestStatus.success) {
          CustomSnackBar.showSuccess(
            context: context,
            message: 'تم تحديث حالة القسم بنجاح',
          );
          ref.read(homeSectionsNotifierProvider.notifier).resetUpdateStatus();
        } else if (next.updateStatus == RequestStatus.failure) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? 'فشل تحديث حالة القسم',
          );
        }
      }

      if (next.fetchStatus != prev?.fetchStatus &&
          next.fetchStatus == RequestStatus.failure) {
        CustomSnackBar.showError(
          context: context,
          message: next.errorMessage ?? 'فشل تحميل الأقسام',
        );
      }
    });

    final sections = state.sections;
    final isLoading = state.fetchStatus == RequestStatus.loading;

    final columns = const [
      DataColumn(label: Text('#')),
      DataColumn(label: Text('الترتيب')),
      DataColumn(label: Text('عنوان القسم')),
      DataColumn(label: Text('نوع القسم')),
      DataColumn(label: Text('التصفية / المنتجات')),
      DataColumn(label: Text('الحد')),
      DataColumn(label: Text('الحالة')),
      DataColumn(label: Text('الإجراءات')),
    ];

    final rows = sections.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final section = entry.value;

      return DataRow(
        cells: [
          DataCell(Text('$index')),
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '${section.order}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
          DataCell(
            Text(
              section.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
          ),

          // 🎯 عرض شارة نوع القسم بحسب النوع (منتجات، تصنيفات، أو إعلان)
          DataCell(
            switch (section.type) {
              HomeSectionType.banner => const _BannerBadge(),
              HomeSectionType.categories => const _CategoriesBadge(),
              HomeSectionType.products => _ModeBadge(
                mode: section.selectionMode ?? SelectionMode.dynamicMode,
              ),
            },
          ),
          DataCell(FilterCell(section: section)),
          DataCell(
            Text(
              section.type == HomeSectionType.banner
                  ? '—'
                  : '${section.limit}',
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
          DataCell(
            CustomSwitch(
              value: section.isActive,
              onChanged: (newValue) {
                final updatedSection = section.copyWith(isActive: newValue);
                ref
                    .read(homeSectionsNotifierProvider.notifier)
                    .updateSection(updatedSection);
              },
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomEditButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          AddEditSectionDialog(sectionToEdit: section),
                    );
                  },
                ),
                SizedBox(width: 8.w),
                CustomDeleteButton(
                  onPressed: () => _confirmDelete(context, ref, section),
                ),
              ],
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
            isLoading: isLoading && sections.isEmpty,
            emptyMessage: 'لا توجد أقسام مضافة بعد.',
          ),
        ),
      ],
    );
  }

  void _confirmDelete(
      BuildContext context,
      WidgetRef ref,
      HomeSectionModel section,
      ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من حذف القسم "${section.title}"؟\nلا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(homeSectionsNotifierProvider.notifier)
                  .deleteSection(section.id);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

class _ModeBadge extends StatelessWidget {
  final SelectionMode mode;

  const _ModeBadge({required this.mode});

  @override
  Widget build(BuildContext context) {
    final isDynamic = mode == SelectionMode.dynamicMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDynamic
            ? Colors.purple.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        mode.label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isDynamic ? Colors.purple : Colors.orange.shade800,
        ),
      ),
    );
  }
}

class _BannerBadge extends StatelessWidget {
  const _BannerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        'إعلان (بنر)',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }
}

// 🎯 بادج أنيق مخصص لقسم التصنيفات
class _CategoriesBadge extends StatelessWidget {
  const _CategoriesBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        'تصنيفات',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.teal.shade700,
        ),
      ),
    );
  }
}