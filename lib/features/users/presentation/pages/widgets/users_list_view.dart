import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/request_status.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../providers/users_provider.dart';

import 'user_filter_section.dart';
import 'user_header_widget.dart';
import 'users_table_section.dart';

class UsersListView extends ConsumerWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // 🎯 الاستماع لحالة تغيير الحظر وعرض CustomSnackBar الموحد
    ref.listen(usersNotifierProvider, (previous, next) {
      if (previous?.toggleBlockStatus != next.toggleBlockStatus) {
        if (next.toggleBlockStatus == RequestStatus.success) {
          CustomSnackBar.showSuccess(
            context: context,
            message: 'تم تغيير حالة المستخدم بنجاح',
          );
        } else if (next.toggleBlockStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? 'حدث خطأ غير متوقع',
          );
        }
      }
    });

    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // القسم الأول: الترويسة
          const UserHeaderWidget(),

          SizedBox(height: 24.h),

          // القسم الثاني: شريط البحث والفلاتر
          const UserFilterSection(),

          SizedBox(height: 16.h),

          // القسم الثالث: جدول البيانات (مستقل تماماً)
          const Expanded(
            child: UsersTableSection(),
          ),
        ],
      ),
    );
  }
}