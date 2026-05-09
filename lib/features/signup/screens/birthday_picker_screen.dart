import 'package:flutter/material.dart';

class BirthdayPickerScreen extends StatefulWidget {
  final DateTime? initialDate;

  const BirthdayPickerScreen({super.key, this.initialDate});

  @override
  State<BirthdayPickerScreen> createState() => _BirthdayPickerScreenState();
}

class _BirthdayPickerScreenState extends State<BirthdayPickerScreen> {
  static const Color goldColor = Color(0xFFF2B93B);
  static const List<String> monthNames = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late DateTime _selectedDate;
  late DateTime _visibleMonth;

  DateTime get _latestAllowedDate {
    final now = DateTime.now();
    return DateTime(now.year - 18, now.month, now.day);
  }

  DateTime get _earliestAllowedDate {
    final latest = _latestAllowedDate;
    return DateTime(latest.year - 82, 1, 1);
  }

  @override
  void initState() {
    super.initState();
    final defaultDate = widget.initialDate ?? DateTime(1995, 7, 11);
    final clampedDate = _clampDate(defaultDate);
    _selectedDate = clampedDate;
    _visibleMonth = DateTime(clampedDate.year, clampedDate.month);
  }

  DateTime _clampDate(DateTime date) {
    if (date.isBefore(_earliestAllowedDate)) {
      return _earliestAllowedDate;
    }
    if (date.isAfter(_latestAllowedDate)) {
      return _latestAllowedDate;
    }
    return date;
  }

  void _changeMonth(int offset) {
    final candidate = DateTime(_visibleMonth.year, _visibleMonth.month + offset);
    final earliestMonth = DateTime(
      _earliestAllowedDate.year,
      _earliestAllowedDate.month,
    );
    final latestMonth = DateTime(
      _latestAllowedDate.year,
      _latestAllowedDate.month,
    );

    if (candidate.isBefore(earliestMonth) || candidate.isAfter(latestMonth)) {
      return;
    }

    setState(() => _visibleMonth = candidate);
  }

  void _selectDay(int day) {
    final candidate = DateTime(_visibleMonth.year, _visibleMonth.month, day);
    if (candidate.isAfter(_latestAllowedDate) ||
        candidate.isBefore(_earliestAllowedDate)) {
      return;
    }

    setState(() => _selectedDate = candidate);
  }

  void _save() {
    Navigator.of(context).pop(_selectedDate);
  }

  void _skip() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      _visibleMonth.year,
      _visibleMonth.month,
    );
    final firstWeekday = DateTime(
      _visibleMonth.year,
      _visibleMonth.month,
      1,
    ).weekday;
    final leadingEmptySlots = firstWeekday - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skip,
                  style: TextButton.styleFrom(
                    foregroundColor: goldColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Skip'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Profile details',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 160,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDED),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(34),
                          bottom: Radius.circular(24),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          const Positioned(
                            bottom: 6,
                            child: Icon(
                              Icons.person_rounded,
                              size: 52,
                              color: Color(0xFF8C8C8C),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: Container(
                              width: 52,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Birthday',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${_selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 50,
                        color: goldColor,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                    Text(
                      monthNames[_selectedDate.month - 1],
                      style: const TextStyle(
                        fontSize: 20,
                        color: goldColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MonthArrow(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => _changeMonth(-1),
                  ),
                  _MonthArrow(
                    icon: Icons.chevron_right_rounded,
                    onTap: () => _changeMonth(1),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: leadingEmptySlots + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < leadingEmptySlots) {
                      return const SizedBox.shrink();
                    }

                    final day = index - leadingEmptySlots + 1;
                    final currentDate = DateTime(
                      _visibleMonth.year,
                      _visibleMonth.month,
                      day,
                    );
                    final isSelected = DateUtils.isSameDay(
                      currentDate,
                      _selectedDate,
                    );
                    final isDisabled = currentDate.isAfter(_latestAllowedDate) ||
                        currentDate.isBefore(_earliestAllowedDate);

                    return GestureDetector(
                      onTap: isDisabled ? null : () => _selectDay(day),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? goldColor : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: isDisabled
                                ? const Color(0xFFCCCCCC)
                                : isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthArrow extends StatelessWidget {
  const _MonthArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE2E2E2),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.black, size: 34),
        ),
      ),
    );
  }
}
