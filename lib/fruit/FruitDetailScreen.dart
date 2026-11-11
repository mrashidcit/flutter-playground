import 'package:flutter/material.dart';
import 'package:flutter_play_ground/fruit/Fruit.dart';

/// Static nutrition / benefit info for a fruit.
class FruitInfo {
  const FruitInfo({
    required this.emoji,
    required this.color,
    required this.proteinPer100g,
    required this.benefits,
  });

  /// Used as the fruit's image (no asset files or network needed).
  final String emoji;

  /// Background colour behind the image.
  final Color color;

  /// Grams of protein per 100 g (raw), or null if unknown.
  final double? proteinPer100g;

  final List<String> benefits;

  /// Info for fruits that are not in [_catalog] (e.g. newly added ones).
  static const unknown = FruitInfo(
    emoji: '🍽️',
    color: Colors.grey,
    proteinPer100g: null,
    benefits: ['No details available for this fruit yet.'],
  );

  /// Looks up info by fruit name (case-insensitive).
  static FruitInfo of(String name) =>
      _catalog[name.trim().toLowerCase()] ?? unknown;

  // Approximate values per 100 g of raw fruit.
  static const Map<String, FruitInfo> _catalog = {
    'apple': FruitInfo(
      emoji: '🍎',
      color: Colors.red,
      proteinPer100g: 0.3,
      benefits: [
        'High in fibre (pectin), which supports digestion',
        'Rich in antioxidants like quercetin',
        'Helps keep you full, supporting weight management',
        'May support heart health',
      ],
    ),
    'banana': FruitInfo(
      emoji: '🍌',
      color: Colors.amber,
      proteinPer100g: 1.1,
      benefits: [
        'Great source of potassium for heart and muscle function',
        'Quick natural energy from carbohydrates',
        'Contains vitamin B6',
        'Easy to digest and gentle on the stomach',
      ],
    ),
    'blueberry': FruitInfo(
      emoji: '🫐',
      color: Colors.indigo,
      proteinPer100g: 0.7,
      benefits: [
        'One of the highest antioxidant fruits (anthocyanins)',
        'May support memory and brain health',
        'Good source of vitamin C and vitamin K',
        'Low in calories',
      ],
    ),
    'cherry': FruitInfo(
      emoji: '🍒',
      color: Colors.pink,
      proteinPer100g: 1.1,
      benefits: [
        'Anti-inflammatory compounds may ease muscle soreness',
        'Natural source of melatonin, which can aid sleep',
        'Rich in vitamin C and potassium',
        'Packed with antioxidants',
      ],
    ),
    'coconut': FruitInfo(
      emoji: '🥥',
      color: Colors.brown,
      proteinPer100g: 3.3,
      benefits: [
        'Highest protein of the fruits here',
        'Rich in fibre and healthy fats (MCTs) for energy',
        'Good source of manganese and copper',
        'Coconut water helps with hydration',
      ],
    ),
    'grapes': FruitInfo(
      emoji: '🍇',
      color: Colors.purple,
      proteinPer100g: 0.7,
      benefits: [
        'Contain resveratrol, linked to heart health',
        'High water content keeps you hydrated',
        'Source of vitamin K and vitamin C',
        'Antioxidants may support eye health',
      ],
    ),
  };
}

/// Shows a fruit's image, protein content and health benefits.
class FruitDetailScreen extends StatelessWidget {
  const FruitDetailScreen({super.key, required this.fruit});

  final Fruit fruit;

  @override
  Widget build(BuildContext context) {
    final info = FruitInfo.of(fruit.name);
    final theme = Theme.of(context);
    final protein = info.proteinPer100g;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(fruit.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- Image ----------
          Container(
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: info.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(info.emoji, style: const TextStyle(fontSize: 120)),
          ),
          const SizedBox(height: 16),

          // ---------- Proteins ----------
          Card(
            child: ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Protein'),
              subtitle: const Text('per 100 g'),
              trailing: Text(
                protein == null ? 'N/A' : '${protein.toStringAsFixed(1)} g',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ---------- Benefits ----------
          Text('Benefits', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ...info.benefits.map(
            (benefit) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.check_circle, color: info.color),
              title: Text(benefit),
            ),
          ),
        ],
      ),
    );
  }
}
