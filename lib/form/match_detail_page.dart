import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello/routes/app_routes.dart';

import 'stadium_catalog.dart';

/// Detail of one match. Ticket choices stay maps (`detailItems`), not a model.
class MatchDetailPage extends StatefulWidget {
  const MatchDetailPage({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final details = detailItemsOf(item);
    final picked = _selected == null ? null : details[_selected!];

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
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: _topBar(context, item)),
                      SliverToBoxAdapter(child: _hero(item, details.length)),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
                          child: Row(
                            children: [
                              const Text(
                                'DETAIL ITEM',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${details.length} pilihan',
                                style: const TextStyle(color: Colors.white38, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                        sliver: SliverList.separated(
                          itemCount: details.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _TicketCard(
                              detail: details[index],
                              selected: _selected == index,
                              onTap: () => setState(() => _selected = index),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _bottomBar(context, item, picked),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          ),
          Expanded(
            child: Text(
              item['competition'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Text(
            item['kickoff'] as String,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _hero(Map<String, dynamic> item, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF17233A),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item['badge'] as String,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _TeamBlock(
                    short: item['homeShort'] as String,
                    name: item['home'] as String,
                    color: Color(item['homeColor'] as int),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: _TeamBlock(
                    short: item['awayShort'] as String,
                    name: item['away'] as String,
                    color: Color(item['awayColor'] as int),
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${item['date']}  ·  ${item['venue']}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Text(
              item['blurb'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 10),
            Text(
              '$count detail item di laga ini',
              style: const TextStyle(color: Color(0xFFFFC107), fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar(
    BuildContext context,
    Map<String, dynamic> match,
    Map<String, dynamic>? picked,
  ) {
    final label = picked == null ? 'Belum dipilih' : picked['name'] as String;
    final price = picked == null ? 'Pilih 1 item dulu' : formatRupiah(picked['price'] as int);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Color(0xFF101826),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: TextStyle(
                    color: picked == null ? Colors.white38 : const Color(0xFFFFC107),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              foregroundColor: Colors.black,
              disabledBackgroundColor: const Color(0xFF2A3344),
              disabledForegroundColor: Colors.white38,
              elevation: 0,
              minimumSize: const Size(138, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: picked == null
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.seatingMap,
                      arguments: <String, dynamic>{
                        'match': match,
                        'ticket': picked,
                        'ticketName': picked['name'],
                        'gate': picked['gate'],
                        'price': picked['price'],
                      },
                    );
                  },
            child: const Text(
              'Pilih kursi',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamBlock extends StatelessWidget {
  const _TeamBlock({
    required this.short,
    required this.name,
    required this.color,
    this.alignEnd = false,
  });

  final String short;
  final String name;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.18),
            border: Border.all(color: color.withOpacity(0.9), width: 1.5),
          ),
          child: Text(
            short,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.detail,
    required this.selected,
    required this.onTap,
  });

  final Map<String, dynamic> detail;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final left = detail['left'] as int;
    final low = left < 80;

    return Material(
      color: selected ? const Color(0xFF2A2412) : const Color(0xFF162033),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? const Color(0xFFFFC107) : Colors.white10,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: selected ? const Color(0xFFFFC107) : Colors.white38,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            detail['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatRupiah(detail['price'] as int),
                          style: const TextStyle(
                            color: Color(0xFFFFC107),
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${detail['gate']}  ·  $left kursi',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      detail['note'] as String,
                      style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.35),
                    ),
                    if (low) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Hampir habis',
                        style: TextStyle(
                          color: Color(0xFFFFB74D),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
