import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class BrowsePaginationTop extends StatelessWidget {
  final int itemsPerPage;
  final ValueChanged<int> onChanged;

  const BrowsePaginationTop({
    super.key,
    required this.itemsPerPage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1-100 of 1,240 results',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Row(
          children: [
            const Text(
              'Items per page:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.searchBarBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.dividerColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: itemsPerPage,
                  dropdownColor: AppColors.background,
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
                  ),
                  style: const TextStyle(color: AppColors.primaryAccent, fontSize: 13, fontWeight: FontWeight.w700),
                  items: [10, 20, 30, 50, 100].map((int val) {
                    return DropdownMenuItem<int>(
                      value: val,
                      child: Text('$val'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) onChanged(val);
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class BrowsePaginationBottom extends StatelessWidget {
  const BrowsePaginationBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPageBtn(Icons.chevron_left, true),
        const SizedBox(width: 8),
        _buildPageNum('1', true),
        const SizedBox(width: 8),
        _buildPageNum('2', false),
        const SizedBox(width: 8),
        _buildPageNum('3', false),
        const SizedBox(width: 8),
        const Text('...', style: TextStyle(color: AppColors.textMuted)),
        const SizedBox(width: 8),
        _buildPageNum('13', false),
        const SizedBox(width: 8),
        _buildPageBtn(Icons.chevron_right, false),
      ],
    );
  }

  Widget _buildPageNum(String numText, bool isActive) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? null : Border.all(color: AppColors.dividerColor),
      ),
      alignment: Alignment.center,
      child: Text(
        numText,
        style: TextStyle(
          color: isActive ? AppColors.sidebarBackground : AppColors.textSecondary,
          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildPageBtn(IconData icon, bool isDisabled) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.searchBarBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: isDisabled ? AppColors.textMuted : AppColors.textPrimary, size: 20),
    );
  }
}
