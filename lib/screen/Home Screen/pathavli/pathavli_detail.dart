import 'package:flutter/material.dart';
import 'package:pushtidham/model/pathavali_model.dart';


class PathavaliDetailPage extends StatelessWidget {
  final PathavaliItem item;

  const PathavaliDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF38D3F8), // Matching cyan color
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "(${item.id}) ${item.title}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: Text(
              item.content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                height: 1.8,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}