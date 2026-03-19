import 'package:flutter/material.dart';
import 'spacing.dart';

/// Yendo Design System — Grid System
///
/// A responsive column grid for laying out content on mobile screens.
/// Mobile-first: defaults to 4 columns on phones, 8 on tablets.
///
/// ─────────────────────────────────────────────────────────────────────────────
/// BREAKPOINTS
///   xs   < 360px   — small phones (SE, older Android)
///   sm   < 480px   — standard phones (iPhone 14, Pixel)
///   md   < 768px   — large phones / small tablets
///   lg   ≥ 768px   — tablets
///
/// COLUMN COUNTS
///   xs / sm  → 4 columns
///   md       → 6 columns
///   lg       → 12 columns
///
/// GUTTER
///   xs / sm  → 16px
///   md / lg  → 24px
///
/// MARGIN (screen edge)
///   xs       → 16px
///   sm / md  → 24px
///   lg       → 32px
/// ─────────────────────────────────────────────────────────────────────────────
///
/// USAGE — Basic grid row:
///   AppGrid(
///     children: [
///       GridItem(span: 2, child: MyWidget()),
///       GridItem(span: 2, child: MyWidget()),
///     ],
///   )
///
/// USAGE — Auto-responsive 2-column layout:
///   AppGrid.twoColumn(
///     left: LeftWidget(),
///     right: RightWidget(),
///   )
///
/// USAGE — Just get the screen padding in any widget:
///   Padding(
///     padding: AppGrid.of(context).insets,
///     child: ...,
///   )

// ─────────────────────────────────────────────────────────────────────────────
// Breakpoints
// ─────────────────────────────────────────────────────────────────────────────

enum AppBreakpoint { xs, sm, md, lg }

extension AppBreakpointExtension on AppBreakpoint {
  bool get isPhone => this == AppBreakpoint.xs || this == AppBreakpoint.sm;
  bool get isTablet => this == AppBreakpoint.md || this == AppBreakpoint.lg;
}

// ─────────────────────────────────────────────────────────────────────────────
// GridConfig — resolved grid values for a given screen width
// ─────────────────────────────────────────────────────────────────────────────

class GridConfig {
  const GridConfig._({
    required this.breakpoint,
    required this.columns,
    required this.gutter,
    required this.margin,
    required this.screenWidth,
  });

  final AppBreakpoint breakpoint;
  final int columns;
  final double gutter;
  final double margin;
  final double screenWidth;

  /// Horizontal insets for full-screen content
  EdgeInsets get insets => EdgeInsets.symmetric(horizontal: margin);

  /// Width of a single column (excluding gutters)
  double get columnWidth =>
      (screenWidth - (margin * 2) - (gutter * (columns - 1))) / columns;

  /// Width of a widget spanning [span] columns
  double widthForSpan(int span) =>
      (columnWidth * span) + (gutter * (span - 1));

  factory GridConfig.fromWidth(double width) {
    if (width < 360) {
      return GridConfig._(
        breakpoint: AppBreakpoint.xs,
        columns: 4,
        gutter: AppSpacing.md,
        margin: AppSpacing.md,
        screenWidth: width,
      );
    } else if (width < 480) {
      return GridConfig._(
        breakpoint: AppBreakpoint.sm,
        columns: 4,
        gutter: AppSpacing.md,
        margin: AppSpacing.lg,
        screenWidth: width,
      );
    } else if (width < 768) {
      return GridConfig._(
        breakpoint: AppBreakpoint.md,
        columns: 6,
        gutter: AppSpacing.lg,
        margin: AppSpacing.lg,
        screenWidth: width,
      );
    } else {
      return GridConfig._(
        breakpoint: AppBreakpoint.lg,
        columns: 12,
        gutter: AppSpacing.lg,
        margin: AppSpacing.xl,
        screenWidth: width,
      );
    }
  }

  factory GridConfig.of(BuildContext context) {
    return GridConfig.fromWidth(MediaQuery.of(context).size.width);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GridItem — defines how many columns a child spans
// ─────────────────────────────────────────────────────────────────────────────

class GridItem {
  const GridItem({
    required this.child,
    this.span = 1,
    this.spanSm,
    this.spanMd,
    this.spanLg,
  });

  final Widget child;

  /// Default column span
  final int span;

  /// Override span for sm breakpoint
  final int? spanSm;

  /// Override span for md breakpoint
  final int? spanMd;

  /// Override span for lg breakpoint
  final int? spanLg;

  int resolveSpan(AppBreakpoint breakpoint) {
    switch (breakpoint) {
      case AppBreakpoint.xs:
        return span;
      case AppBreakpoint.sm:
        return spanSm ?? span;
      case AppBreakpoint.md:
        return spanMd ?? spanSm ?? span;
      case AppBreakpoint.lg:
        return spanLg ?? spanMd ?? spanSm ?? span;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppGrid — the main grid widget
// ─────────────────────────────────────────────────────────────────────────────

class AppGrid extends StatelessWidget {
  const AppGrid({
    super.key,
    required this.children,
    this.applyMargin = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.runSpacing,
  });

  final List<GridItem> children;

  /// Whether to apply the margin (screen edge padding).
  /// Set false if a parent already handles padding.
  final bool applyMargin;

  final CrossAxisAlignment crossAxisAlignment;

  /// Vertical gap between rows. Defaults to the grid gutter.
  final double? runSpacing;

  /// Convenience: two equal columns
  factory AppGrid.twoColumn({
    Key? key,
    required Widget left,
    required Widget right,
    bool applyMargin = true,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    double? runSpacing,
  }) {
    return AppGrid(
      key: key,
      applyMargin: applyMargin,
      crossAxisAlignment: crossAxisAlignment,
      runSpacing: runSpacing,
      children: [
        GridItem(child: left, span: 2, spanLg: 6),
        GridItem(child: right, span: 2, spanLg: 6),
      ],
    );
  }

  /// Convenience: three equal columns (stacks to 1 col on xs/sm)
  factory AppGrid.threeColumn({
    Key? key,
    required List<Widget> items,
    bool applyMargin = true,
  }) {
    return AppGrid(
      key: key,
      applyMargin: applyMargin,
      children: items
          .map((w) => GridItem(child: w, span: 4, spanMd: 2, spanLg: 4))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final config = GridConfig.fromWidth(constraints.maxWidth +
            (applyMargin ? 0 : GridConfig.of(context).margin * 2));

        final hPadding = applyMargin ? config.margin : 0.0;
        final vGap = runSpacing ?? config.gutter;

        // Build rows by wrapping items when column count is exceeded
        final rows = <List<GridItem>>[];
        var currentRow = <GridItem>[];
        var currentSpan = 0;

        for (final item in children) {
          final span = item.resolveSpan(config.breakpoint).clamp(1, config.columns);
          if (currentSpan + span > config.columns) {
            if (currentRow.isNotEmpty) rows.add(currentRow);
            currentRow = [item];
            currentSpan = span;
          } else {
            currentRow.add(item);
            currentSpan += span;
          }
        }
        if (currentRow.isNotEmpty) rows.add(currentRow);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[
                Row(
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    for (int i = 0; i < rows[rowIndex].length; i++) ...[
                      Expanded(
                        flex: rows[rowIndex][i]
                            .resolveSpan(config.breakpoint)
                            .clamp(1, config.columns),
                        child: rows[rowIndex][i].child,
                      ),
                      if (i < rows[rowIndex].length - 1)
                        SizedBox(width: config.gutter),
                    ],
                  ],
                ),
                if (rowIndex < rows.length - 1) SizedBox(height: vGap),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppScreenPadding — wraps content in the correct responsive screen margin
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps its child in the correct horizontal screen padding for the
/// current screen width. Use at the page/section level.
///
/// Example:
///   AppScreenPadding(child: MyContent())
class AppScreenPadding extends StatelessWidget {
  const AppScreenPadding({
    super.key,
    required this.child,
    this.vertical = 0,
  });

  final Widget child;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    final config = GridConfig.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: config.margin,
        vertical: vertical,
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Responsive — show different widgets per breakpoint
// ─────────────────────────────────────────────────────────────────────────────

/// Renders a different widget based on screen breakpoint.
///
/// Example:
///   Responsive(
///     mobile: MobileLayout(),
///     tablet: TabletLayout(),
///   )
class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
  });

  final Widget mobile;

  /// Falls back to [mobile] if not provided
  final Widget? tablet;

  @override
  Widget build(BuildContext context) {
    final config = GridConfig.of(context);
    if (config.breakpoint.isTablet && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ResponsiveValue — pick a value based on breakpoint
// ─────────────────────────────────────────────────────────────────────────────

/// Resolves a value based on the current screen breakpoint.
///
/// Example:
///   fontSize: ResponsiveValue.of(context, mobile: 16, tablet: 20)
class ResponsiveValue {
  const ResponsiveValue._();

  static T of<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
  }) {
    final config = GridConfig.of(context);
    if (config.breakpoint.isTablet && tablet != null) return tablet;
    return mobile;
  }
}
