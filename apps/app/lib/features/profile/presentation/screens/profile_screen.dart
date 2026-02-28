import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymai/core/router/app_router.dart';
import 'package:gymai/core/theme/app_theme.dart';
import 'package:gymai/features/auth/presentation/providers/auth_provider.dart';
import 'package:gymai/features/profile/presentation/providers/body_metrics_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _editingMetrics = false;

  late TextEditingController _heightCtrl;
  late TextEditingController _weightCtrl;
  DateTime? _selectedDob; // used during editing

  @override
  void initState() {
    super.initState();
    _heightCtrl = TextEditingController();
    _weightCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _startEditing(BodyMetrics metrics) {
    _heightCtrl.text = metrics.height?.toString() ?? '';
    _weightCtrl.text = metrics.weight?.toString() ?? '';
    _selectedDob = metrics.dateOfBirth;
    setState(() => _editingMetrics = true);
  }

  Future<void> _saveMetrics() async {
    final height = double.tryParse(_heightCtrl.text);
    final weight = double.tryParse(_weightCtrl.text);

    await ref.read(bodyMetricsProvider.notifier).update(
          height: height,
          weight: weight,
          dateOfBirth: _selectedDob,
        );
    setState(() => _editingMetrics = false);
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Select Date of Birth',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.surface,
            onSurface: AppColors.onBackground,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  void _cancelEditing() => setState(() => _editingMetrics = false);

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final metrics = ref.watch(bodyMetricsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.surface, AppColors.surfaceVariant],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    children: [
                      _Avatar(avatarUrl: user?.avatarUrl, name: user?.name),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'GymAI User',
                        style: const TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: AppColors.onSurfaceMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user?.email ?? '—',
                            style: const TextStyle(
                              color: AppColors.onSurfaceMuted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Account info
                const _SectionHeader(title: 'Account'),
                const SizedBox(height: 8),
                _InfoCard(
                  children: [
                    _InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Name',
                      value: user?.name ?? '—',
                    ),
                    const _Divider(),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? '—',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Body metrics
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _SectionHeader(title: 'Body Metrics'),
                    if (!_editingMetrics)
                      GestureDetector(
                        onTap: () => _startEditing(metrics),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _cancelEditing,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColors.onSurfaceMuted,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: _saveMetrics,
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _MetricsCard(
                  editing: _editingMetrics,
                  metrics: metrics,
                  heightCtrl: _heightCtrl,
                  weightCtrl: _weightCtrl,
                  selectedDob: _selectedDob,
                  onPickDob: _pickDob,
                ),

                const SizedBox(height: 24),

                // Settings
                const _SectionHeader(title: 'Settings'),
                const SizedBox(height: 8),
                _InfoCard(
                  children: [
                    _ActionRow(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: () {},
                    ),
                    const _Divider(),
                    _ActionRow(
                      icon: Icons.lock_outline_rounded,
                      label: 'Privacy',
                      onTap: () {},
                    ),
                    const _Divider(),
                    _ActionRow(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _SignOutButton(
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) {
                      context.goNamed(AppRoutes.loginName);
                    }
                  },
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Metrics card ──────────────────────────────────────────────────────────
class _MetricsCard extends StatelessWidget {
  const _MetricsCard({
    required this.editing,
    required this.metrics,
    required this.heightCtrl,
    required this.weightCtrl,
    required this.selectedDob,
    required this.onPickDob,
  });

  final bool editing;
  final BodyMetrics metrics;
  final TextEditingController heightCtrl;
  final TextEditingController weightCtrl;
  final DateTime? selectedDob;
  final VoidCallback onPickDob;

  String _formatDob(DateTime? dob) {
    if (dob == null) return '—';
    return '${dob.day.toString().padLeft(2, '0')} / '
        '${dob.month.toString().padLeft(2, '0')} / '
        '${dob.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dobDisplay = editing ? _formatDob(selectedDob) : _formatDob(metrics.dateOfBirth);
    final ageDisplay = editing
        ? (selectedDob != null ? _computeAge(selectedDob!) : null)
        : metrics.age;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant, width: 0.5),
      ),
      child: Column(
        children: [
          _MetricRow(
            icon: Icons.height_rounded,
            label: 'Height',
            unit: 'cm',
            value: metrics.height?.toStringAsFixed(0),
            editing: editing,
            controller: heightCtrl,
            inputType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}\.?\d{0,1}')),
            ],
          ),
          const _Divider(),
          _MetricRow(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            unit: 'kg',
            value: metrics.weight?.toStringAsFixed(1),
            editing: editing,
            controller: weightCtrl,
            inputType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}\.?\d{0,1}')),
            ],
          ),
          const _Divider(),
          // Date of Birth row — tappable picker instead of text field
          GestureDetector(
            onTap: editing ? onPickDob : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.cake_outlined, size: 18, color: AppColors.onSurfaceMuted),
                  const SizedBox(width: 12),
                  const Text(
                    'Date of Birth',
                    style: TextStyle(color: AppColors.onSurface, fontSize: 14),
                  ),
                  const Spacer(),
                  if (editing)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dobDisplay,
                            style: const TextStyle(
                              color: AppColors.onBackground,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.edit_calendar_outlined,
                              size: 14, color: AppColors.primary),
                        ],
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          dobDisplay,
                          style: TextStyle(
                            color: metrics.dateOfBirth != null
                                ? AppColors.onBackground
                                : AppColors.onSurfaceMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (ageDisplay != null)
                          Text(
                            '$ageDisplay years old',
                            style: const TextStyle(
                              color: AppColors.onSurfaceMuted,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _computeAge(DateTime dob) {
    final now = DateTime.now();
    var years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years;
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.icon,
    required this.label,
    required this.unit,
    required this.value,
    required this.editing,
    required this.controller,
    required this.inputType,
    required this.inputFormatters,
  });

  final IconData icon;
  final String label;
  final String unit;
  final String? value;
  final bool editing;
  final TextEditingController controller;
  final TextInputType inputType;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.onSurfaceMuted),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
          ),
          const Spacer(),
          if (editing)
            SizedBox(
              width: 80,
              height: 36,
              child: TextField(
                controller: controller,
                keyboardType: inputType,
                inputFormatters: inputFormatters,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.onBackground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  hintText: '—',
                  hintStyle:
                      const TextStyle(color: AppColors.onSurfaceMuted),
                  suffix: Text(
                    unit,
                    style: const TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            )
          else
            Text(
              value != null ? '$value $unit' : '— $unit',
              style: TextStyle(
                color:
                    value != null ? AppColors.onBackground : AppColors.onSurfaceMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  const _Avatar({this.avatarUrl, this.name});
  final String? avatarUrl;
  final String? name;

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'G';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: avatarUrl != null
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _Initials(initials: initials),
              ),
            )
          : _Initials(initials: initials),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.initials});
  final String initials;
  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

// ── Shared components ─────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.onSurfaceMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceVariant, width: 0.5),
        ),
        child: Column(children: children),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.onSurfaceMuted),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.onBackground,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.onSurfaceMuted),
              const SizedBox(width: 12),
              Text(
                label,
                style:
                    const TextStyle(color: AppColors.onSurface, fontSize: 14),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.onSurfaceMuted,
              ),
            ],
          ),
        ),
      );
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => const Divider(
        height: 0,
        thickness: 0.5,
        color: AppColors.surfaceVariant,
        indent: 46,
      );
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
              SizedBox(width: 10),
              Text(
                'Sign Out',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}
