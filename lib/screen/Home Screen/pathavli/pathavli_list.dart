import 'package:flutter/material.dart';
import 'package:pushtidham/model/pathavali_model.dart';
import 'package:pushtidham/screen/Home%20Screen/pathavli/pathavli_detail.dart';

class PathavaliListPage extends StatelessWidget {
  const PathavaliListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF38D3F8), // Matching cyan color
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () {
            // Handle back button press or pop context
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'પાઠાવલી (ષોડશ ગ્રંથ)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
      ),
      body: ListView.separated(
        itemCount: pathavaliList.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFE5E7EB),
        ),
        itemBuilder: (context, index) {
          final item = pathavaliList[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            title: Text(
              "(${item.id}) ${item.title}",
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              // Open Detail Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PathavaliDetailPage(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}