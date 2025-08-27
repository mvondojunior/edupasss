import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String? label;
  final String hintText;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final Function(String?) onChanged;

  const CustomDropdownField({
    this.label,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100], // comme le TextField
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hintText,
                style: TextStyle(color: Colors.grey[600]), // même style que hintText
              ),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              items: items,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              dropdownColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}