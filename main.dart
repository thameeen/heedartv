
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const HeedarTvApp());
}

const gold = Color(0xFFD4AF37);
const bg = Color(0xFF07080A);
const cardBg = Color(0xFF12151D);

// غيّر الرمز التجريبي لاحقاً
const String adultPin = '2580';

class MediaLink {
  final String title;
  final String subtitle;
  final String category;
  final String url;
  final IconData icon;

  const MediaLink(
    this.title,
    this.subtitle,
    this.category,
    this.url,
    this.icon,
  );

  Uri get uri => Uri.parse(url);
}

// المصادر الرسمية المتاحة
const catalog = <MediaLink>[
  MediaLink(
    'التلفزيون الأردني',
    'البث الرسمي المباشر',
    'قنوات',
    'https://www.jrtv.gov.jo/ar/live-tv',
    Icons.live_tv,
  ),
  MediaLink(
    'رؤيا',
    'البث المباشر',
    'قنوات',
    'https://roya.tv/live-stream/1',
    Icons.live_tv,
  ),
  MediaLink(
    'قنوات رؤيا',
    'قنوات متنوعة',
    'قنوات',
    'https://roya.tv/',
    Icons.tv,
  ),
  MediaLink(
    'الجزيرة',
    'بث مباشر للأخبار',
    'أخبار',
    'https://www.aljazeera.net/live',
    Icons.newspaper,
  ),
  MediaLink(
    'العربية',
    'بث مباشر',
    'أخبار',
    'https://www.alarabiya.net/live-stream',
    Icons.newspaper,
  ),
  MediaLink(
    'الحدث',
    'بث مباشر',
    'أخبار',
    'https://www.alarabiya.net/live-stream-hadath',
    Icons.newspaper,
  ),
  MediaLink(
    'قناة المملكة',
    'الأخبار الأردنية',
    'أخبار',
    'https://almamlakatv.com/',
    Icons.newspaper,
  ),
  MediaLink(
    'التلفزيون الأردني الرياضي',
    'المحتوى الرياضي الرسمي',
    'رياضة',
    'https://www.jrtv.gov.jo/ar/live-tv',
    Icons.sports_soccer,
  ),
  MediaLink(
    'Roya Sports',
    'أخبار وملخصات رياضية',
    'رياضة',
    'https://www.youtube.com/royasports',
    Icons.sports_soccer,
  ),
  MediaLink(
    'Jordan TV Sport',
    'محتوى رياضي رسمي',
    'رياضة',
    'https://www.youtube.com/@jordantvsport',
    Icons.sports_soccer,
  ),
  MediaLink(
    'شاهد',
    'مسلسلات وأفلام عربية',
    'مسلسلات',
    'https://shahid.mbc.net/ar',
    Icons.movie,
  ),
  MediaLink(
    'مسلسلات رؤيا',
    'المسلسلات الرسمية',
    'مسلسلات',
    'https://roya.tv/series',
    Icons.tv,
  ),
  MediaLink(
    'مسلسلات التلفزيون الأردني',
    'الأرشيف الرسمي',
    'مسلسلات',
    'https://www.jrtv.gov.jo/ar/series',
    Icons.movie,
  ),
  MediaLink(
    'MBC Shahid YouTube',
    'حلقات ومقاطع رسمية',
    'مسلسلات',
    'https://www.youtube.com/@MBCShahid',
    Icons.smart_display,
  ),
  MediaLink(
    'tabii عربي',
    'دراما تركية',
    'مسلسلات تركية',
    'https://www.youtube.com/@tabii.arabic',
    Icons.subtitles,
  ),
  MediaLink(
    'قيامة أرطغرل',
    'قائمة الحلقات الرسمية',
    'مسلسلات تركية',
    'https://www.youtube.com/playlist?list=PLZhY-MJA-pw-hzp40xUApZd8LLgJEZD53',
    Icons.movie,
  ),
  MediaLink(
    'Deep in Love',
    'قائمة حلقات مترجمة',
    'مسلسلات تركية',
    'https://www.youtube.com/playlist?list=PLDoK5CcjJZA5zEFnpeYwsTjsMHfrQlpa_',
    Icons.subtitles,
  ),
  MediaLink(
    'أفلام شاهد',
    'أفلام عربية وأجنبية حسب الإتاحة',
    'أفلام',
    'https://shahid.mbc.net/ar/movies',
    Icons.movie_creation,
  ),
  MediaLink(
    'أفلام رؤيا',
    'المحتوى المتاح رسمياً',
    'أفلام',
    'https://roya.tv/',
    Icons.local_movies,
  ),
];

class HeedarTvApp extends StatelessWidget {
  const HeedarTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEEDAR TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selected = 'الكل';
  String query = '';

  bool adultUnlocked = false;
  bool opening = false;

  final Set<String> favorites = {};

  final List<String> categories = const [
    'الكل',
    'قنوات',
    'أفلام',
    'أكشن وإثارة',
    'مسلسلات',
    'مسلسلات تركية',
    'أخبار',
    'رياضة',
    '+18',
    'المفضلة',
  ];

  Future<void> unlockAdult() async {
    final controller = TextEditingController();

    final pin = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardBg,
          title: const Text(
            'قسم +18',
            style: TextStyle(color: gold),
          ),
          content: TextField(
            controller: controller,
            obscureText: true,
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              hintText: 'أدخل رمز PIN',
              prefixIcon: Icon(Icons.lock, color: gold),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, controller.text);
              },
              child: const Text('دخول'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (!mounted) return;

    if (pin == adultPin) {
      setState(() {
        adultUnlocked = true;
        selected = '+18';
      });
    } else if (pin != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('رمز PIN غير صحيح'),
        ),
      );
    }
  }

  Future<void> openOfficial(MediaLink item) async {
    setState(() => opening = true);

    try {
      final ok = await launchUrl(
        item.uri,
        mode: LaunchMode.externalApplication,
      );

      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر فتح الرابط'),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء فتح الرابط'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => opening = false);
      }
    }
  }

  void toggleFavorite(MediaLink item) {
    setState(() {
      if (favorites.contains(item.title)) {
        favorites.remove(item.title);
      } else {
        favorites.add(item.title);
      }
    });
  }

  List<MediaLink> get filteredItems {
    return catalog.where((item) {
      final categoryMatch =
          selected == 'الكل' ||
          item.category == selected ||
          (selected == 'المفضلة' &&
              favorites.contains(item.title));

      final queryMatch =
          '${item.title} ${item.subtitle} ${item.category}'
              .toLowerCase()
              .contains(query.toLowerCase());

      return categoryMatch && queryMatch;
    }).toList();
  }

  Widget buildCategoryChip(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(category),
        selected: selected == category,
        selectedColor: gold,
        backgroundColor: cardBg,
        labelStyle: TextStyle(
          color: selected == category
              ? Colors.black
              : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        onSelected: (_) {
          if (category == '+18' && !adultUnlocked) {
            unlockAdult();
          } else {
            setState(() {
              selected = category;
            });
          }
        },
      ),
    );
  }

  Widget buildMediaCard(MediaLink item) {
    final isFavorite = favorites.contains(item.title);

    return Card(
      color: cardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: gold.withOpacity(0.22),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 7,
        ),
        leading: CircleAvatar(
          backgroundColor: gold.withOpacity(0.15),
          child: Icon(
            item.icon,
            color: gold,
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${item.category} • ${item.subtitle}',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'المفضلة',
              onPressed: () => toggleFavorite(item),
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isFavorite ? Colors.redAccent : gold,
              ),
            ),
            const Icon(
              Icons.open_in_new,
              color: gold,
              size: 20,
            ),
          ],
        ),
        onTap: () => openOfficial(item),
      ),
    );
  }

  Widget buildEmptyState() {
    String message = 'لا توجد نتائج حالياً';

    if (selected == '+18') {
      message = 'لا يوجد محتوى مضاف لهذا القسم حالياً';
    } else if (selected == 'المفضلة') {
      message = 'لم تضف أي عنصر إلى المفضلة بعد';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            color: gold.withOpacity(0.6),
            size: 65,
          ),
          const SizedBox(height: 15),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0E14),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HEEDAR TV',
              style: TextStyle(
                color: gold,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'منصتك الترفيهية',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white60,
              ),
            ),
          ],
        ),
        actions: [
          if (opening)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: gold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              14,
              16,
              8,
            ),
            child: TextField(
              onChanged: (value) {
                setState(() => query = value);
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن قناة أو فيلم أو مسلسل',
                prefixIcon: const Icon(
                  Icons.search,
                  color: gold,
                ),
                filled: true,
                fillColor: cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              children: [
                for (final category in categories)
                  buildCategoryChip(category),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.video_library,
                  color: gold,
                  size: 17,
                ),
                const SizedBox(width: 8),
                Text(
                  selected == '+18'
                      ? 'قسم +18'
                      : selected == 'المفضلة'
                          ? 'قائمة المفضلة'
                          : 'قسم $selected',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                Text(
                  '${items.length} عنصر',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: items.isEmpty
                ? buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 9),
                    itemBuilder: (context, index) {
                      return buildMediaCard(items[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
