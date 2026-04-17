import 'package:flutter/material.dart';
import 'design_system/design_system.dart';
import 'features/offers/screens/fpo_application_screen.dart';
import 'features/offers/screens/auto_refi_v2_hub.dart';
import 'features/offers/models/card_offer.dart';


void main() {
  runApp(const DesignSystemApp());
}

class DesignSystemApp extends StatelessWidget {
  const DesignSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yendo Design System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: 'PPNeueMontreal',
      ),
      home: const AutoRefiV2Hub(),
    );
  }
}

// ── Home: component list ────────────────────────────────────

class ShowcaseHome extends StatelessWidget {
  const ShowcaseHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralN50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back arrow
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Icon(Icons.arrow_back_ios, size: 20, color: AppColors.navy),
                ),
              ),

              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'Yendo\nDesign System',
                  style: AppTextStyles.heading2.copyWith(color: AppColors.white),
                ),
              ),

              const SizedBox(height: 32),
              _SectionTitle('Components'),
              const SizedBox(height: 16),

              _ComponentTile(
                label: 'Buttons',
                icon: Icons.smart_button_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _ButtonsPage())),
              ),
              _ComponentTile(
                label: 'Cards',
                icon: Icons.credit_card_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _CardsPage())),
              ),
              _ComponentTile(
                label: 'Bottom Sheet',
                icon: Icons.open_in_browser_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _BottomSheetPage())),
              ),
              _ComponentTile(
                label: 'Nav Bar & Back Button',
                icon: Icons.arrow_back_ios_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _NavBarPage())),
              ),
              _ComponentTile(
                label: 'Progress Bar',
                icon: Icons.linear_scale_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _ProgressPage())),
              ),
              _ComponentTile(
                label: 'Text Fields',
                icon: Icons.text_fields_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _TextFieldsPage())),
              ),
              _ComponentTile(
                label: 'Info Rows & Sections',
                icon: Icons.list_alt_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _InfoRowsPage())),
              ),
              _ComponentTile(
                label: 'Tables',
                icon: Icons.table_chart_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _TablesPage())),
              ),
              _ComponentTile(
                label: 'Spacing & Grid',
                icon: Icons.grid_view_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _SpacingGridPage())),
              ),
              _ComponentTile(
                label: '✨ Full Funnel Example',
                icon: Icons.account_tree_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _FunnelStep1())),
              ),
              _ComponentTile(
                label: '🃏 Card Offers Flow',
                icon: Icons.credit_card_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FpoApplicationScreen(
                      selectedOffer: YendoOffers.all.first,
                      allOffers: YendoOffers.all,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Buttons page ────────────────────────────────────────────

class _ButtonsPage extends StatelessWidget {
  const _ButtonsPage();

  @override
  Widget build(BuildContext context) {
    return _ShowcasePage(
      title: 'Buttons',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Default size'),
          const SizedBox(height: 12),
          AppButton(label: 'Primary', onPressed: () {}),
          const SizedBox(height: 12),
          AppButton(label: 'Alternate', variant: AppButtonVariant.alternate, onPressed: () {}),
          const SizedBox(height: 12),
          AppButton(label: 'Tertiary', variant: AppButtonVariant.tertiary, onPressed: () {}),
          const SizedBox(height: 12),
          AppButton(label: 'Link', variant: AppButtonVariant.link, onPressed: () {}),
          const SizedBox(height: 12),
          const AppButton(label: 'Disabled'),
          const SizedBox(height: 32),
          _SectionTitle('Small size'),
          const SizedBox(height: 12),
          AppButton(label: 'Primary small', size: AppButtonSize.small, onPressed: () {}),
          const SizedBox(height: 12),
          AppButton(label: 'Alternate small', variant: AppButtonVariant.alternate, size: AppButtonSize.small, onPressed: () {}),
          const SizedBox(height: 32),
          _SectionTitle('Full width'),
          const SizedBox(height: 12),
          AppButton(label: 'Full width primary', isFullWidth: true, onPressed: () {}),
          const SizedBox(height: 12),
          AppButton(label: 'Full width alternate', variant: AppButtonVariant.alternate, isFullWidth: true, onPressed: () {}),
          const SizedBox(height: 12),
          AppButton(label: 'Full width tertiary', variant: AppButtonVariant.tertiary, isFullWidth: true, onPressed: () {}),
        ],
      ),
    );
  }
}

// ── Cards page ──────────────────────────────────────────────

class _CardsPage extends StatelessWidget {
  const _CardsPage();

  @override
  Widget build(BuildContext context) {
    return _ShowcasePage(
      title: 'Cards',
      child: Column(
        children: [
          _SectionTitle('Normal'),
          const SizedBox(height: 12),
          AppCard(
            amountLabel: 'Amount due',
            amount: '\$234.78',
            footerText: 'Remaining loan balance: \$12,418',
            buttonLabel: 'Manage loan',
            onButtonPressed: () {},
          ),
          const SizedBox(height: 24),
          _SectionTitle('Past due'),
          const SizedBox(height: 12),
          AppCard(
            amountLabel: 'Amount due',
            amount: '\$234.78',
            statusText: '3 days past due',
            isPastDue: true,
            footerText: 'Remaining loan balance: \$12,418',
            buttonLabel: 'Manage loan',
            onButtonPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ── Bottom sheet page ───────────────────────────────────────

class _BottomSheetPage extends StatelessWidget {
  const _BottomSheetPage();

  @override
  Widget build(BuildContext context) {
    return _ShowcasePage(
      title: 'Bottom Sheet',
      child: Column(
        children: [
          AppButton(
            label: 'Simple bottom sheet',
            variant: AppButtonVariant.alternate,
            isFullWidth: true,
            onPressed: () => showAppBottomSheet(
              context: context,
              title: 'Title here',
              description: 'Please make sure your odometer and mileage are clear. Your car must be running for the image to be accepted.',
              buttonLabel: 'Got it',
              onButtonPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Bottom sheet with list',
            isFullWidth: true,
            onPressed: () => showAppBottomSheet(
              context: context,
              title: 'What you\'ll need',
              listItems: [
                const AppBottomSheetItem(icon: Icons.camera_alt_outlined, label: 'Photo ID', description: 'Front and back of your ID'),
                const AppBottomSheetItem(icon: Icons.directions_car_outlined, label: 'Vehicle info', description: 'Make, model, and year'),
                const AppBottomSheetItem(icon: Icons.attach_money, label: 'Bank details', description: 'Routing and account number'),
              ],
              buttonLabel: 'Continue',
              onButtonPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav bar page ────────────────────────────────────────────

class _NavBarPage extends StatelessWidget {
  const _NavBarPage();

  @override
  Widget build(BuildContext context) {
    return _ShowcasePage(
      title: 'Nav Bar & Back Button',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Back only'),
          const SizedBox(height: 8),
          Container(
            color: AppColors.white,
            child: AppNavBar(onBack: () {}),
          ),
          const SizedBox(height: 24),
          _SectionTitle('Back + Title'),
          const SizedBox(height: 8),
          Container(
            color: AppColors.white,
            child: AppNavBar(title: 'Your information', onBack: () {}),
          ),
          const SizedBox(height: 24),
          _SectionTitle('Back + Title + Close'),
          const SizedBox(height: 8),
          Container(
            color: AppColors.white,
            child: AppNavBar(title: 'Review & confirm', onBack: () {}, onClose: () {}),
          ),
          const SizedBox(height: 24),
          _SectionTitle('Close only (first funnel step)'),
          const SizedBox(height: 8),
          Container(
            color: AppColors.white,
            child: AppNavBar(showCloseOnly: true, onClose: () {}),
          ),
          const SizedBox(height: 32),
          _SectionTitle('Standalone back button'),
          const SizedBox(height: 12),
          AppBackButton(onPressed: () {}),
        ],
      ),
    );
  }
}

// ── Progress page ───────────────────────────────────────────

class _ProgressPage extends StatefulWidget {
  const _ProgressPage();

  @override
  State<_ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<_ProgressPage> {
  int _step = 2;
  final int _total = 6;

  @override
  Widget build(BuildContext context) {
    return _ShowcasePage(
      title: 'Progress Bar',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Linear progress bar'),
          const SizedBox(height: 12),
          AppProgressBar(currentStep: _step, totalSteps: _total),
          const SizedBox(height: 8),
          Text('Step $_step of $_total', style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN500)),
          const SizedBox(height: 24),
          _SectionTitle('Segmented step indicator'),
          const SizedBox(height: 12),
          AppStepIndicator(currentStep: _step, totalSteps: _total),
          const SizedBox(height: 8),
          Text('Step $_step of $_total', style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN500)),
          const SizedBox(height: 32),
          Row(
            children: [
              AppButton(
                label: '← Back',
                variant: AppButtonVariant.tertiary,
                onPressed: _step > 1 ? () => setState(() => _step--) : null,
              ),
              const SizedBox(width: 16),
              AppButton(
                label: 'Next →',
                onPressed: _step < _total ? () => setState(() => _step++) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Text fields page ────────────────────────────────────────

class _TextFieldsPage extends StatelessWidget {
  const _TextFieldsPage();

  @override
  Widget build(BuildContext context) {
    return _ShowcasePage(
      title: 'Text Fields',
      child: Column(
        children: [
          const AppTextField(label: 'First name', hint: 'e.g. Jane'),
          const SizedBox(height: 20),
          const AppTextField(label: 'Phone number', hint: '(555) 000-0000', keyboardType: TextInputType.phone),
          const SizedBox(height: 20),
          AppTextField(label: 'Email', hint: 'you@example.com', keyboardType: TextInputType.emailAddress, suffixIcon: Icon(Icons.email_outlined, size: 20, color: AppColors.neutralN500)),
          const SizedBox(height: 20),
          const AppTextField(label: 'Password', hint: 'Enter password', obscureText: true),
          const SizedBox(height: 20),
          const AppTextField(label: 'Annual income', hint: '0', prefix: '\$', keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          const AppTextField(label: 'Error state', hint: 'e.g. 12345', error: 'This field is required'),
          const SizedBox(height: 20),
          const AppTextField(label: 'With helper text', hint: 'e.g. 123-45-6789', helperText: 'Your SSN is encrypted and never stored'),
          const SizedBox(height: 20),
          const AppTextField(label: 'Disabled', hint: 'Cannot edit', enabled: false),
        ],
      ),
    );
  }
}

// ── Info rows page ──────────────────────────────────────────

class _InfoRowsPage extends StatelessWidget {
  const _InfoRowsPage();

  @override
  Widget build(BuildContext context) {
    return _ShowcasePage(
      title: 'Info Rows',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Individual rows'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                AppInfoRow(label: 'Monthly payment', value: '\$234.78'),
                AppInfoRow(label: 'Loan term', value: '36 months'),
                AppInfoRow(label: 'APR', value: '12.5%'),
                const AppInfoRow(label: 'Status', value: 'Active', showDivider: false, valueBadgeColor: AppColors.green400),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _SectionTitle('AppInfoSection (with title)'),
          const SizedBox(height: 12),
          const AppInfoSection(
            title: 'LOAN DETAILS',
            rows: [
              AppInfoRow(label: 'Loan amount', value: '\$12,000'),
              AppInfoRow(label: 'Term', value: '36 months'),
              AppInfoRow(label: 'APR', value: '12.5%'),
              AppInfoRow(label: 'Monthly payment', value: '\$234.78', showDivider: false),
            ],
          ),
          const SizedBox(height: 24),
          const AppInfoSection(
            title: 'PERSONAL INFO',
            rows: [
              AppInfoRow(label: 'Full name', value: 'Jane Smith'),
              AppInfoRow(label: 'Date of birth', value: 'Jan 1, 1990'),
              AppInfoRow(label: 'Phone', value: '(555) 000-0000', showDivider: false),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Full funnel example ─────────────────────────────────────

class _FunnelStep1 extends StatelessWidget {
  const _FunnelStep1();

  @override
  Widget build(BuildContext context) {
    return FunnelScaffold(
      currentStep: 1,
      totalSteps: 5,
      onClose: () => Navigator.of(context).popUntil((r) => r.isFirst),
      showBackButton: false,
      primaryButtonLabel: 'Continue',
      onPrimaryButtonPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _FunnelStep2())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FunnelStepHeader(
            title: 'Let\'s get\nyou started',
            subtitle: 'Tell us a bit about yourself so we can find the right loan for you.',
          ),
          const AppTextField(label: 'First name', hint: 'e.g. Jane'),
          const SizedBox(height: 20),
          const AppTextField(label: 'Last name', hint: 'e.g. Smith'),
          const SizedBox(height: 20),
          const AppTextField(label: 'Date of birth', hint: 'MM/DD/YYYY', keyboardType: TextInputType.datetime),
        ],
      ),
    );
  }
}

class _FunnelStep2 extends StatelessWidget {
  const _FunnelStep2();

  @override
  Widget build(BuildContext context) {
    return FunnelScaffold(
      currentStep: 2,
      totalSteps: 5,
      onBack: () => Navigator.pop(context),
      onClose: () => Navigator.of(context).popUntil((r) => r.isFirst),
      primaryButtonLabel: 'Continue',
      onPrimaryButtonPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _FunnelStep3())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FunnelStepHeader(
            title: 'What\'s your\naddress?',
            subtitle: 'Enter your current home address.',
          ),
          const AppTextField(label: 'Street address', hint: 'e.g. 123 Main St'),
          const SizedBox(height: 20),
          const AppTextField(label: 'City', hint: 'e.g. Austin'),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: AppTextField(label: 'State', hint: 'TX')),
              SizedBox(width: 16),
              Expanded(child: AppTextField(label: 'ZIP code', hint: '78701', keyboardType: TextInputType.number)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FunnelStep3 extends StatelessWidget {
  const _FunnelStep3();

  @override
  Widget build(BuildContext context) {
    return FunnelScaffold(
      currentStep: 3,
      totalSteps: 5,
      onBack: () => Navigator.pop(context),
      onClose: () => Navigator.of(context).popUntil((r) => r.isFirst),
      primaryButtonLabel: 'Continue',
      onPrimaryButtonPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _FunnelStep4())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FunnelStepHeader(
            title: 'Your income',
            subtitle: 'This helps us determine the loan amount you\'re eligible for.',
          ),
          const AppTextField(
            label: 'Annual income',
            hint: '0',
            prefix: '\$',
            keyboardType: TextInputType.number,
            helperText: 'Include all sources of income',
          ),
          const SizedBox(height: 20),
          const AppTextField(
            label: 'Employment status',
            hint: 'Select one',
            readOnly: true,
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.neutralN500),
          ),
        ],
      ),
    );
  }
}

class _FunnelStep4 extends StatelessWidget {
  const _FunnelStep4();

  @override
  Widget build(BuildContext context) {
    return FunnelScaffold(
      currentStep: 4,
      totalSteps: 5,
      title: 'Review & confirm',
      onBack: () => Navigator.pop(context),
      onClose: () => Navigator.of(context).popUntil((r) => r.isFirst),
      primaryButtonLabel: 'Submit application',
      secondaryButtonLabel: 'Go back and edit',
      onPrimaryButtonPressed: () {},
      onSecondaryButtonPressed: () => Navigator.pop(context),
      child: Column(
        children: const [
          AppInfoSection(
            title: 'PERSONAL INFO',
            rows: [
              AppInfoRow(label: 'Full name', value: 'Jane Smith'),
              AppInfoRow(label: 'Date of birth', value: 'Jan 1, 1990'),
              AppInfoRow(label: 'Phone', value: '(555) 000-0000', showDivider: false),
            ],
          ),
          SizedBox(height: 20),
          AppInfoSection(
            title: 'ADDRESS',
            rows: [
              AppInfoRow(label: 'Street', value: '123 Main St'),
              AppInfoRow(label: 'City', value: 'Austin, TX 78701', showDivider: false),
            ],
          ),
          SizedBox(height: 20),
          AppInfoSection(
            title: 'INCOME',
            rows: [
              AppInfoRow(label: 'Annual income', value: '\$65,000'),
              AppInfoRow(label: 'Employment', value: 'Employed full-time', showDivider: false),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Spacing & Grid page ─────────────────────────────────────

class _SpacingGridPage extends StatelessWidget {
  const _SpacingGridPage();

  @override
  Widget build(BuildContext context) {
    final config = GridConfig.of(context);
    return _ShowcasePage(
      title: 'Spacing & Grid',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Breakpoint info ─────────────────────────────
          _SectionTitle('Current Breakpoint'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Breakpoint: ${config.breakpoint.name.toUpperCase()}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Screen width: ${config.screenWidth.toStringAsFixed(0)}px',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN200)),
                Text('Columns: ${config.columns}  •  Gutter: ${config.gutter.toStringAsFixed(0)}px  •  Margin: ${config.margin.toStringAsFixed(0)}px',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN200)),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sectionGap),

          // ── Spacing scale ───────────────────────────────
          _SectionTitle('Spacing Scale'),
          const SizedBox(height: AppSpacing.sectionTitleGap),
          ...[
            ('xxs', AppSpacing.xxs, '4px — icon gap'),
            ('xs',  AppSpacing.xs,  '8px — small gap'),
            ('sm',  AppSpacing.sm,  '12px — compact padding'),
            ('md',  AppSpacing.md,  '16px — default padding'),
            ('lg',  AppSpacing.lg,  '24px — card / section padding'),
            ('xl',  AppSpacing.xl,  '32px — large section gap'),
            ('xxl', AppSpacing.xxl, '40px — page rhythm'),
            ('x3l', AppSpacing.x3l, '48px — hero / top breathing room'),
            ('x4l', AppSpacing.x4l, '64px — full screen layouts'),
          ].map((row) {
            final (label, size, desc) = row;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(label,
                        style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.neutralN500)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: size,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primaryO400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(desc,
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 12, color: AppColors.neutralN500)),
                ],
              ),
            );
          }),

          const SizedBox(height: AppSpacing.sectionGap),

          // ── Border radius ───────────────────────────────
          _SectionTitle('Border Radius'),
          const SizedBox(height: AppSpacing.sectionTitleGap),
          Row(
            children: [
              ('sm\n8px',   AppSpacing.radiusSm,   AppColors.primaryO400),
              ('md\n12px',  AppSpacing.radiusMd,   AppColors.navy),
              ('lg\n16px',  AppSpacing.radiusLg,   AppColors.green400),
              ('pill\n99px', AppSpacing.radiusPill, AppColors.neutralN500),
            ].map((item) {
              final (label, radius, color) = item;
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(radius),
                        border: Border.all(color: color, width: 2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(label,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.neutralN500)),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.sectionGap),

          // ── VSpace / HSpace ─────────────────────────────
          _SectionTitle('VSpace & HSpace widgets'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Use instead of SizedBox:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN500)),
                const VSpace.xs(),
                _CodeChip('VSpace.xs()  →  8px'),
                const VSpace.xxs(),
                _CodeChip('VSpace.md()  →  16px'),
                const VSpace.xxs(),
                _CodeChip('VSpace.lg()  →  24px'),
                const VSpace.xs(),
                Text('Horizontal:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN500)),
                const VSpace.xxs(),
                _CodeChip('HSpace.xs()  →  8px'),
                const VSpace.xxs(),
                _CodeChip('HSpace.md()  →  16px'),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sectionGap),

          // ── Grid columns demo ───────────────────────────
          _SectionTitle('Grid — Full width (4 columns)'),
          const SizedBox(height: AppSpacing.sectionTitleGap),
          AppGrid(
            applyMargin: false,
            children: List.generate(4, (i) => GridItem(
              span: 1,
              child: _GridBox(label: 'Col ${i + 1}', index: i),
            )),
          ),

          const SizedBox(height: AppSpacing.xl),

          _SectionTitle('Grid — 2-column layout'),
          const SizedBox(height: AppSpacing.sectionTitleGap),
          AppGrid.twoColumn(
            applyMargin: false,
            left: _GridBox(label: 'Left\n(span 2)', index: 0, tall: true),
            right: _GridBox(label: 'Right\n(span 2)', index: 1, tall: true),
          ),

          const SizedBox(height: AppSpacing.xl),

          _SectionTitle('Grid — Mixed spans'),
          const SizedBox(height: AppSpacing.sectionTitleGap),
          AppGrid(
            applyMargin: false,
            children: [
              GridItem(span: 3, child: _GridBox(label: 'span 3', index: 0, tall: true)),
              GridItem(span: 1, child: _GridBox(label: 'span 1', index: 2, tall: true)),
              GridItem(span: 1, child: _GridBox(label: 'span 1', index: 1)),
              GridItem(span: 1, child: _GridBox(label: 'span 1', index: 3)),
              GridItem(span: 2, child: _GridBox(label: 'span 2', index: 4)),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          _SectionTitle('AppScreenPadding'),
          const SizedBox(height: 8),
          Container(
            color: AppColors.neutralN100,
            child: AppScreenPadding(
              vertical: AppSpacing.md,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryO400.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.primaryO400),
                ),
                child: Text(
                  'Content inside AppScreenPadding\n${config.margin.toStringAsFixed(0)}px margin on each side',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.navy),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class _GridBox extends StatelessWidget {
  const _GridBox({required this.label, required this.index, this.tall = false});
  final String label;
  final int index;
  final bool tall;

  static const _colors = [
    AppColors.primaryO400,
    AppColors.navy,
    AppColors.green400,
    AppColors.blue400,
    AppColors.yellow400,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[index % _colors.length];
    return Container(
      height: tall ? 72 : 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _CodeChip extends StatelessWidget {
  const _CodeChip(this.code);
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutralN75,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        code,
        style: AppTextStyles.bodySmall.copyWith(
          fontFamily: 'monospace',
          fontSize: 12,
          color: AppColors.navy,
        ),
      ),
    );
  }
}

// ── Tables page ─────────────────────────────────────────────

class _TablesPage extends StatelessWidget {
  const _TablesPage();

  @override
  Widget build(BuildContext context) {
    return _ShowcasePage(
      title: 'Tables',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── 1. Two-column comparison ─────────────────────
          _SectionTitle('2-Column Comparison'),
          const SizedBox(height: 4),
          Text('Current vs new offer. Always fits on screen — no scroll needed.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN500)),
          const SizedBox(height: 12),
          AppComparisonTable.twoColumn(
            options: const ['Current loan', 'New offer'],
            highlightColumn: 1,
            highlightLabel: 'Better',
            rows: const [
              ComparisonRow(label: 'Monthly payment', values: ['\$312', '\$234'], isHighlightRow: true),
              ComparisonRow(label: 'APR', values: ['18.9%', '12.5%']),
              ComparisonRow(label: 'Term', values: ['48 mo', '36 mo']),
              ComparisonRow(label: 'Total interest', values: ['\$4,200', '\$2,840']),
              ComparisonRow(label: 'Origination fee', values: ['\$0', '\$150']),
              ComparisonRow(label: 'Prepay penalty', values: ['no', 'no']),
            ],
          ),

          const SizedBox(height: 40),

          // ── 2. Three-column comparison ───────────────────
          _SectionTitle('3-Column Comparison'),
          const SizedBox(height: 4),
          Text('Compare three loan offers. Scrolls on very small screens.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN500)),
          const SizedBox(height: 12),
          AppComparisonTable.threeColumn(
            options: const ['Current loan', 'Offer A', 'Offer B'],
            highlightColumn: 1,
            highlightLabel: 'Best',
            rows: const [
              ComparisonRow(label: 'Monthly payment', values: ['\$312', '\$234', '\$198'], isHighlightRow: true),
              ComparisonRow(label: 'APR', values: ['18.9%', '12.5%', '10.2%']),
              ComparisonRow(label: 'Term', values: ['48 mo', '36 mo', '36 mo']),
              ComparisonRow(label: 'Total interest', values: ['\$4,200', '\$2,840', '\$2,180']),
              ComparisonRow(label: 'Origination fee', values: ['\$0', '\$150', '\$299']),
              ComparisonRow(label: 'Prepay penalty', values: ['no', 'no', 'yes']),
            ],
          ),

          const SizedBox(height: 40),

          // ── 3. Four-column comparison ────────────────────
          _SectionTitle('4-Column Comparison'),
          const SizedBox(height: 4),
          Text('Compare four plans with checkmarks. Pinned label column, scrollable options.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN500)),
          const SizedBox(height: 12),
          AppComparisonTable.fourColumn(
            options: const ['Basic', 'Standard', 'Plus', 'Premium'],
            highlightColumn: 2,
            highlightLabel: 'Popular',
            rows: const [
              ComparisonRow(label: 'Auto pay', values: ['yes', 'yes', 'yes', 'yes']),
              ComparisonRow(label: 'Payment deferrals', values: ['no', 'yes', 'yes', 'yes']),
              ComparisonRow(label: 'Rate lock', values: ['no', 'no', 'yes', 'yes']),
              ComparisonRow(label: 'Dedicated advisor', values: ['no', 'no', 'no', 'yes']),
              ComparisonRow(label: 'Priority support', values: ['no', 'no', 'yes', 'yes']),
              ComparisonRow(label: 'Monthly fee', values: ['\$0', '\$9', '\$19', '\$39'], isHighlightRow: true),
            ],
          ),

          const SizedBox(height: 40),

          // ── 4. Data table with status badges ─────────────
          _SectionTitle('Data Table — Payment History'),
          const SizedBox(height: 4),
          Text('First column pinned, rest scroll horizontally when needed.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN500)),
          const SizedBox(height: 12),
          AppDataTable(
            columns: const ['Date', 'Description', 'Amount', 'Status'],
            rows: const [
              ['Mar 1, 2026', 'Monthly payment', '\$234.78', 'Paid'],
              ['Feb 1, 2026', 'Monthly payment', '\$234.78', 'Paid'],
              ['Jan 1, 2026', 'Monthly payment', '\$234.78', 'Paid'],
              ['Dec 1, 2025', 'Monthly payment', '\$234.78', 'Late'],
              ['Nov 1, 2025', 'Monthly payment', '\$234.78', 'Paid'],
            ],
            statusColumn: 3,
            highlightedRowIndex: 3,
          ),

          const SizedBox(height: 40),

          // ── 4. Stacked table ────────────────────────────
          _SectionTitle('Stacked Table (Loan Details)'),
          const SizedBox(height: 4),
          Text('Best for small screens — each item becomes a card.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralN500)),
          const SizedBox(height: 12),
          AppStackedTable(
            items: const [
              {
                'Loan amount': '\$12,000',
                'Monthly payment': '\$234.78',
                'Term': '36 months',
                'APR': '12.5%',
              },
              {
                'Origination date': 'Jan 1, 2025',
                'Payoff date': 'Jan 1, 2028',
                'Remaining balance': '\$10,418',
                'Next payment due': 'Apr 1, 2026',
              },
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared helper widgets ───────────────────────────────────

class _ShowcasePage extends StatelessWidget {
  const _ShowcasePage({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralN50,
      appBar: AppNavBar(
        title: title,
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}

class _ComponentTile extends StatelessWidget {
  const _ComponentTile({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.navy, size: 22),
              const SizedBox(width: 16),
              Expanded(child: Text(label, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w500))),
              const Icon(Icons.chevron_right_rounded, color: AppColors.neutralN500, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodySmall.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        letterSpacing: 0.5,
        color: AppColors.neutralN500,
      ),
    );
  }
}
