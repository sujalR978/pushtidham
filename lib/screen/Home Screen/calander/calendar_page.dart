import 'package:flutter/material.dart';


// Model to represent Tithi details for each date
class CalendarDayData {
  final DateTime date;
  final String tithiName; // e.g., "અષાઢ સુદ આઠમ, વિ.સ. ૨૦૮૨"
  final bool isEkadashi;
  final bool isPoonam;
  final bool isAmas;
  final bool isFestival;
  final String? festivalName;

  CalendarDayData({
    required this.date,
    required this.tithiName,
    this.isEkadashi = false,
    this.isPoonam = false,
    this.isAmas = false,
    this.isFestival = false,
    this.festivalName,
  });
}

class TippaniCalendarPage extends StatefulWidget {
  const TippaniCalendarPage({super.key});

  @override
  State<TippaniCalendarPage> createState() => _TippaniCalendarPageState();
}

class _TippaniCalendarPageState extends State<TippaniCalendarPage> {
  DateTime _focusedMonth = DateTime(2026, 7, 1);
  DateTime _selectedDate = DateTime(2026, 7, 21);

  // Mock data structure structured for easy API replacement
  final Map<String, CalendarDayData> _calendarApiMockData = {
    '2026-07-11': CalendarDayData(
      date: DateTime(2026, 7, 11),
      tithiName: 'અષાઢ વદ અગિયારસ (કામિકા અગિયારસ)',
      isEkadashi: true,
    ),
    '2026-07-14': CalendarDayData(
      date: DateTime(2026, 7, 14),
      tithiName: 'અષાઢ વદ અમાસ',
      isAmas: true,
    ),
    '2026-07-19': CalendarDayData(
      date: DateTime(2026, 7, 19),
      tithiName: 'અષાઢ સુદ છઠ્ઠ (તહેવાર)',
      isFestival: true,
      festivalName: 'વિશેષ ઉત્સવ',
    ),
    '2026-07-21': CalendarDayData(
      date: DateTime(2026, 7, 21),
      tithiName: 'અષાઢ સુદ આઠમ, વિ.સ. ૨૦૮૨',
    ),
    '2026-07-25': CalendarDayData(
      date: DateTime(2026, 7, 25),
      tithiName: 'અષાઢ સુદ અગિયારસ (દેવશયની અગિયારસ)',
      isEkadashi: true,
    ),
    '2026-07-29': CalendarDayData(
      date: DateTime(2026, 7, 29),
      tithiName: 'અષાઢ સુદ પૂનમ (ગુરુ પૂનમ)',
      isPoonam: true,
    ),
  };

  // Helper method for API fetch integration
  Future<void> _fetchCalendarDataForMonth(DateTime month) async {
    // TODO: Add your API Service call here using your API Key
    // Example: final response = await CalendarApiService.getTippani(month, apiKey);
  }

  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _getGujaratiMonthName(int month) {
    const months = [
      'જાન્યુઆરી',
      'ફેબ્રુઆરી',
      'માર્ચ',
      'એપ્રિલ',
      'મે',
      'જૂન',
      'જુલાઈ',
      'ઓગસ્ટ',
      'સપ્ટેમ્બર',
      'ઓક્ટોબર',
      'નવેમ્બર',
      'ડિસેમ્બર',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );
    final firstWeekday =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

    final selectedKey = _formatDateKey(_selectedDate);
    final selectedDayData =
        _calendarApiMockData[selectedKey] ??
        CalendarDayData(
          date: _selectedDate,
          tithiName: 'અષાઢ સુદ આઠમ, વિ.સ. ૨૦૮૨',
        );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "ટિપ્પણી (Calendar)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // 1. MONTH HEADER WITH NAVIGATION ARROWS
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.purple,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        _focusedMonth = DateTime(
                          _focusedMonth.year,
                          _focusedMonth.month - 1,
                          1,
                        );
                        _fetchCalendarDataForMonth(_focusedMonth);
                      });
                    },
                  ),
                  Text(
                    "${_getGujaratiMonthName(_focusedMonth.month)} ${_focusedMonth.year}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.purple,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        _focusedMonth = DateTime(
                          _focusedMonth.year,
                          _focusedMonth.month + 1,
                          1,
                        );
                        _fetchCalendarDataForMonth(_focusedMonth);
                      });
                    },
                  ),
                ],
              ),
            ),

            // 2. WEEKDAY HEADER ROW
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "રવિ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "સોમ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "મંગળ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "બુધ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "ગુરુ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "શુક્ર",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "શનિ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),

            // 3. CALENDAR GRID VIEW
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: firstWeekday + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < firstWeekday) {
                    return const SizedBox.shrink();
                  }

                  final dayNumber = index - firstWeekday + 1;
                  final currentDate = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month,
                    dayNumber,
                  );
                  final dateKey = _formatDateKey(currentDate);
                  final dayData = _calendarApiMockData[dateKey];

                  final isSelected = DateUtils.isSameDay(
                    currentDate,
                    _selectedDate,
                  );

                  // Colors derived from screenshot
                  Color? bgColor;
                  if (dayData?.isEkadashi ?? false) {
                    bgColor = const Color(0xFFF9D29D); // Orange/Peach
                  } else if (dayData?.isPoonam ?? false) {
                    bgColor = const Color(0xFFE0F8FF); // Light Blue
                  } else if (dayData?.isAmas ?? false) {
                    bgColor = const Color(0xFFE5E5E5); // Light Grey
                  } else if (dayData?.isFestival ?? false) {
                    bgColor = const Color(0xFFFF9EA2); // Coral/Red
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = currentDate;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bgColor,
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFFFF2A7A),
                                width: 4,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "$dayNumber",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 4. COLOR LEGEND BAR
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: const Color(0xFF386B91), // Matching dark cyan blue bar
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem(
                    color: const Color(0xFFF9D29D),
                    label: "એકાદશી",
                  ),
                  _buildLegendItem(
                    color: const Color(0xFFE0F8FF),
                    label: "પૂનમ",
                  ),
                  _buildLegendItem(
                    color: const Color(0xFFE5E5E5),
                    label: "અમાસ",
                  ),
                  _buildLegendItem(
                    color: const Color(0xFFFF9EA2),
                    label: "તહેવાર",
                  ),
                ],
              ),
            ),

            // 5. SELECTED TITHI DETAIL FOOTER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              color: theme.cardTheme.color,
              child: Text(
                selectedDayData.tithiName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
