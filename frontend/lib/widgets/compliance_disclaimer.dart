import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Compliance Disclaimer Widget
/// Shows SEBI and regulatory compliance disclaimers
class ComplianceDisclaimer extends StatelessWidget {
  final bool isCompact;

  const ComplianceDisclaimer({
    Key? key,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _CompactDisclaimer();
    }
    return _FullDisclaimer();
  }
}

class _CompactDisclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: Colors.amber.shade800,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This app does not provide investment advice. All analytics are based on historical trades only.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullDisclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'Important Disclaimers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DisclaimerItem(
            icon: Icons.block,
            text: 'This app does not provide investment advice, trading signals, or recommendations.',
          ),
          const SizedBox(height: 12),
          _DisclaimerItem(
            icon: Icons.history,
            text: 'All analytics, insights, and statistics are based solely on your historical trade data.',
          ),
          const SizedBox(height: 12),
          _DisclaimerItem(
            icon: Icons.warning_amber,
            text: 'Trading in financial markets involves significant risk. Past performance does not guarantee future results.',
          ),
          const SizedBox(height: 12),
          _DisclaimerItem(
            icon: Icons.gavel,
            text: 'This app is a journaling and analytics tool only. It is not a trading platform or advisory service.',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'SEBI Compliant: This app complies with SEBI guidelines for financial technology applications.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DisclaimerItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
