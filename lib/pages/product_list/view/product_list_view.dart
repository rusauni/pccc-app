import 'package:base_app/pages/base/view/base_view.dart';
import 'package:base_app/pages/product_list/view_model/product_list_view_model.dart';
import 'package:base_app/pages/product_list/model/product_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:flutter/material.dart' hide ButtonStyle, CircularProgressIndicator, showDialog;

class ProductListView extends BaseView<ProductListViewModel> {
  const ProductListView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: VNLTheme.of(context).colorScheme.destructive,
                ),
                const Gap(16),
                Text(
                  viewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: VNLTheme.of(context).colorScheme.destructive,
                  ),
                ),
                const Gap(16),
                VNLButton.primary(
                  onPressed: viewModel.refreshProducts,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // Filter and Sort section
        _buildFilterSection(context),
        
        // Products grid
        Expanded(
          child: viewModel.products.isEmpty
              ? _buildEmptyState(context)
              : _buildProductsGrid(context),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.card,
        border: Border(
          bottom: BorderSide(
            color: VNLTheme.of(context).colorScheme.border,
          ),
        ),
      ),
      child: Row(
        children: [
          // Sort dropdown
          Expanded(
            child: VNLSelect<SortOption>(
              value: viewModel.currentSort,
              placeholder: const Text('Sắp xếp'),
              onChanged: (value) {
                if (value != null) {
                  viewModel.setSortOption(value);
                }
              },
              popup: SelectPopup.builder(
                builder: (context, searchQuery) {
                  return SelectItemList(
                    children: [
                      for (final option in SortOption.values)
                        SelectItemButton(
                          value: option,
                          child: Text(option.displayName),
                        ),
                    ],
                  );
                },
              ),
              itemBuilder: (context, value) {
                return Text(value.displayName);
              },
            ),
          ),
          const Gap(12),
          
          // Product count
          Text(
            '${viewModel.products.length} sản phẩm',
            style: TextStyle(
              fontSize: 14,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
        itemCount: viewModel.products.length,
        itemBuilder: (context, index) {
          final product = viewModel.products[index];
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: VNLTheme.of(context).colorScheme.card,
        border: Border.all(
          color: VNLTheme.of(context).colorScheme.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to product detail
          // context.go('/product-detail/${product.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Colors.grey.withValues(alpha: 0.05),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                            const Gap(4),
                            Text(
                              'Không có ảnh',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Product content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    
                    // Product name (2 lines max) - moved near button
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Gap(6),
                    
                    // Contact button - shortened text
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: VNLButton(
                        style: ButtonVariance.destructive,
                        onPressed: () {
                          _showContactDialog(context, product);
                        },
                        child: const Text(
                          'Báo giá',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTags(BuildContext context, List<String> tags) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags.take(3).map((tag) {
        Color tagColor;
        switch (tag) {
          case 'Mall':
            tagColor = Colors.teal;
            break;
          case 'Hỗ trợ 24/7':
            tagColor = Colors.blue;
            break;
          case 'Hoàn tiền':
            tagColor = Colors.pink;
            break;
          default:
            tagColor = Colors.grey;
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: tagColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w500,
              color: tagColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: VNLTheme.of(context).colorScheme.mutedForeground,
          ),
          const Gap(16),
          Text(
            'Không có sản phẩm nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
          const Gap(8),
          Text(
            'Hiện tại danh mục này chưa có sản phẩm',
            style: TextStyle(
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => VNLAlertDialog(
        title: Text('Liên hệ báo giá'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sản phẩm: ${product.name}'),
            const Gap(8),
            Text('Hotline: ${product.contactInfo}'),
            const Gap(8),
            const Text('Hoặc để lại thông tin, chúng tôi sẽ liên hệ lại:'),
          ],
        ),
        actions: [
          VNLButton(
            style: ButtonVariance.secondary,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
          VNLButton(
            style: ButtonVariance.primary,
            onPressed: () {
              Navigator.of(context).pop();
              // Open phone dialer or contact form
            },
            child: const Text('Gọi ngay'),
          ),
        ],
      ),
    );
  }
} 