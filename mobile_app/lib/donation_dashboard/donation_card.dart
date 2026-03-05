import 'package:flutter/material.dart';
import 'donation_model.dart';

class DonationCard extends StatelessWidget {
  final DonationCase donationCase;
  final VoidCallback onDonate;
  final VoidCallback? onCardClick;

  const DonationCard({
    Key? key,
    required this.donationCase,
    required this.onDonate,
    this.onCardClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onCardClick,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          donationCase.name,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (donationCase.isFromContacts)
                          Text(
                            '${donationCase.relationship} • ${donationCase.location}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (donationCase.isFromContacts)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Contact',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (donationCase.hasHelpPost)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.article_outlined, size: 16, color: colorScheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        'Uploaded Help Post',
                        style: TextStyle(
                          color: colorScheme.secondary,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                donationCase.story,
                style: textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              if (donationCase.requestedFrom.isNotEmpty)
                 Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_pin, size: 16, color: colorScheme.onSecondaryContainer),
                            const SizedBox(width: 8),
                            Text(
                              'Requesting from:',
                              style: TextStyle(
                                color: colorScheme.onSecondaryContainer,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: donationCase.requestedFrom.map((name) => Chip(
                            label: Text(name, style: TextStyle(fontSize: 11)),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            backgroundColor: colorScheme.surface,
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Raised: ৳${donationCase.currentAmount.toStringAsFixed(0)}',
                        style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.primary),
                      ),
                      Text(
                        'Goal: ৳${donationCase.targetAmount.toStringAsFixed(0)}',
                        style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: donationCase.progress,
                    backgroundColor: colorScheme.surfaceVariant,
                    color: colorScheme.primary,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onDonate,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Donate Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
