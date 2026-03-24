import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';
import '../spacing.dart';

/// Yendo Design System — App Tables
///
/// Four table components, all mobile-first and responsive:
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │  1. AppComparisonTable   Compare 2–4 options side by side               │
/// │     .twoColumn()         2 options  — full-width, no scroll             │
/// │     .threeColumn()       3 options  — full-width on most phones         │
/// │     .fourColumn()        4 options  — auto-scrolls on small screens     │
/// │                                                                         │
/// │  2. AppDataTable         General-purpose rows/columns with scroll       │
/// │                                                                         │
/// │  3. AppStackedTable      Each row → card. Best for < 360px screens      │
/// └─────────────────────────────────────────────────────────────────────────┘
///
/// COLUMN LAYOUT GUIDE
/// ───────────────────
/// 2 columns → label 40% | col1 30% | col2 30%
/// 3 columns → label 35% | col1 21% | col2 21% | col3 21%  (auto-scroll if needed)
/// 4 columns → label 30% | col1 17% | col2 17% | col3 17% | col4 17%  (always scrollable on phones)
///
/// All variants:
///   • Pin the feature label column on the left — never scrolls away
///   • Highlighted column stays visually prominent
///   • "yes"/"no" → ✓/✗ icons automatically
///   • isHighlightRow → bold text + tinted background

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class ComparisonRow {
  const ComparisonRow({
    required this.label,
    required this.values,
    this.isHighlightRow = false,
    this.labelIcon,
  });

  /// Feature name shown in the pinned left column
  final String label;

  /// One value per option column (e.g. 2, 3, or 4 values)
  final List<String> values;

  /// Highlights this row (bold + tinted background)
  final bool isHighlightRow;

  /// Optional leading icon in the label column
  final IconData? labelIcon;
}

// ─────────────────────────────────────────────────────────────────────────────
// Column count enum
// ─────────────────────────────────────────────────────────────────────────────

enum TableColumnCount {
  two,   // 2 option columns
  three, // 3 option columns
  four,  // 4 option columns
}

extension _TableColumnCountX on TableColumnCount {
  int get count {
    switch (this) {
      case TableColumnCount.two:   return 2;
      case TableColumnCount.three: return 3;
      case TableColumnCount.four:  return 4;
    }
  }

  /// Width of the pinned label column (responsive)
  double labelWidth(double screenWidth) {
    switch (this) {
      case TableColumnCount.two:   return screenWidth < 360 ? 100 : 120;
      case TableColumnCount.three: return screenWidth < 360 ? 90  : 108;
      case TableColumnCount.four:  return screenWidth < 360 ? 80  : 96;
    }
  }

  /// Width of each option column
  double optionWidth(double screenWidth) {
    switch (this) {
      case TableColumnCount.two:   return screenWidth < 360 ? 100 : 120;
      case TableColumnCount.three: return screenWidth < 360 ? 88  : 104;
      case TableColumnCount.four:  return screenWidth < 360 ? 80  : 96;
    }
  }

  /// Minimum screen width before horizontal scrolling kicks in
  double minWidthBeforeScroll() {
    switch (this) {
      case TableColumnCount.two:   return 260; // rarely scrolls
      case TableColumnCount.three: return 340; // scrolls on very small phones
      case TableColumnCount.four:  return 440; // almost always scrolls on phones
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. AppComparisonTable
// ─────────────────────────────────────────────────────────────────────────────

/// A mobile-first side-by-side comparison table.
///
/// Supports 2, 3, or 4 option columns via named constructors.
/// The feature label column is always pinned on the left.
///
/// USAGE — 2 columns:
///   AppComparisonTable.twoColumn(
///     options: ['Current loan', 'New offer'],
///     rows: [
///       ComparisonRow(label: 'Monthly payment', values: ['\$312', '\$234']),
///       ComparisonRow(label: 'APR', values: ['18.9%', '12.5%']),
///     ],
///     highlightColumn: 1,
///   )
///
/// USAGE — 3 columns:
///   AppComparisonTable.threeColumn(
///     options: ['Basic', 'Standard', 'Premium'],
///     highlightColumn: 1,
///     highlightLabel: 'Popular',
///     rows: [...],
///   )
///
/// USAGE — 4 columns:
///   AppComparisonTable.fourColumn(
///     options: ['Option A', 'Option B', 'Option C', 'Option D'],
///     highlightColumn: 2,
///     rows: [...],
///   )

class AppComparisonTable extends StatelessWidget {
  AppComparisonTable({
    super.key,
    required this.options,
    required this.rows,
    required this.columnCount,
    this.highlightColumn,
    this.highlightLabel = 'Best',
    this.showBadge = true,
    this.headerHeight = 64.0,
  }) : assert(
          options.length == columnCount.count,
          'options.length must match columnCount',
        );

  /// Named constructor — 2 option columns
  factory AppComparisonTable.twoColumn({
    Key? key,
    required List<String> options,
    required List<ComparisonRow> rows,
    int? highlightColumn,
    String highlightLabel = 'Best',
    bool showBadge = true,
  }) {
    assert(options.length == 2, 'twoColumn requires exactly 2 options');
    return AppComparisonTable(
      key: key,
      options: options,
      rows: rows,
      columnCount: TableColumnCount.two,
      highlightColumn: highlightColumn,
      highlightLabel: highlightLabel,
      showBadge: showBadge,
    );
  }

  /// Named constructor — 3 option columns
  factory AppComparisonTable.threeColumn({
    Key? key,
    required List<String> options,
    required List<ComparisonRow> rows,
    int? highlightColumn,
    String highlightLabel = 'Best',
    bool showBadge = true,
  }) {
    assert(options.length == 3, 'threeColumn requires exactly 3 options');
    return AppComparisonTable(
      key: key,
      options: options,
      rows: rows,
      columnCount: TableColumnCount.three,
      highlightColumn: highlightColumn,
      highlightLabel: highlightLabel,
      showBadge: showBadge,
    );
  }

  /// Named constructor — 4 option columns
  factory AppComparisonTable.fourColumn({
    Key? key,
    required List<String> options,
    required List<ComparisonRow> rows,
    int? highlightColumn,
    String highlightLabel = 'Best',
    bool showBadge = true,
  }) {
    assert(options.length == 4, 'fourColumn requires exactly 4 options');
    return AppComparisonTable(
      key: key,
      options: options,
      rows: rows,
      columnCount: TableColumnCount.four,
      highlightColumn: highlightColumn,
      highlightLabel: highlightLabel,
      showBadge: showBadge,
    );
  }

  final List<String> options;
  final List<ComparisonRow> rows;
  final TableColumnCount columnCount;
  final int? highlightColumn;
  final String highlightLabel;
  final bool showBadge;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final labelWidth = columnCount.labelWidth(screenWidth);
        final optionWidth = columnCount.optionWidth(screenWidth);
        final totalContentWidth = labelWidth + (optionWidth * columnCount.count);
        final needsScroll = totalContentWidth > screenWidth;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: needsScroll
              ? _buildScrollable(labelWidth, optionWidth)
              : _buildFixed(labelWidth),
        );
      },
    );
  }

  // ── Scrollable: label column pinned, options scroll ────────

  Widget _buildScrollable(double labelWidth, double optionWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pinned label column
        SizedBox(
          width: labelWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EmptyHeader(height: headerHeight),
              ...rows.asMap().entries.map((e) => _LabelCell(
                    label: e.value.label,
                    icon: e.value.labelIcon,
                    isEven: e.key.isEven,
                    isHighlightRow: e.value.isHighlightRow,
                  )),
            ],
          ),
        ),
        // Scrollable option columns
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options.asMap().entries.map((entry) {
                return SizedBox(
                  width: optionWidth,
                  child: _OptionColumn(
                    label: entry.value,
                    colIndex: entry.key,
                    rows: rows,
                    highlightColumn: highlightColumn,
                    highlightLabel: highlightLabel,
                    showBadge: showBadge,
                    headerHeight: headerHeight,
                    isLast: entry.key == options.length - 1,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // ── Fixed: Flutter Table widget — guarantees equal row heights ─

  Widget _buildFixed(double labelWidth) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FixedColumnWidth(labelWidth),
        for (int i = 1; i <= options.length; i++)
          i: const FlexColumnWidth(),
      },
      border: TableBorder.all(
        color: AppColors.neutralN100,
        width: 0.5,
      ),
      children: [
        // Header row
        TableRow(
          children: [
            // Empty top-left cell — use same height anchor as option headers
            _EmptyHeader(height: headerHeight),
            for (int i = 0; i < options.length; i++)
              _OptionHeader(
                label: options[i],
                isHighlighted: i == highlightColumn,
                badgeLabel: showBadge && i == highlightColumn ? highlightLabel : null,
              ),
          ],
        ),
        // Data rows
        for (int rowIndex = 0; rowIndex < rows.length; rowIndex++)
          TableRow(
            children: [
              _LabelCell(
                label: rows[rowIndex].label,
                icon: rows[rowIndex].labelIcon,
                isEven: rowIndex.isEven,
                isHighlightRow: rows[rowIndex].isHighlightRow,
              ),
              for (int c = 0; c < options.length; c++)
                _ValueCell(
                  value: c < rows[rowIndex].values.length
                      ? rows[rowIndex].values[c]
                      : '—',
                  isHighlighted: c == highlightColumn,
                  isEven: rowIndex.isEven,
                  isHighlightRow: rows[rowIndex].isHighlightRow,
                ),
            ],
          ),
      ],
    );
  }
}

// ── Option column widget (used in scrollable mode) ──────────

class _OptionColumn extends StatelessWidget {
  const _OptionColumn({
    required this.label,
    required this.colIndex,
    required this.rows,
    required this.highlightColumn,
    required this.highlightLabel,
    required this.showBadge,
    required this.headerHeight,
    required this.isLast,
  });

  final String label;
  final int colIndex;
  final List<ComparisonRow> rows;
  final int? highlightColumn;
  final String highlightLabel;
  final bool showBadge;
  final double headerHeight;
  final bool isLast;

  bool get _isHighlighted => colIndex == highlightColumn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OptionHeader(
          label: label,
          isHighlighted: _isHighlighted,
          badgeLabel: showBadge && _isHighlighted ? highlightLabel : null,
          isLast: isLast,
        ),
        ...rows.asMap().entries.map((rowEntry) => _ValueCell(
              value: colIndex < rowEntry.value.values.length
                  ? rowEntry.value.values[colIndex]
                  : '—',
              isHighlighted: _isHighlighted,
              isEven: rowEntry.key.isEven,
              isHighlightRow: rowEntry.value.isHighlightRow,
              isLast: isLast,
            )),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared cell widgets
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyHeader extends StatelessWidget {
  const _EmptyHeader({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: AppColors.neutralN50,
    );
  }
}

class _OptionHeader extends StatelessWidget {
  const _OptionHeader({
    required this.label,
    required this.isHighlighted,
    this.badgeLabel,
    // isLast kept for scrollable layout compatibility
    this.isLast = false,
  });

  final String label;
  final bool isHighlighted;
  final String? badgeLabel;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: isHighlighted ? AppColors.navy : AppColors.neutralN50,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeLabel != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryO400,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              child: Text(
                badgeLabel!,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: isHighlighted ? AppColors.white : AppColors.navy,
              height: 1.3,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _LabelCell extends StatelessWidget {
  const _LabelCell({
    required this.label,
    required this.isEven,
    required this.isHighlightRow,
    this.icon,
  });

  final String label;
  final bool isEven;
  final bool isHighlightRow;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      color: isHighlightRow
          ? AppColors.primaryO400.withOpacity(0.06)
          : isEven
              ? AppColors.white
              : AppColors.neutralN50,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.neutralN500),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.neutralN500,
                fontWeight:
                    isHighlightRow ? FontWeight.w600 : FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  const _ValueCell({
    required this.value,
    required this.isHighlighted,
    required this.isEven,
    required this.isHighlightRow,
    // isLast kept for scrollable layout compatibility
    this.isLast = false,
  });

  final String value;
  final bool isHighlighted;
  final bool isEven;
  final bool isHighlightRow;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final bgColor = isHighlighted
        ? (isHighlightRow
            ? AppColors.navy.withOpacity(0.12)
            : isEven
                ? AppColors.navy.withOpacity(0.04)
                : AppColors.navy.withOpacity(0.08))
        : (isHighlightRow
            ? AppColors.primaryO400.withOpacity(0.06)
            : isEven
                ? AppColors.white
                : AppColors.neutralN50);

    Widget child;
    final lower = value.toLowerCase().trim();
    if (lower == 'yes' || lower == 'true' || lower == '✓') {
      child = Icon(Icons.check_circle_rounded, color: AppColors.green400, size: 18);
    } else if (lower == 'no' || lower == 'false' || lower == '✗') {
      child = Icon(Icons.cancel_rounded, color: AppColors.neutralN200, size: 18);
    } else {
      child = Text(
        value,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          fontWeight: isHighlightRow ? FontWeight.w600 : FontWeight.w500,
          color: AppColors.navy,
          height: 1.3,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      color: bgColor,
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. AppDataTable — general-purpose rows × columns
// ─────────────────────────────────────────────────────────────────────────────

/// A general-purpose data table with horizontal scroll for wide content.
/// Supports up to any number of columns — pinches to fit on screen when possible,
/// scrolls horizontally when it doesn't.
///
/// USAGE:
///   AppDataTable(
///     columns: ['Date', 'Description', 'Amount', 'Status'],
///     rows: [
///       ['Mar 1, 2026', 'Monthly payment', '\$234.78', 'Paid'],
///       ['Feb 1, 2026', 'Monthly payment', '\$234.78', 'Late'],
///     ],
///     statusColumn: 3,   // column index where status badges appear
///     highlightedRowIndex: 1,
///   )

class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnWidths,
    this.onRowTap,
    this.highlightedRowIndex,
    this.statusColumn,
    this.minColumnWidth = 80.0,
    this.pinnedFirstColumn = true,
  });

  final List<String> columns;
  final List<List<String>> rows;

  /// Optional explicit widths per column
  final List<double>? columnWidths;

  final ValueChanged<int>? onRowTap;
  final int? highlightedRowIndex;

  /// Column index whose values render as status badges (Paid/Late/Pending)
  final int? statusColumn;

  final double minColumnWidth;

  /// Keep the first column pinned when scrolling (like a spreadsheet)
  final bool pinnedFirstColumn;

  @override
  Widget build(BuildContext context) {
    final colWidths =
        columnWidths ?? List.filled(columns.length, minColumnWidth);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth =
            colWidths.fold<double>(0, (a, b) => a + b);
        final needsScroll = totalWidth > constraints.maxWidth;

        Widget buildHeader({bool scrollable = false}) => Container(
              color: AppColors.navy,
              child: Row(
                children: columns.asMap().entries.map((entry) {
                  final w = colWidths[entry.key];
                  final cell = _HeaderCell(label: entry.value);
                  return scrollable
                      ? SizedBox(width: w, child: cell)
                      : Expanded(child: cell);
                }).toList(),
              ),
            );

        Widget buildRow(int rowIndex) {
          final row = rows[rowIndex];
          final isEven = rowIndex.isEven;
          final isHighlighted = rowIndex == highlightedRowIndex;

          return InkWell(
            onTap: onRowTap != null ? () => onRowTap!(rowIndex) : null,
            child: Container(
              color: isHighlighted
                  ? AppColors.primaryO400.withOpacity(0.08)
                  : isEven
                      ? AppColors.white
                      : AppColors.neutralN50,
              child: Row(
                children: columns.asMap().entries.map((colEntry) {
                  final colIndex = colEntry.key;
                  final value =
                      colIndex < row.length ? row[colIndex] : '';
                  final w = colWidths[colIndex];
                  final cell = colIndex == statusColumn
                      ? _StatusCell(value: value)
                      : _DataCell(
                          value: value,
                          isFirst: colIndex == 0,
                        );
                  return needsScroll
                      ? SizedBox(width: w, child: cell)
                      : Expanded(child: cell);
                }).toList(),
              ),
            ),
          );
        }

        Widget table;
        if (needsScroll && pinnedFirstColumn && columns.length > 1) {
          // Pinned first column + scrollable rest
          final firstColWidth = colWidths[0];
          final restWidth =
              colWidths.sublist(1).fold<double>(0, (a, b) => a + b);

          table = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pinned column
              SizedBox(
                width: firstColWidth,
                child: Column(
                  children: [
                    Container(
                      color: AppColors.navy,
                      child: _HeaderCell(label: columns[0]),
                    ),
                    ...List.generate(rows.length, (i) {
                      final isEven = i.isEven;
                      final isHighlighted = i == highlightedRowIndex;
                      final value =
                          rows[i].isNotEmpty ? rows[i][0] : '';
                      return InkWell(
                        onTap: onRowTap != null ? () => onRowTap!(i) : null,
                        child: Container(
                          color: isHighlighted
                              ? AppColors.primaryO400.withOpacity(0.08)
                              : isEven
                                  ? AppColors.white
                                  : AppColors.neutralN50,
                          child: _DataCell(value: value, isFirst: true),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // Scrollable rest
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: restWidth,
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.navy,
                          child: Row(
                            children: columns
                                .sublist(1)
                                .asMap()
                                .entries
                                .map((e) => SizedBox(
                                      width: colWidths[e.key + 1],
                                      child:
                                          _HeaderCell(label: e.value),
                                    ))
                                .toList(),
                          ),
                        ),
                        ...List.generate(rows.length, (i) {
                          final row = rows[i];
                          final isEven = i.isEven;
                          final isHighlighted = i == highlightedRowIndex;
                          return InkWell(
                            onTap: onRowTap != null
                                ? () => onRowTap!(i)
                                : null,
                            child: Container(
                              color: isHighlighted
                                  ? AppColors.primaryO400.withOpacity(0.08)
                                  : isEven
                                      ? AppColors.white
                                      : AppColors.neutralN50,
                              child: Row(
                                children: columns
                                    .sublist(1)
                                    .asMap()
                                    .entries
                                    .map((colEntry) {
                                  final colIndex = colEntry.key + 1;
                                  final value = colIndex < row.length
                                      ? row[colIndex]
                                      : '';
                                  return SizedBox(
                                    width: colWidths[colIndex],
                                    child: colIndex == statusColumn
                                        ? _StatusCell(value: value)
                                        : _DataCell(value: value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (needsScroll) {
          table = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalWidth,
              child: Column(
                children: [
                  buildHeader(scrollable: true),
                  ...List.generate(rows.length, buildRow),
                ],
              ),
            ),
          );
        } else {
          table = Column(
            children: [
              buildHeader(),
              ...List.generate(rows.length, buildRow),
            ],
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: table,
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          letterSpacing: 0.3,
          height: 1.3,
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell({required this.value, this.isFirst = false});
  final String value;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        value,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 13,
          fontWeight: isFirst ? FontWeight.w500 : FontWeight.w400,
          color: AppColors.navy,
          height: 1.3,
        ),
      ),
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (value.toLowerCase()) {
      case 'paid':
        color = AppColors.green400;
        break;
      case 'late':
      case 'overdue':
      case 'failed':
        color = AppColors.red400;
        break;
      case 'pending':
      case 'processing':
        color = AppColors.yellow500;
        break;
      default:
        color = AppColors.neutralN500;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. AppStackedTable — each row becomes a card
// ─────────────────────────────────────────────────────────────────────────────

/// Stacked card table — best for very narrow screens or detail views.
/// Each item in [items] becomes its own card with label/value rows inside.
///
/// USAGE:
///   AppStackedTable(
///     items: [
///       {'Loan amount': '\$12,000', 'APR': '12.5%', 'Term': '36 months'},
///       {'Next payment': 'Apr 1, 2026', 'Balance': '\$10,418'},
///     ],
///   )

class AppStackedTable extends StatelessWidget {
  const AppStackedTable({
    super.key,
    required this.items,
    this.title,
  });

  final List<Map<String, String>> items;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: AppColors.neutralN500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        ...items.map((item) => _StackedCard(item: item)),
      ],
    );
  }
}

class _StackedCard extends StatelessWidget {
  const _StackedCard({required this.item});
  final Map<String, String> item;

  @override
  Widget build(BuildContext context) {
    final entries = item.entries.toList();
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: entries.asMap().entries.map((e) {
          final isLast = e.key == entries.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.listRowPaddingV),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.value.key,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: AppColors.neutralN500,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      e.value.value,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.neutralN100),
            ],
          );
        }).toList(),
      ),
    );
  }
}
