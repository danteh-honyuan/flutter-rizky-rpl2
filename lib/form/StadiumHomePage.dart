import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello/routes/app_routes.dart';

import 'match_detail_page.dart';
import 'stadium_catalog.dart';

class StadiumHomePage extends StatefulWidget {
  const StadiumHomePage({super.key});

  @override
  State<StadiumHomePage> createState() => _StadiumHomePageState();
}

class _StadiumHomePageState extends State<StadiumHomePage> {
  static const _filters = ['Semua', 'Liga 1', 'Friendly', 'Piala'];
  String _filter = 'Semua';

  List<Map<String, dynamic>> get _visible {
    if (_filter == 'Semua') return kStadiumItems;
    return [
      for (final item in kStadiumItems)
        if (item['competition'] == _filter) item,
    ];
  }

  void _openDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MatchDetailPage(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    final featured = items.isEmpty ? null : items.first;
    final rest = items.length <= 1 ? const <Map<String, dynamic>>[] : items.sublist(1);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1220),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B1B2F), Color(0xFF162447), Color(0xFF0B1220)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(context)),
                const SliverToBoxAdapter(child: _Lead()),
                SliverToBoxAdapter(child: _filtersRow()),
                if (featured == null)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'Belum ada pertandingan di kategori ini.',
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: _FeaturedCard(
                      item: featured,
                      onTap: () => _openDetail(featured),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                      child: Row(
                        children: [
                          const Text(
                            'DAFTAR PERTANDINGAN',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            rest.isEmpty ? 'Cuma sorotan' : '${rest.length} lainnya',
                            style: const TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (rest.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 28),
                        child: Text(
                          'Tidak ada pertandingan lain di kategori ini.',
                          style: TextStyle(color: Colors.white60, height: 1.4),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      sliver: SliverList.separated(
                        itemCount: rest.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = rest[index];
                          return _MatchTile(
                            item: item,
                            onTap: () => _openDetail(item),
                          );
                        },
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
      child: Row(
        children: [
          const Icon(Icons.sports_soccer, color: Color(0xFFFFC107), size: 26),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ARENA PASS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                  ),
                ),
                Text(
                  'Banten Stadium',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Peta tribun',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.seatingMap),
            icon: const Icon(Icons.map_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _filtersRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          for (var i = 0; i < _filters.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            ChoiceChip(
              label: Text(_filters[i]),
              selected: _filter == _filters[i],
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              onSelected: (_) => setState(() => _filter = _filters[i]),
              selectedColor: const Color(0xFFFFC107),
              backgroundColor: const Color(0xFF162033),
              labelStyle: TextStyle(
                color: _filter == _filters[i] ? Colors.black : Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              side: BorderSide(
                color: _filter == _filters[i]
                    ? const Color(0xFFFFC107)
                    : Colors.white12,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ],
      ),
    );
  }
}

class _Lead extends StatelessWidget {
  const _Lead();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih laga, lalu lihat item tiketnya.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pilih pertandingan di Banten Stadium, bandingkan tribun, lalu lanjut ke peta kursi.',
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item, required this.onTap});

  final Map<String, dynamic> item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final details = detailItemsOf(item);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Material(
        color: const Color(0xFF17233A),
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0x55FFC107)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _Tag(text: item['badge'] as String, filled: true),
                    const SizedBox(width: 8),
                    _Tag(text: item['competition'] as String, filled: false),
                    const Spacer(),
                    Text(
                      item['kickoff'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Crest(
                      short: item['homeShort'] as String,
                      color: Color(item['homeColor'] as int),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['home'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            'vs',
                            style: TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                          Text(
                            item['away'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _Crest(
                      short: item['awayShort'] as String,
                      color: Color(item['awayColor'] as int),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  '${item['date']}  ·  ${item['venue']}',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Dari ${formatRupiah(lowestPrice(item))}',
                        style: const TextStyle(
                          color: Color(0xFFFFC107),
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      '${details.length} item tiket',
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white54),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({required this.item, required this.onTap});

  final Map<String, dynamic> item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = detailItemsOf(item).length;
    return Material(
      color: const Color(0xFF162033),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              _Crest(
                short: item['homeShort'] as String,
                color: Color(item['homeColor'] as int),
                size: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item['home']} vs ${item['away']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item['date']}  ·  ${item['kickoff']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item['competition']}  ·  $count item',
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'dari',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                  Text(
                    formatRupiah(lowestPrice(item)),
                    style: const TextStyle(
                      color: Color(0xFFFFC107),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Crest extends StatelessWidget {
  const _Crest({required this.short, required this.color, this.size = 48});

  final String short;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.18),
        border: Border.all(color: color.withOpacity(0.85), width: 1.4),
      ),
      child: Text(
        short,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.28,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.filled});

  final String text;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? const Color(0xFFFFC107) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: filled ? null : Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: filled ? Colors.black : Colors.white70,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
