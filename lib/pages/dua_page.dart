import 'package:flutter/material.dart';
import '../components/components.dart';

class DuaPage extends StatelessWidget {
  const DuaPage({super.key});

  // Common daily duas with Arabic, translation, and reference
  static final List<Map<String, String>> duas = [
    {
      'title': 'Morning Dua',
      'arabic': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ',
      'translation':
          'We have entered the morning and the kingdom belongs to Allah, and all praise is for Allah.',
      'reference': 'Sahih al-Bukhari',
    },
    {
      'title': 'Evening Dua',
      'arabic': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ',
      'translation':
          'We have entered the evening and the kingdom belongs to Allah, and all praise is for Allah.',
      'reference': 'Sahih al-Bukhari',
    },
    {
      'title': 'Before Sleeping',
      'arabic': 'بِسْمِكَ اللَّهُمَّ أَموتُ وَأَحْيَا',
      'translation': 'In Your name, O Allah, I die and live.',
      'reference': 'Sahih al-Bukhari',
    },
    {
      'title': 'After Waking Up',
      'arabic':
          'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      'translation':
          'All praise is for Allah who gave us life after death and to Him is the return.',
      'reference': 'Sahih al-Bukhari',
    },
    {
      'title': 'Entering Mosque',
      'arabic': 'أَللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      'translation': 'O Allah, open the doors of Your mercy for me.',
      'reference': 'Sahih Muslim',
    },
    {
      'title': 'Leaving Mosque',
      'arabic': 'أَللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      'translation': 'O Allah, I ask You from Your bounty.',
      'reference': 'Sahih Muslim',
    },
    {
      'title': 'Before Eating',
      'arabic': 'بِسْمِ اللَّهِ وَرَحْمَةِ اللَّهِ',
      'translation': 'In the name of Allah and with His mercy.',
      'reference': 'Sunan Abi Dawud',
    },
    {
      'title': 'After Eating',
      'arabic':
          'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِينَ',
      'translation':
          'All praise is for Allah who fed us, gave us drink, and made us from the Muslims.',
      'reference': 'Sahih al-Bukhari',
    },
    {
      'title': 'For Increase in Knowledge',
      'arabic': 'رَبِّ زِدْنِي عِلْمًا وَرُزْقًا طَيِّبًا وَعَمَلًا صَالِحًا',
      'translation':
          'O Lord, increase me in knowledge, good provision, and righteous deeds.',
      'reference': 'Tirmidhi',
    },
    {
      'title': 'Protection from Evil',
      'arabic':
          'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      'translation':
          'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      'reference': 'Sahih Muslim',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(title: 'Daily Duas'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: duas.length,
        itemBuilder: (context, index) {
          final dua = duas[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dua['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dua['arabic']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Arial',
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dua['translation']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reference: ${dua['reference']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
