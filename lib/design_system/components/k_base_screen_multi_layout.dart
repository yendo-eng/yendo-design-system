import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../colors.dart';
import '../spacing.dart';
import 'app_mobile_status_bar.dart';

// Matches otto-app breakpoints
const _kWebBreakPoint = 1100.0;
const _kMaxMobileWidth = 473.0;

/// Yendo Design System — KBaseScreenMultiLayout
///
/// Mirrors the KBaseScreenMultiLayout from otto-app.
/// Every screen in this design system should use this as its root widget.
///
/// On wide screens (> 1100px) content is centered in a 473px mobile container,
/// matching how otto-app renders on web.
///
/// Key params:
///   appBar          — optional PreferredSizeWidget (e.g. AppNavBar)
///   header          — optional widget rendered before content, inside scroll
///   content         — required list of body widgets
///   footer          — optional widget at the bottom
///   hasStickyFooter — when true, footer always sticks to the bottom
///   handleScroll    — when false, no scroll view is added (use for layouts with Spacers)
///   contentPadding  — horizontal padding applied to the body (default 24)
///   showStatusBar   — when true, renders a simulated mobile status bar at the top

class KBaseScreenMultiLayout extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? header;
  final List<Widget> content;
  final Widget? footer;
  final bool extendBodyBehindAppBar;
  final bool? extendBodyBehindFooter;
  final double? contentPadding;
  final Color? contentBackgroundColor;
  final Color? footerBackgroundColor;

  /// When false, scroll handling is left to the screen (use when content
  /// contains Spacers or ListView).
  final bool handleScroll;

  /// When true, footer always sticks to the bottom of the screen.
  final bool hasStickyFooter;

  /// When true, shows a simulated mobile status bar (time, signal, battery)
  /// at the top of the screen — useful for web/desktop prototyping.
  final bool showStatusBar;

  /// Background color for the status bar. Defaults to [contentBackgroundColor].
  final Color? statusBarBackgroundColor;

  const KBaseScreenMultiLayout({
    Key? key,
    this.appBar,
    this.header,
    required this.content,
    this.footer,
    this.handleScroll = true,
    this.hasStickyFooter = false,
    this.extendBodyBehindAppBar = false,
    this.extendBodyBehindFooter,
    this.contentPadding,
    this.contentBackgroundColor,
    this.footerBackgroundColor,
    this.showStatusBar = false,
    this.statusBarBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > _kWebBreakPoint;

    if (isWeb) {
      return Material(
        color: AppColors.neutralN75,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: _kMaxMobileWidth),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                size: Size(_kMaxMobileWidth, MediaQuery.of(context).size.height),
              ),
              child: _mobileLayout(context),
            ),
          ),
        ),
      );
    }

    return _mobileLayout(context);
  }

  Widget _mobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: contentBackgroundColor,
      body: SafeArea(
        top: !extendBodyBehindAppBar,
        bottom: hasStickyFooter
            ? false
            : extendBodyBehindFooter != null
                ? !extendBodyBehindFooter!
                : !extendBodyBehindAppBar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Simulated mobile status bar ───────────────────
            if (showStatusBar)
              AppMobileStatusBar(
                backgroundColor: statusBarBackgroundColor ??
                    contentBackgroundColor ??
                    AppColors.white,
              ),

            // ── App bar rendered as a widget so it always shows ──
            if (appBar != null)
              SizedBox(
                height: appBar!.preferredSize.height,
                child: appBar!,
              ),

            // ── Body ─────────────────────────────────────────────
            Expanded(
              child: Padding(
                // Only left padding here — right padding moves inside the
                // scroll view so the scrollbar has room on the right edge.
                padding: EdgeInsets.only(
                  left: contentPadding ?? AppSpacing.screenPaddingH,
                ),
                child: handleScroll
                    ? _StickyFooterScrollView(
                        footer: footer ?? const SizedBox(),
                        hasStickyFooter: hasStickyFooter,
                        footerBackgroundColor: footerBackgroundColor,
                        rightPadding: contentPadding ?? AppSpacing.screenPaddingH,
                        children: [
                          if (header != null) header!,
                          ...content,
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                          right: contentPadding ?? AppSpacing.screenPaddingH,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (header != null) header!,
                            ...content,
                            if (footer != null) footer!,
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sticky footer scroll view ──────────────────────────────

class _StickyFooterScrollView extends StatefulWidget {
  final List<Widget> children;
  final Widget footer;
  final Color? footerBackgroundColor;
  final bool hasStickyFooter;
  final double rightPadding;

  const _StickyFooterScrollView({
    required this.footer,
    required this.children,
    this.hasStickyFooter = false,
    this.footerBackgroundColor,
    this.rightPadding = 0,
  });

  @override
  State<_StickyFooterScrollView> createState() =>
      _StickyFooterScrollViewState();
}

class _StickyFooterScrollViewState extends State<_StickyFooterScrollView> {
  double? _width;
  double? _height;

  @override
  Widget build(BuildContext context) {
    if (widget.hasStickyFooter) {
      // Footer always sticks to bottom; content scrolls above it.
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: widget.rightPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ),
          widget.footer,
        ],
      );
    }

    // Smart sticky: footer sticks to bottom when content is short,
    // scrolls with content when content is tall.
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(right: widget.rightPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: _height ?? double.maxFinite),
          child: CustomMultiChildLayout(
            delegate: _StickyFooterDelegate(
              constraint.maxHeight,
              constraint.maxWidth,
              (width, height) {
                if (width != _width || height != _height) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _width = width;
                        _height = height;
                      });
                    }
                  });
                }
              },
            ),
            children: [
              LayoutId(
                id: _StickySection.body,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.children,
                ),
              ),
              LayoutId(
                id: _StickySection.footer,
                child: widget.footer,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _StickyFooterDelegate extends MultiChildLayoutDelegate {
  final double height;
  final double width;
  final Function updateSize;

  _StickyFooterDelegate(this.height, this.width, this.updateSize);

  @override
  void performLayout(Size size) {
    Size leadingSize = Size.zero;

    if (hasChild(_StickySection.body)) {
      leadingSize = layoutChild(
        _StickySection.body,
        BoxConstraints(maxWidth: width),
      );
      positionChild(_StickySection.body, Offset.zero);
    }

    if (hasChild(_StickySection.footer)) {
      final footerSize = layoutChild(
        _StickySection.footer,
        BoxConstraints(maxWidth: width),
      );
      final remaining = height - leadingSize.height - footerSize.height;
      if (remaining > 0) {
        positionChild(
          _StickySection.footer,
          Offset(0, height - footerSize.height),
        );
        updateSize(width, height);
      } else {
        positionChild(
          _StickySection.footer,
          Offset(0, leadingSize.height),
        );
        updateSize(width, leadingSize.height + footerSize.height);
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}

enum _StickySection { body, footer }
