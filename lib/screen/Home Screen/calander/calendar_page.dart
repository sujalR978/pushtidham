import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:convert';

import 'package:table_calendar/table_calendar.dart';

// A data model for calendar events.
// You should adjust this to match the structure of the data from your API.
class PanchangEvent {
  final String title;
  final String type; // e.g., 'Tithi', 'Festival', 'Nakshatra'

  PanchangEvent({required this.title, required this.type});

  @override
  String toString() => title;
}

class TippaniCalendarPage extends StatefulWidget {
  const TippaniCalendarPage({super.key});

  @override
  State<TippaniCalendarPage> createState() => _TippaniCalendarPageState();
}

class _TippaniCalendarPageState extends State<TippaniCalendarPage> {
  late final ValueNotifier<List<PanchangEvent>> _selectedEvents;
  Map<DateTime, List<PanchangEvent>> _events = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _isLoading = true;
  String? _error;

  // IMPORTANT: Replace 'YOUR_API_KEY_HERE' with your actual API key.
  // It is recommended to store API keys securely and not hardcode them in source files.
  final String _apiKey = 'YOUR_API_KEY_HERE';

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // Fetch data for the initial month.
    _fetchMonthData(_focusedDay.year, _focusedDay.month);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _fetchMonthData(int year, int month) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // This is a hypothetical API endpoint.
    // You MUST adjust the URL, parameters, and response parsing based on your chosen API.
    // This example assumes an API like panchang.pro for Gujarati calendar data.
    final uri = Uri.parse(
      'https://api.panchang.pro/v1/calendar?year=$year&month=$month&language=gu',
    );

    try {
      // If your API key needs to be sent as a header, use this.
      // Otherwise, you might need to send it as a query parameter.
      final response = await http.get(
        uri,
        headers: {
          // 'Authorization': 'Bearer $_apiKey', // Example for Bearer token
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<DateTime, List<PanchangEvent>> fetchedEvents = {};

        // This parsing logic is an EXAMPLE. You MUST adapt it to your API's response structure.
        if (data is List) {
          for (var dayData in data) {
            // Use DateTime.utc to avoid timezone issues when using dates as map keys.
            final date = DateTime.utc(
              dayData['year'],
              dayData['month'],
              dayData['day'],
            );
            final eventsForDay = <PanchangEvent>[];

            if (dayData['tithi'] != null &&
                dayData['tithi']['details']?['tithi_name'] != null) {
              eventsForDay.add(
                PanchangEvent(
                  title: 'તિથિ: ${dayData['tithi']['details']['tithi_name']}',
                  type: 'Tithi',
                ),
              );
            }

            if (dayData['festivals'] is List &&
                dayData['festivals'].isNotEmpty) {
              for (var festival in dayData['festivals']) {
                if (festival is String) {
                  eventsForDay.add(
                    PanchangEvent(title: festival, type: 'Festival'),
                  );
                }
              }
            }

            if (eventsForDay.isNotEmpty) {
              fetchedEvents[date] = eventsForDay;
            }
          }
        }

        setState(() {
          _events = fetchedEvents;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to connect. Please check your internet connection.';
        _isLoading = false;
      });
    }
  }

  List<PanchangEvent> _getEventsForDay(DateTime day) {
    final dayUtc = DateTime.utc(day.year, day.month, day.day);
    return _events[dayUtc] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    _fetchMonthData(focusedDay.year, focusedDay.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tippani Calendar')),
      body: Column(
        children: [
          TableCalendar<PanchangEvent>(
            locale: 'gu_IN', // For Gujarati locale
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: HeaderStyle(
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMMM(locale).format(date),
              formatButtonVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: _onPageChanged,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            Expanded(child: Center(child: Text(_error!)))
          else
            Expanded(
              child: ValueListenableBuilder<List<PanchangEvent>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  if (value.isEmpty) {
                    return const Center(child: Text('આ દિવસે કોઈ વિગત નથી.'));
                  }
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        child: ListTile(title: Text(value[index].title)),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
