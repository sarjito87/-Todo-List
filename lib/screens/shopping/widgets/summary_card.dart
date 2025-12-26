import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int total;
  final int bought;

  const SummaryCard({super.key, required this.total, required this.bought});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.indigo.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem("Total", total.toString()),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildItem("Belum", (total - bought).toString()),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildItem("Sudah", bought.toString()),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }
}