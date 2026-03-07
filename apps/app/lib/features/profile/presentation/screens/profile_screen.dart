import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymai/core/router/app_router.dart';
import 'package:gymai/core/theme/app_theme.dart';
import 'package:gymai/features/auth/presentation/providers/auth_provider.dart';
import 'package:gymai/features/profile/domain/entities/activity_level.dart';
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
  String? _selectedGender; // used during editing
  ActivityLevel? _selectedActivityLevel; // used during editing

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
    _selectedGender = metrics.gender;
    _selectedActivityLevel = metrics.activityLevel;
    setState(() => _editingMetrics = true);
  }

  Future<void> _saveMetrics() async {
    final height = double.tryParse(_heightCtrl.text);
    final weight = double.tryParse(_weightCtrl.text);

    await ref
        .read(bodyMetricsProvider.notifier)
        .update(height: height, weight: weight, dateOfBirth: _selectedDob, gender: _selectedGender, activityLevel: _selectedActivityLevel);
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
                  selectedGender: _selectedGender,
                  selectedActivityLevel: _selectedActivityLevel,
                  onPickDob: _pickDob,
                  onChangedGender: (g) => setState(() => _selectedGender = g),
                  onChangedActivityLevel: (al) => setState(() => _selectedActivityLevel = al),
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
    required this.selectedGender,
    required this.selectedActivityLevel,
    required this.onPickDob,
    required this.onChangedGender,
    required this.onChangedActivityLevel,
  });

  final bool editing;
  final BodyMetrics metrics;
  final TextEditingController heightCtrl;
  final TextEditingController weightCtrl;
  final DateTime? selectedDob;
  final String? selectedGender;
  final ActivityLevel? selectedActivityLevel;
  final VoidCallback onPickDob;
  final ValueChanged<String> onChangedGender;
  final ValueChanged<ActivityLevel?> onChangedActivityLevel;

  String _formatDob(DateTime? dob) {
    if (dob == null) return '—';
    return '${dob.day.toString().padLeft(2, '0')} / '
        '${dob.month.toString().padLeft(2, '0')} / '
        '${dob.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dobDisplay = editing
        ? _formatDob(selectedDob)
        : _formatDob(metrics.dateOfBirth);
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
          _GenderRow(
            editing: editing,
            gender: editing ? selectedGender : metrics.gender,
            onChanged: onChangedGender,
          ),
          const _Divider(),
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
                  const Icon(
                    Icons.cake_outlined,
                    size: 18,
                    color: AppColors.onSurfaceMuted,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Date of Birth',
                    style: TextStyle(color: AppColors.onSurface, fontSize: 14),
                  ),
                  const Spacer(),
                  if (editing)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
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
                          const Icon(
                            Icons.edit_calendar_outlined,
                            size: 14,
                            color: AppColors.primary,
                          ),
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
          const _Divider(),
          _ActivityLevelRow(
            editing: editing,
            activityLevel: editing ? selectedActivityLevel : metrics.activityLevel,
            onChanged: onChangedActivityLevel,
          ),
          AnimatedBuilder(
            animation: Listenable.merge([heightCtrl, weightCtrl]),
            builder: (context, child) {
              final currentWeight = editing ? double.tryParse(weightCtrl.text) : metrics.weight;
              final currentHeight = editing ? double.tryParse(heightCtrl.text) : metrics.height;
              final currentGender = editing ? selectedGender : metrics.gender;
              final currentDob = editing ? selectedDob : metrics.dateOfBirth;
              final currentActivity = editing ? selectedActivityLevel : metrics.activityLevel;

              final currentAge = currentDob != null ? _computeAge(currentDob) : metrics.age;

              int? bmr;
              if (currentWeight != null && currentHeight != null && currentAge != null && currentGender != null) {
                final base = (10 * currentWeight) + (6.25 * currentHeight) - (5 * currentAge);
                bmr = currentGender == 'Male' ? (base + 5).round() : (base - 161).round();
              }

              int? tdee;
              if (bmr != null && currentActivity != null) {
                tdee = (bmr * currentActivity.multiplier).round();
              }

              return Column(
                children: [
                  const _Divider(),
                  _CalculatedMetricRow(
                    icon: Icons.local_fire_department_outlined,
                    label: 'BMR',
                    unit: 'kcal/day',
                    value: bmr?.toString(),
                    subtitle: 'Basal Metabolic Rate',
                  ),
                  const _Divider(),
                  _CalculatedMetricRow(
                    icon: Icons.bolt_outlined,
                    label: 'TDEE',
                    unit: 'kcal/day',
                    value: tdee?.toString(),
                    subtitle: 'Maintenance Calories',
                    highlight: true,
                  ),
                ],
              );
            },
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
              width: 110,
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  hintText: '—',
                  hintStyle: const TextStyle(color: AppColors.onSurfaceMuted),
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
                color: value != null
                    ? AppColors.onBackground
                    : AppColors.onSurfaceMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

class _CalculatedMetricRow extends StatelessWidget {
  const _CalculatedMetricRow({
    required this.icon,
    required this.label,
    required this.unit,
    required this.value,
    this.subtitle,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final String unit;
  final String? value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: highlight ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon, 
            size: 20, 
            color: highlight ? AppColors.primary : AppColors.onSurfaceMuted,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: highlight ? AppColors.primary : AppColors.onSurface, 
                  fontSize: 14,
                  fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.onSurfaceMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
          const Spacer(),
          Text(
            value != null ? '$value $unit' : '— $unit',
            style: TextStyle(
              color: value != null
                  ? (highlight ? AppColors.primary : AppColors.onBackground)
                  : AppColors.onSurfaceMuted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityLevelRow extends StatelessWidget {
  const _ActivityLevelRow({
    required this.editing,
    required this.activityLevel,
    required this.onChanged,
  });

  final bool editing;
  final ActivityLevel? activityLevel;
  final ValueChanged<ActivityLevel?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.directions_run_outlined, size: 18, color: AppColors.onSurfaceMuted),
          const SizedBox(width: 12),
          const Text(
            'Activity',
            style: TextStyle(color: AppColors.onSurface, fontSize: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: editing
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<ActivityLevel>(
                      isExpanded: true,
                      alignment: AlignmentDirectional.centerEnd,
                      value: activityLevel,
                      hint: const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Select',
                          style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 14),
                        ),
                      ),
                      dropdownColor: AppColors.surfaceVariant,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.onSurfaceMuted),
                      style: const TextStyle(
                        color: AppColors.onBackground,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: onChanged,
                      items: ActivityLevel.values.map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              level.displayName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      activityLevel?.displayName ?? '—',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: activityLevel != null
                            ? AppColors.onBackground
                            : AppColors.onSurfaceMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _GenderRow extends StatelessWidget {
  const _GenderRow({
    required this.editing,
    required this.gender,
    required this.onChanged,
  });

  final bool editing;
  final String? gender;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.people_alt_outlined, size: 18, color: AppColors.onSurfaceMuted),
          const SizedBox(width: 12),
          const Text(
            'Gender',
            style: TextStyle(color: AppColors.onSurface, fontSize: 14),
          ),
          const Spacer(),
          if (editing)
            Row(
              children: [
                _SegmentButton(
                  label: 'Male',
                  isSelected: gender == 'Male',
                  onTap: () => onChanged('Male'),
                ),
                const SizedBox(width: 8),
                _SegmentButton(
                  label: 'Female',
                  isSelected: gender == 'Female',
                  onTap: () => onChanged('Female'),
                ),
              ],
            )
          else
            Text(
              gender ?? '—',
              style: TextStyle(
                color: gender != null
                    ? AppColors.onBackground
                    : AppColors.onSurfaceMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.onSurfaceMuted,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
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
            style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
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
