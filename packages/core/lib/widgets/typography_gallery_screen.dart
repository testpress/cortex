import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class TypographyGalleryScreen extends StatefulWidget {
  const TypographyGalleryScreen({super.key});

  @override
  State<TypographyGalleryScreen> createState() =>
      _TypographyGalleryScreenState();
}

class _TypographyGalleryScreenState extends State<TypographyGalleryScreen> {
  String _activeTab = 'showcase';

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      color: design.colors.surface,
      child: Column(
        children: [
          Expanded(
            child: _activeTab == 'tokens'
                ? const _TokensView()
                : const _PracticalShowcaseView(),
          ),
          AppTabBar(
            items: const [
              AppTabItem(
                id: 'showcase',
                label: 'Reading Preview',
                icon: LucideIcons.layout,
              ),
              AppTabItem(
                id: 'tokens',
                label: 'System Specs',
                icon: LucideIcons.book,
              ),
            ],
            activeItemId: _activeTab,
            onTabChange: (id) => setState(() => _activeTab = id),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(design.spacing.xs),
        child: Icon(
          LucideIcons.chevronLeft,
          size: 24,
          color: design.colors.textPrimary,
        ),
      ),
    );
  }
}

class _PracticalShowcaseView extends StatelessWidget {
  const _PracticalShowcaseView();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Column(
      children: [
        AppHeader(
          title: 'Practical Application',
          subtitle: 'Content-Aware Reading Experience',
          leading: _BackButton(onPressed: () => Navigator.of(context).pop()),
        ),
        Expanded(
          child: AppScroll(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacing.lg,
              vertical: design.spacing.md,
            ),
            children: [
              // H1: Display
              const AppText.display(
                'The Architect\'s Guide to Modern Distributed Systems',
              ),
              SizedBox(height: design.spacing.md),

              Wrap(
                spacing: design.spacing.sm,
                runSpacing: design.spacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AppBadge(
                    label: 'MUST READ',
                    semanticStatus: design.statusColors.live,
                  ),
                  AppSubjectChip(
                    label: 'System Design',
                    subjectPaletteIndex: 0,
                    isActive: true,
                    onTap: () {},
                  ),
                  const AppText.caption('Author: Sarah Drasner • 15 min read'),
                ],
              ),
              SizedBox(height: design.spacing.xl),

              // Intro Text: Body
              const AppText.body(
                'In the rapidly evolving landscape of software engineering, distributed systems have moved from a niche '
                'requirement for hyper-scale companies to a fundamental architectual pattern for modern applications. '
                'This article explores the trade-offs between availability and consistency in the cloud-native era.',
              ),
              SizedBox(height: design.spacing.xl),

              // H2: Headline
              const AppText.headline('1. The CAP Theorem Revisited'),
              SizedBox(height: design.spacing.md),
              const AppText.body(
                'Consistency, Availability, and Partition Tolerance. While the theorem states you can only guarantee two '
                'at any given time, modern databases have introduced "Tunable Consistency" to bridge the gap.',
              ),
              SizedBox(height: design.spacing.lg),

              // H3: Title (Molecule)
              AppCard(
                padding: EdgeInsets.all(design.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText.title('Comparative Logic: SQL vs NoSQL'),
                    SizedBox(height: design.spacing.sm),
                    const AppText.bodySmall(
                      'Understanding the data consistency models for different workload types.',
                      color: Color(0xFF64748B),
                    ),
                    SizedBox(height: design.spacing.lg),
                    _ComparisonTable(),
                  ],
                ),
              ),
              SizedBox(height: design.spacing.xl),

              // H2: Headline
              const AppText.headline(
                '2. Microservices and Eventual Consistency',
              ),
              SizedBox(height: design.spacing.md),
              const AppText.body(
                'Moving to microservices often means giving up traditional ACID transactions. This is where '
                'the SAGA pattern and Event-Sourcing become critical for maintaining domain integrity.',
              ),
              SizedBox(height: design.spacing.lg),

              // H4: Subtitle (Nested Header)
              const AppText.subtitle(
                'Choosing Between Choreography and Orchestration',
              ),
              SizedBox(height: design.spacing.sm),
              const AppText.body(
                'Choreography favors loose coupling but can be hard to monitor. Orchestration provides '
                'clear control flow but introduces a central point of failure. Choosing the right one '
                'depends on the complexity of your business process.',
              ),

              SizedBox(height: design.spacing.xl),
              // Callout Molecule
              Container(
                padding: EdgeInsets.all(design.spacing.lg),
                decoration: BoxDecoration(
                  color: design.colors.surfaceVariant.withValues(alpha: 0.3),
                  borderRadius: design.radius.card,
                  border: Border(
                    left: BorderSide(color: design.colors.primary, width: 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText.label(
                      'CRITICAL TAKEAWAY',
                      color: Color(0xFF0F172A),
                    ),
                    SizedBox(height: design.spacing.xs),
                    const AppText.subtitle(
                      'Distributed systems are not about eliminating failure; they are about '
                      'embracing failure as a first-class citizen in your architecture.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              SizedBox(height: design.spacing.xxxl),
              AppButton.primary(
                label: 'Download Implementation PDF',
                fullWidth: true,
                onPressed: () {},
              ),
              SizedBox(height: design.spacing.xxxl),
            ],
          ),
        ),
      ],
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AppText.label(
                'FEATURE',
                color: design.colors.textSecondary,
              ),
            ),
            Expanded(
              child: AppText.label('ACID', color: design.colors.textSecondary),
            ),
            Expanded(
              child: AppText.label('BASE', color: design.colors.textSecondary),
            ),
          ],
        ),
        SizedBox(height: design.spacing.sm),
        Container(height: 1, color: design.colors.divider),
        const _TableRow(label: 'Consistency', c1: 'Immediate', c2: 'Eventual'),
        const _TableRow(label: 'Availability', c1: 'Lower', c2: 'High'),
        const _TableRow(label: 'Scaling', c1: 'Vertical', c2: 'Horizontal'),
      ],
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.label, required this.c1, required this.c2});
  final String label;
  final String c1;
  final String c2;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: design.spacing.sm),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText.bodySmall(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: AppText.bodySmall(c1)),
          Expanded(child: AppText.bodySmall(c2, color: design.colors.primary)),
        ],
      ),
    );
  }
}

class _TokensView extends StatelessWidget {
  const _TokensView();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Column(
      children: [
        AppHeader(
          title: 'Typography System',
          subtitle: 'Semantic Document Structure (H1-H4)',
          leading: _BackButton(onPressed: () => Navigator.of(context).pop()),
        ),
        Expanded(
          child: AppScroll(
            padding: EdgeInsets.all(design.spacing.lg),
            children: [
              _DocSection(
                title: 'Semantic Structure (Preferred)',
                children: [
                  const _DocItem(
                    label: 'display (H1)',
                    desc: 'Main page or hero title. xl3/30px/Bold.',
                    child: AppText.display('Dashboard Overview'),
                  ),
                  const _DocItem(
                    label: 'headline (H2)',
                    desc: 'Major section header. xl2/24px/Semi.',
                    child: AppText.headline('Module Content'),
                  ),
                  const _DocItem(
                    label: 'title (H3)',
                    desc: 'Minor section or card title. xl/20px/Semi.',
                    child: AppText.title('Lesson Details'),
                  ),
                  const _DocItem(
                    label: 'subtitle (H4)',
                    desc: 'Nested header or bold emphasis. lg/18px/Medium.',
                    child: AppText.subtitle('Sub-topic header'),
                  ),
                  const _DocItem(
                    label: 'body',
                    desc: 'Standard reading text. base/16px/Regular.',
                    child: AppText.body(
                      'The quick brown fox jumps over the lazy dog.',
                    ),
                  ),
                ],
              ),
              SizedBox(height: design.spacing.xl),
              _DocSection(
                title: 'Design Atoms (Fixed Scale)',
                children: [
                  _DocItem(label: 'xl5 (48px)', child: AppText.xl5('Aa')),
                  _DocItem(
                    label: 'xl4 (36px)',
                    child: AppText.xl4('Main Header'),
                  ),
                  _DocItem(
                    label: 'xl (20px)',
                    child: AppText.xl('Small Header'),
                  ),
                  _DocItem(
                    label: 'xs (12px)',
                    child: AppText.xs('Micro labels'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocSection extends StatelessWidget {
  const _DocSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.xs(title.toUpperCase(), color: design.colors.textSecondary),
        SizedBox(height: design.spacing.xs),
        Container(height: 1, color: design.colors.divider),
        SizedBox(height: design.spacing.md),
        ...children,
      ],
    );
  }
}

class _DocItem extends StatelessWidget {
  const _DocItem({required this.label, this.desc, required this.child});
  final String label;
  final String? desc;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: design.spacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppText.xs(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (desc != null) ...[
                const AppText.xs('•'),
                AppText.xs(desc!, color: design.colors.textSecondary),
              ],
            ],
          ),
          SizedBox(height: design.spacing.xs),
          child,
        ],
      ),
    );
  }
}
