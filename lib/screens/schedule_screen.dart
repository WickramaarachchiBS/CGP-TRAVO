import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime selectedMonth = DateTime(2025, 9);
  List<int> selectedDays = [19, 25]; // Blue highlighted days

  // Hotel booking data
  final List<Map<String, dynamic>> bookings = [
    {
      'name': 'Hilton',
      'date': '19 March 2024',
      'price': 'Rs.20000',
      'image': 'assets/hilton.jpg',
    },
    {
      'name': 'Cinnamon Grand',
      'date': '25 March 2024',
      'price': 'Rs.20000',
      'image': 'assets/e025f0c5fa81a93236d946f06d436f9c.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button, title and settings
              _buildHeader(),
              const SizedBox(height: 20),

              // Month selector and calendar
              _buildCalendar(),
              const SizedBox(height: 20),

              // My Schedule heading and "See all" button
              _buildScheduleHeader(),
              const SizedBox(height: 16),

              // Bookings list
              Expanded(child: _buildBookingsList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
        const Text(
          'Schedule',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: () {
            // Handle settings button press
          },
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        // Month selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(selectedMonth),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month - 1,
                      );
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month + 1,
                      );
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Day labels (S M T W T F S)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map(
                (day) => SizedBox(
                  width: 30,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),

        // Calendar grid
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    // Get first day of the month
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);

    // Get the weekday of the first day (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
    final firstDayWeekday = firstDay.weekday % 7;

    // Get the last day of the month
    final lastDay = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

    // Calculate total days to display including previous and next month days
    final totalDaysToDisplay = ((firstDayWeekday + lastDay.day + 6) ~/ 7) * 7;

    List<Widget> calendarCells = [];

    // Previous month days
    int prevMonthDays = DateTime(selectedMonth.year, selectedMonth.month, 0).day;
    for (int i = 0; i < firstDayWeekday; i++) {
      calendarCells.add(
        _buildDayCell(prevMonthDays - firstDayWeekday + i + 1, true),
      );
    }

    // Current month days
    for (int i = 1; i <= lastDay.day; i++) {
      calendarCells.add(
        _buildDayCell(i, false, isSelected: selectedDays.contains(i)),
      );
    }

    // Next month days
    int nextMonthDay = 1;
    while (calendarCells.length < totalDaysToDisplay) {
      calendarCells.add(_buildDayCell(nextMonthDay++, true));
    }

    // Split days into rows (weeks)
    List<Widget> calendarRows = [];
    for (int i = 0; i < calendarCells.length; i += 7) {
      calendarRows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: calendarCells.sublist(
            i,
            i + 7 > calendarCells.length ? calendarCells.length : i + 7,
          ),
        ),
      );
    }

    return Column(
      children: calendarRows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: row,
        );
      }).toList(),
    );
  }

  Widget _buildDayCell(int day, bool isOtherMonth, {bool isSelected = false}) {
    return GestureDetector(
      onTap: isOtherMonth
          ? null
          : () {
              setState(() {
                if (selectedDays.contains(day)) {
                  selectedDays.remove(day);
                } else {
                  selectedDays.add(day);
                }
              });
            },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          day.toString(),
          style: TextStyle(
            color: isOtherMonth
                ? Colors.grey.shade400
                : isSelected
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'My Schedule',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            // Handle "See all" button press
          },
          child: const Text('See all', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildBookingsList() {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              // Handle booking item tap
            },
            child: Row(
              children: [
                // Hotel image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.asset(
                    booking['image'],
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Placeholder for missing image
                      return Container(
                        width: 100,
                        height: 80,
                        color: Colors.grey.shade300,
                      );
                    },
                  ),
                ),

                // Booking details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              booking['date'],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${booking['price']}/night',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Arrow icon
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
