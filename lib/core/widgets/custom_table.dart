import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/theme/theme_provider.dart' show themeModeProvider;



class CustomTable extends ConsumerStatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool isLoading;
  final String? emptyMessage;

  const CustomTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyMessage,
  });

  @override
  ConsumerState<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends ConsumerState<CustomTable> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  Widget _buildCellContent(Widget child, TextStyle defaultTextStyle, Color textColor) {
    if (child is Text) {
      final text = child.data ?? '';
      final isNumeric = RegExp(r'^[0-9\-\+\s#]+$').hasMatch(text);

      if (isNumeric) {
        return Text(
          text,
          // style: TextStyle(
          //   fontSize: 14.sp, // حجم مخصص وواضح للأرقام
          //   fontWeight: FontWeight.bold, // وزن مختلف ومميز للأرقام
          //   color: textColor, // 🎯 استخدام الـ textColor المستورد مباشرة من الـ Provider
          //   letterSpacing: 0.3,
          // ),
        );
      }
    }
    return DefaultTextStyle(
      style: defaultTextStyle,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final settingsState = ref.watch(themeModeProvider);
    final currentTextColor = settingsState.textColor;
    final currentBackground = settingsState.backgroundColor;

    final TextStyle defaultDataStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 15.sp,
      color: colorScheme.primary,
    );

    final processedRows = widget.rows.map((row) {
      return DataRow(
        key: row.key,
        selected: row.selected,
        onSelectChanged: row.onSelectChanged,
        color: row.color,
        cells: row.cells.map((cell) {
          return DataCell(
            _buildCellContent(cell.child, defaultDataStyle, currentTextColor),
            placeholder: cell.placeholder,
            showEditIcon: cell.showEditIcon,
            onTap: cell.onTap,
            onLongPress: cell.onLongPress,
            onTapCancel: cell.onTapCancel,
          );
        }).toList(),
      );
    }).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: widget.isLoading
          ? SizedBox(
        height: 200.h,
        child: Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        ),
      )
          : widget.rows.isEmpty
          ? SizedBox(
        height: 200.h,
        child: Center(
          child: Text(
            widget.emptyMessage ?? 'لا توجد بيانات لعرضها',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15.sp,
            ),
          ),
        ),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            controller: _verticalController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _verticalController,
              scrollDirection: Axis.vertical,
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFFE5ECF2),
                      ),
                    //  dataRowColor: WidgetStateProperty.all(currentBackground),
                      horizontalMargin: 24.w,
                      columnSpacing: 32.w,
                      dataRowMaxHeight: 68.h,
                      dividerThickness: 0.8,
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: colorScheme.primary,
                      ),
                      dataTextStyle: defaultDataStyle,
                      columns: widget.columns,
                      rows: processedRows,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}