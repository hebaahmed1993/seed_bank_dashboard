import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/custom_edit_button.dart';
import '../../../data/models/product_model.dart';
import '../../providers/products_provider.dart';
import 'product_form_dialog.dart';

class ProductsActionButtons extends ConsumerWidget {
  final ProductModel product;

  const ProductsActionButtons({
    super.key,
    required this.product,
  });

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "تأكيد الحذف",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("هل أنت متأكد من حذف المنتج \"${product.name}\"؟ لا يمكن التراجع عن هذا الإجراء."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(productsNotifierProvider.notifier).deleteProduct(
                    product.id,
                    product.categoryId,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomEditButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ProductFormDialog(
                productToEdit: product,
              ),
            );
          },
        ),
        SizedBox(width: 8.w),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Theme.of(context).colorScheme.error,
          tooltip: "حذف المنتج",
          onPressed: () => _showDeleteConfirmation(context, ref),
        ),
      ],
    );
  }
}
