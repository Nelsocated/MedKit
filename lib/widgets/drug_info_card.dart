import 'package:flutter/material.dart';

import '../models/drug_info.dart';

class DrugInfoCard extends StatelessWidget {
  final DrugInfo info;

  const DrugInfoCard({super.key, required this.info});

  Widget _section(BuildContext context, String label, String text) {
    String body = text;
    if (body.isEmpty) {
      body = 'Not listed';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(body),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = info.brandName;
    if (title.isEmpty) {
      title = info.genericName;
    }

    String subtitle = info.genericName;
    if (info.manufacturer.isNotEmpty) {
      if (subtitle.isEmpty) {
        subtitle = info.manufacturer;
      } else {
        subtitle = '${info.genericName} · ${info.manufacturer}';
      }
    }

    return Card(
      child: ExpansionTile(
        title: Text(title),
        subtitle: Text(subtitle),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        children: [
          _section(context, "What it's for", info.purpose),
          _section(context, 'How to take it', info.dosage),
          _section(context, 'Warnings', info.warnings),
        ],
      ),
    );
  }
}
