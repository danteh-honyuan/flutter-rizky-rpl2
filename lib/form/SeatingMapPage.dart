import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hello/routes/app_routes.dart';


/// Holds seats confirmed in this running app session.
/// Reservations are separated by match, section, and block.
class SeatReservationStore {
  SeatReservationStore._();

  static final Set<String> _reserved = <String>{};

  static String matchKey(Map<String, dynamic>? match) {
    if (match == null || match.isEmpty) return 'default-match';
    final home = (match['home'] ?? '').toString().trim();
    final away = (match['away'] ?? '').toString().trim();
    final date = (match['date'] ?? '').toString().trim();
    final id = (match['id'] ?? '').toString().trim();
    final key = id.isNotEmpty ? id : '$home-$away-$date';
    return key == '--' || key == '' ? 'default-match' : key.toLowerCase();
  }

  static void reserve({
    required Map<String, dynamic>? match,
    required String section,
    required String block,
    required Iterable<String> seatLabels,
  }) {
    final game = matchKey(match);
    for (final label in seatLabels) {
      final seatId = label.contains('-') ? label.split('-').last : label;
      if (seatId.trim().isEmpty) continue;
      _reserved.add('$game|$section|$block|${seatId.trim()}');
    }
  }

  static bool isReserved({
    required Map<String, dynamic>? match,
    required String section,
    required String block,
    required String seatId,
  }) {
    return _reserved.contains(
      '${matchKey(match)}|$section|$block|$seatId',
    );
  }
}

/// Maps ticket name from detail page → sections that actually exist for that
/// ticket. No VIP on the map if the ticket is not VIP/VVIP.
List<String> sectionsForTicket(String? ticketName) {
  // Default matches the reference map: Utara / Timur / Selatan + VIP.
  if (ticketName == null || ticketName.trim().isEmpty) {
    return const [
      'Tribun Utara',
      'Tribun Timur',
      'Tribun Selatan',
      'VIP Utara',
      'VIP Selatan',
    ];
  }

  final n = ticketName.toLowerCase();

  if (n.contains('vvip') || n.contains('vip')) {
    return const ['VIP Utara', 'VIP Selatan'];
  }
  if (n.contains('utara') && !n.contains('vip')) {
    return const ['Tribun Utara'];
  }
  if (n.contains('timur')) return const ['Tribun Timur'];
  if (n.contains('selatan') && !n.contains('vip')) {
    return const ['Tribun Selatan'];
  }
  // The Barat-side seating area is represented by the two VIP sections.
  // Keeping a separate Tribun Barat arc caused it to overlap the VIP arcs.
  if (n.contains('barat')) return const ['VIP Utara', 'VIP Selatan'];
  if (n.contains('ekonomi') || n.contains('kategori 2')) {
    return const ['Tribun Utara', 'Tribun Selatan'];
  }
  if (n.contains('utama') || n.contains('kategori 1')) {
    return const ['Tribun Timur', 'Tribun Selatan'];
  }

  // Generic paid tribunes — no VIP seats on the map.
  return const [
    'Tribun Utara',
    'Tribun Timur',
    'Tribun Selatan',
  ];
}

class SeatingMapPage extends StatefulWidget {
  const SeatingMapPage({super.key});

  @override
  State<SeatingMapPage> createState() => _SeatingMapPageState();
}

class _SeatingMapPageState extends State<SeatingMapPage>
    with TickerProviderStateMixin {
  final Map<String, Set<String>> takenSeats = {
    'Tribun Utara': {'A3', 'A7', 'B2', 'B5', 'C1', 'C8', 'D4', 'E2'},
    'Tribun Timur': {'A2', 'A6', 'B4', 'C3', 'C7', 'D1', 'E5'},
    'Tribun Selatan': {'A1', 'A5', 'B3', 'B8', 'C4', 'D6', 'E3'},
    'VIP Utara': {'V2', 'V5', 'V8', 'V11'},
    'VIP Selatan': {'V1', 'V4', 'V7', 'V10'},
  };

  static const Map<String, Color> sectionColors = {
    'Tribun Utara': Color(0xFF2ECC71),
    'Tribun Timur': Color(0xFFF1C40F),
    'Tribun Selatan': Color(0xFF3498DB),
    'VIP Utara': Color(0xFF9B59B6),
    'VIP Selatan': Color(0xFFE91E8C),
  };

  List<String> allowedSections = List<String>.from(sectionsForTicket(null));
  String? ticketName;
  String? gate;
  int? ticketPrice;
  Map<String, dynamic>? match;

  String? selectedSection;
  String? selectedBlock;
  final Set<String> selectedSeats = {};

  late final AnimationController _seatAnimController;
  late final AnimationController _glowController;
  bool _argsRead = false;

  @override
  void initState() {
    super.initState();
    _seatAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsRead) return;
    _argsRead = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final map = Map<String, dynamic>.from(args);
      ticketName = map['ticketName'] as String?;
      gate = map['gate'] as String?;
      ticketPrice = map['price'] is int ? map['price'] as int : null;
      final rawMatch = map['match'];
      if (rawMatch is Map) {
        match = Map<String, dynamic>.from(rawMatch);
      }
    }

    final sections = sectionsForTicket(ticketName);
    allowedSections = List<String>.from(sections);

    // Auto-pick the only matching section so seats match the ticket.
    if (allowedSections.length == 1) {
      selectedSection = allowedSections.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {});
        _seatAnimController.forward(from: 0);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _seatAnimController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onSectionTap(String section) {
    if (!allowedSections.contains(section)) return;
    setState(() {
      selectedSection = section;
      selectedBlock = null;
      selectedSeats.clear();
    });
    _seatAnimController.forward(from: 0);
  }

  String _formatRupiah(int value) {
    final digits = value.toString();
    final out = StringBuffer('Rp ');
    for (var i = 0; i < digits.length; i++) {
      final fromEnd = digits.length - i;
      if (i > 0 && fromEnd % 3 == 0) out.write('.');
      out.write(digits[i]);
    }
    return out.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 18.0;

    final matchTitle = match == null
        ? null
        : '${match!['home']} vs ${match!['away']}';

    return Scaffold(
      backgroundColor: const Color(0xFF171027),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF292044), Color(0xFF130D20), Color(0xFF100B1B)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              16,
              horizontalPadding,
              28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'SEATING MAP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    if (matchTitle != null || ticketName != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF211832),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          children: [
                            if (matchTitle != null)
                              Text(
                                matchTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            if (ticketName != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                [
                                  ticketName!,
                                  if (gate != null) gate!,
                                  if (ticketPrice != null)
                                    _formatRupiah(ticketPrice!),
                                ].join('  ·  '),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFFFC84A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 6),
                            Text(
                              allowedSections.length == 1
                                  ? 'Hanya ${allowedSections.first} — sesuai tiket yang dipilih'
                                  : 'Hanya ${allowedSections.length} zona aktif untuk tiket ini',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),

                    AnimatedScale(
                      scale: selectedSection == null ? 1.0 : 1.03,
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.easeOutCubic,
                      child: AspectRatio(
                        aspectRatio: 1.35,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (details) {
                                final section = StadiumMapPainter.sectionAt(
                                  details.localPosition,
                                  constraints.biggest,
                                  allowedSections,
                                );
                                if (section != null) _onSectionTap(section);
                              },
                              child: CustomPaint(
                                painter: StadiumMapPainter(
                                  selectedSection: selectedSection,
                                  allowedSections: allowedSections,
                                ),
                                size: constraints.biggest,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildLegend(screenWidth),
                    const SizedBox(height: 14),
                    const Text(
                      'BANTEN INTERNATIONAL STADIUM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD8AE54),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (selectedSection != null) ...[
                      _buildSeatSelectionCard(),
                      const SizedBox(height: 20),
                    ] else ...[
                      Text(
                        allowedSections.length == 1
                            ? 'Ketuk zona ${allowedSections.first} pada peta'
                            : 'Ketuk zona yang tersedia pada peta (sesuai tiket)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.62),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedSeats.isEmpty
                              ? const Color(0xFF514B5A)
                              : const Color(0xFFFFC84A),
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: const Color(0xFF514B5A),
                          disabledForegroundColor: Colors.white54,
                          elevation: selectedSeats.isEmpty ? 0 : 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: selectedSeats.isEmpty
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.ticketInput,
                                  arguments: {
                                    'section': selectedSection,
                                    'block': selectedBlock,
                                    'seats': selectedSeats
                                        .map((seat) => seat.split('-').last)
                                        .toList(),
                                    'seatLabels': selectedSeats.toList(),
                                    'ticketName': ticketName,
                                    'gate': gate,
                                    'price': ticketPrice,
                                    'match': match,
                                  },
                                );
                              },
                        child: Text(
                          selectedSeats.isEmpty
                              ? 'Pilih Kursi Dulu'
                              : 'Lanjut ke Form Tiket (${selectedSeats.length})',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(double screenWidth) {
    final compact = screenWidth < 390;
    final items = [
      for (final section in allowedSections)
        if (sectionColors.containsKey(section))
          _LegendItem(color: sectionColors[section]!, label: section.toUpperCase()),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: compact ? 12 : 20,
      runSpacing: 12,
      children: items,
    );
  }

  List<String> _blocksForSection(String section) {
    switch (section) {
      case 'Tribun Utara':
        return ['U1', 'U2', 'U3'];
      case 'Tribun Timur':
        return ['T1', 'T2', 'T3'];
      case 'Tribun Selatan':
        return ['S1', 'S2', 'S3'];
      case 'VIP Utara':
        return ['VU1', 'VU2'];
      case 'VIP Selatan':
        return ['VS1', 'VS2'];
      default:
        return ['A1', 'A2', 'A3'];
    }
  }

  Widget _buildSeatSelectionCard() {
    final section = selectedSection!;
    final color = sectionColors[section] ?? const Color(0xFFFFC84A);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF211832),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.65), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.14),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedBlock == null
                          ? section
                          : '$section • $selectedBlock',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedBlock == null
                          ? 'Pilih blok tribun untuk memperbesar tampilan'
                          : 'Pilih kursi yang masih tersedia',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.62),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (selectedBlock != null) {
                      selectedBlock = null;
                      selectedSeats.clear();
                    } else if (allowedSections.length > 1) {
                      selectedSection = null;
                      selectedSeats.clear();
                    }
                  });
                  _seatAnimController.forward(from: 0);
                },
                child: Text(
                  selectedBlock == null
                      ? (allowedSections.length > 1 ? 'Ganti' : '')
                      : 'Blok',
                  style: const TextStyle(color: Color(0xFFFFC84A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: selectedBlock == null
                ? _buildBlockPicker(section, color)
                : Column(
                    key: ValueKey('seats-$selectedBlock'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBlockZoomDiagram(color),
                      const SizedBox(height: 16),
                      _buildAnimatedSeatGrid(section, selectedBlock!),
                    ],
                  ),
          ),
          if (selectedSeats.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0x33FFC84A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x88FFC84A)),
              ),
              child: Text(
                'Kursi dipilih: ${selectedSeats.join('  •  ')}',
                style: const TextStyle(
                  color: Color(0xFFFFD36A),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          const _SeatStatusLegend(),
        ],
      ),
    );
  }

  Widget _buildBlockPicker(String section, Color color) {
    final blocks = _blocksForSection(section);
    return Column(
      key: ValueKey('blocks-$section'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBlockZoomDiagram(color),
        const SizedBox(height: 12),
        const Text(
          'PILIH BLOK',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 9),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 360 ? 1 : blocks.length;
            final itemWidth = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - (columns - 1) * 8) / columns;
            return Wrap(
              spacing: 8,
              runSpacing: 10,
              children: blocks.map((block) {
                return SizedBox(
                  width: itemWidth,
                  child: Material(
                    color: color.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          selectedBlock = block;
                          selectedSeats.clear();
                        });
                        _seatAnimController.forward(from: 0);
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(9, 11, 9, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: color.withOpacity(0.75)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              block,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Mini plan: three visible rows of seats show
                            // that each block is its own physical seating area.
                            for (var row = 0; row < 3; row++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (_) => Container(
                                    width: 7,
                                    height: 7,
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  )),
                                ),
                              ),
                            const SizedBox(height: 6),
                            const Text(
                              'Pilih area kursi',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Setiap blok memiliki baris dan nomor kursi sendiri.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.48),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildBlockZoomDiagram(Color color) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF171126),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.zoom_in, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedBlock == null
                      ? 'Tampilan tribun diperbesar'
                      : 'Blok $selectedBlock',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedBlock == null
                      ? 'Pilih salah satu blok di bawah untuk melihat denah kursinya.'
                      : 'Pilih kursi pada denah di bawah. Kursi abu-abu sudah terisi.',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 42,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              border: Border.all(color: color.withOpacity(0.8), width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.stadium_outlined, color: color, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSeatGrid(String section, String block) {
    final isVip = section.contains('VIP');
    final rows = isVip ? ['V'] : ['A', 'B', 'C', 'D', 'E'];
    final seatsPerRow = isVip ? 12 : 14;
    final taken = takenSeats[section] ?? <String>{};

    return LayoutBuilder(
      builder: (context, constraints) {
        const labelWidth = 20.0;
        final seatSize = ((constraints.maxWidth - labelWidth) / seatsPerRow)
            .clamp(14.0, 25.0)
            .toDouble();

        return Column(
          children: List.generate(rows.length, (rowIndex) {
            final row = rows[rowIndex];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: labelWidth,
                    child: Text(
                      row,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...List.generate(seatsPerRow, (seatIndex) {
                    final seatId = '$row${seatIndex + 1}';
                    final seatKey = '$block-$seatId';
                    final isTaken = taken.contains(seatId) ||
                        SeatReservationStore.isReserved(
                          match: match,
                          section: section,
                          block: block,
                          seatId: seatId,
                        );
                    final isSelected = selectedSeats.contains(seatKey);
                    final delay = (rowIndex * seatsPerRow + seatIndex) /
                        (rows.length * seatsPerRow);

                    return Expanded(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _seatAnimController,
                          child: _SeatWidget(
                            seatId: seatId,
                            size: seatSize,
                            isTaken: isTaken,
                            isSelected: isSelected,
                            glowAnimation: _glowController,
                            onTap: isTaken
                                ? null
                                : () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedSeats.remove(seatKey);
                                      } else {
                                        selectedSeats.add(seatKey);
                                      }
                                    });
                                  },
                          ),
                          builder: (context, child) {
                            final raw = ((_seatAnimController.value - delay) /
                                    (1 - delay).clamp(0.01, 1.0))
                                .clamp(0.0, 1.0);
                            final progress = Curves.easeOutCubic.transform(raw);
                            return Opacity(
                              opacity: progress,
                              child: Transform.scale(
                                scale: 0.55 + (progress * 0.45),
                                child: child,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class _SeatWidget extends StatelessWidget {
  final String seatId;
  final double size;
  final bool isTaken;
  final bool isSelected;
  final AnimationController glowAnimation;
  final VoidCallback? onTap;

  const _SeatWidget({
    required this.seatId,
    required this.size,
    required this.isTaken,
    required this.isSelected,
    required this.glowAnimation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: glowAnimation,
        builder: (context, child) {
          final glow = isSelected ? glowAnimation.value : 0.0;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isTaken
                  ? const Color(0xFF45414B)
                  : isSelected
                      ? const Color(0xFFFFD54F)
                      : const Color(0xFFE66A24),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomLeft: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
              border: Border.all(
                color: isTaken
                    ? Colors.white24
                    : isSelected
                        ? Colors.amberAccent
                        : const Color(0xFFFFA36E),
                width: isSelected ? 1.8 : 0.8,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.45 + glow * 0.35),
                        blurRadius: 7 + glow * 5,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isTaken
                  ? Icon(Icons.lock, size: size * 0.48, color: Colors.white38)
                  : FittedBox(
                      child: Text(
                        seatId.substring(1),
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SeatStatusLegend extends StatelessWidget {
  const _SeatStatusLegend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 8,
      children: const [
        _StatusItem(color: Color(0xFFE66A24), label: 'Tersedia'),
        _StatusItem(color: Color(0xFFFFD54F), label: 'Dipilih'),
        _StatusItem(color: Color(0xFF45414B), label: 'Terisi'),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
}

class StadiumMapPainter extends CustomPainter {
  final String? selectedSection;
  final List<String> allowedSections;

  StadiumMapPainter({
    this.selectedSection,
    required this.allowedSections,
  });

  // Angles: 0 = right (east), increases clockwise — matches the reference image.
  // Utara left (green), Timur top (yellow), Selatan right (blue),
  // VIP Utara / VIP Selatan split the bottom.
  static const sectionArcs = <String, (double start, double sweep)>{
    'Tribun Selatan': (-0.65, 1.55), // right
    'VIP Selatan': (0.90, 0.48), // bottom-right
    'VIP Utara': (1.38, 0.48), // bottom-left
    'Tribun Utara': (1.86, 1.70), // left
    'Tribun Timur': (3.56, 1.95), // top
  };

  // Reference-like palette
  static const sectionPalette = <String, Color>{
    'Tribun Utara': Color(0xFF2ECC71),
    'Tribun Timur': Color(0xFFF1C40F),
    'Tribun Selatan': Color(0xFF3498DB),
    'VIP Utara': Color(0xFF9B59B6),
    'VIP Selatan': Color(0xFFE91E8C),
  };

  static const _muted = Color(0xFF4A4458);

  bool _ok(String section) => allowedSections.contains(section);

  /// Map a tap to a section using oval-normalized angle (more reliable than boxes).
  static String? sectionAt(
    Offset local,
    Size size,
    List<String> allowed,
  ) {
    final center = Offset(size.width / 2, size.height / 2);
    final nx = (local.dx - center.dx) / (size.width * 0.42);
    final ny = (local.dy - center.dy) / (size.height * 0.38);
    final r = math.sqrt(nx * nx + ny * ny);

    // Ignore pitch / dead center and outside the bowl.
    if (r < 0.42 || r > 1.08) return null;

    var angle = math.atan2(ny, nx); // -pi .. pi
    if (angle < 0) angle += 2 * math.pi;

    String? best;
    var bestOverlap = -1.0;
    for (final entry in sectionArcs.entries) {
      if (!allowed.contains(entry.key)) continue;
      final start = _norm(entry.value.$1);
      final sweep = entry.value.$2;
      final end = start + sweep;
      var a = angle;
      if (a < start) a += 2 * math.pi;
      if (a >= start && a <= end) {
        final mid = start + sweep / 2;
        final dist = (a - mid).abs();
        final score = 1.0 - dist / sweep;
        if (score > bestOverlap) {
          bestOverlap = score;
          best = entry.key;
        }
      }
    }
    return best;
  }

  static double _norm(double a) {
    var x = a % (2 * math.pi);
    if (x < 0) x += 2 * math.pi;
    return x;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Outer shell (lilac rim like the reference).
    final shell = Rect.fromCenter(
      center: center,
      width: size.width * 0.96,
      height: size.height * 0.92,
    );
    canvas.drawOval(shell, Paint()..color = const Color(0xFFB8A6D9));
    canvas.drawOval(
      shell.deflate(size.width * 0.018),
      Paint()..color = const Color(0xFFF2EEF6),
    );

    // Seating ring bounds.
    final outerSeat = Rect.fromCenter(
      center: center,
      width: size.width * 0.88,
      height: size.height * 0.82,
    );
    final innerSeat = Rect.fromCenter(
      center: center,
      width: size.width * 0.58,
      height: size.height * 0.52,
    );

    // Base under sections.
    canvas.drawOval(outerSeat, Paint()..color = const Color(0xFFC4B49A));

    // Draw muted (locked) sections first, then active ones on top.
    // Skip Tribun Barat unless that ticket is active — it shares the bottom
    // arc with VIP and would otherwise look like a flat merge.
    void paintSection(String name, {required bool active}) {
      final arc = sectionArcs[name];
      if (arc == null) return;
      final base = sectionPalette[name] ?? _muted;
      final color = active
          ? (selectedSection == name ? _lighten(base, 0.22) : base)
          : _muted.withOpacity(0.42);
      _drawFilledRingSection(
        canvas,
        outerSeat,
        innerSeat,
        arc.$1,
        arc.$2,
        color,
        selected: selectedSection == name && active,
      );
    }

    for (final name in sectionArcs.keys) {
      if (!_ok(name)) paintSection(name, active: false);
    }
    for (final name in sectionArcs.keys) {
      if (_ok(name)) paintSection(name, active: true);
    }

    // Main boundaries between the five seating areas.
    for (final entry in sectionArcs.entries) {
      _drawRadialDivider(canvas, outerSeat, innerSeat, entry.value.$1);
    }

    // Divide the three large tribunes into their actual selectable blocks.
    // These lines and labels are drawn on the stadium map itself so users can
    // see U1-U3, T1-T3 and S1-S3 before opening the seat picker.
    const blockGroups = <String, List<String>>{
      'Tribun Utara': ['U1', 'U2', 'U3'],
      'Tribun Timur': ['T1', 'T2', 'T3'],
      'Tribun Selatan': ['S1', 'S2', 'S3'],
      'VIP Utara': ['VU1', 'VU2'],
      'VIP Selatan': ['VS1', 'VS2'],
    };

    for (final entry in blockGroups.entries) {
      final arc = sectionArcs[entry.key]!;
      final labels = entry.value;
      for (var i = 1; i < labels.length; i++) {
        _drawRadialDivider(
          canvas,
          outerSeat,
          innerSeat,
          arc.$1 + arc.$2 * i / labels.length,
        );
      }
      for (var i = 0; i < labels.length; i++) {
        final angle = arc.$1 + arc.$2 * (i + 0.5) / labels.length;
        _drawBlockLabel(canvas, outerSeat, innerSeat, angle, labels[i]);
      }
    }

    // Running track (tan rings).
    final trackOuter = Rect.fromCenter(
      center: center,
      width: size.width * 0.56,
      height: size.height * 0.50,
    );
    final trackInner = Rect.fromCenter(
      center: center,
      width: size.width * 0.44,
      height: size.height * 0.38,
    );
    canvas.drawOval(trackOuter, Paint()..color = const Color(0xFFD4A574));
    canvas.drawOval(trackInner, Paint()..color = const Color(0xFFC4895A));
    canvas.drawOval(
      trackInner.deflate(size.width * 0.01),
      Paint()
        ..color = const Color(0xFFE8C9A0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Pitch.
    final field = Rect.fromCenter(
      center: center,
      width: size.width * 0.40,
      height: size.height * 0.34,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(field, const Radius.circular(4)),
      Paint()..color = const Color(0xFF1B7A3A),
    );

    final stripe = Paint()..color = const Color(0xFF25904A);
    final stripeW = field.width / 10;
    for (var i = 0; i < 10; i += 2) {
      canvas.drawRect(
        Rect.fromLTWH(field.left + i * stripeW, field.top, stripeW, field.height),
        stripe,
      );
    }

    final line = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(field, const Radius.circular(4)),
      line,
    );
    canvas.drawLine(
      Offset(center.dx, field.top),
      Offset(center.dx, field.bottom),
      line,
    );
    canvas.drawCircle(center, field.height * 0.13, line);

    final pw = field.width * 0.18;
    final ph = field.height * 0.46;
    canvas.drawRect(
      Rect.fromLTWH(field.left, center.dy - ph / 2, pw, ph),
      line,
    );
    canvas.drawRect(
      Rect.fromLTWH(field.right - pw, center.dy - ph / 2, pw, ph),
      line,
    );

    // Soft highlight on selected section edge.
    if (selectedSection != null && sectionArcs.containsKey(selectedSection)) {
      final arc = sectionArcs[selectedSection]!;
      final glow = Paint()
        ..color = Colors.white.withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.012
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(outerSeat.deflate(2), arc.$1, arc.$2, false, glow);
    }
  }

  void _drawFilledRingSection(
    Canvas canvas,
    Rect outer,
    Rect inner,
    double start,
    double sweep,
    Color color, {
    required bool selected,
  }) {
    final path = Path()
      ..moveTo(
        outer.center.dx + outer.width / 2 * math.cos(start),
        outer.center.dy + outer.height / 2 * math.sin(start),
      )
      ..arcTo(outer, start, sweep, false)
      ..lineTo(
        inner.center.dx + inner.width / 2 * math.cos(start + sweep),
        inner.center.dy + inner.height / 2 * math.sin(start + sweep),
      )
      ..arcTo(inner, start + sweep, -sweep, false)
      ..close();

    canvas.drawPath(path, Paint()..color = color);

    if (selected) {
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withOpacity(0.28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4,
      );
    }
  }

  void _drawBlockLabel(
    Canvas canvas,
    Rect outer,
    Rect inner,
    double angle,
    String label,
  ) {
    // Place the label midway through the seating ring, following its oval.
    const ringPosition = 0.72;
    final rx = inner.width / 2 +
        (outer.width - inner.width) / 2 * ringPosition;
    final ry = inner.height / 2 +
        (outer.height - inner.height) / 2 * ringPosition;
    final position = Offset(
      outer.center.dx + rx * math.cos(angle),
      outer.center.dy + ry * math.sin(angle),
    );

    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          shadows: [
            Shadow(color: Colors.black54, blurRadius: 3, offset: Offset(0, 1)),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    painter.paint(
      canvas,
      Offset(position.dx - painter.width / 2, position.dy - painter.height / 2),
    );
  }

  void _drawRadialDivider(
    Canvas canvas,
    Rect outer,
    Rect inner,
    double angle,
  ) {
    final o = Offset(
      outer.center.dx + outer.width / 2 * math.cos(angle),
      outer.center.dy + outer.height / 2 * math.sin(angle),
    );
    final i = Offset(
      inner.center.dx + inner.width / 2 * math.cos(angle),
      inner.center.dy + inner.height / 2 * math.sin(angle),
    );
    canvas.drawLine(
      i,
      o,
      Paint()
        ..color = Colors.white.withOpacity(0.55)
        ..strokeWidth = 1.6,
    );
  }

  static Color _lighten(Color c, double amount) {
    return Color.fromARGB(
      c.alpha,
      (c.red + ((255 - c.red) * amount)).round().clamp(0, 255),
      (c.green + ((255 - c.green) * amount)).round().clamp(0, 255),
      (c.blue + ((255 - c.blue) * amount)).round().clamp(0, 255),
    );
  }

  @override
  bool shouldRepaint(covariant StadiumMapPainter oldDelegate) {
    return oldDelegate.selectedSection != selectedSection ||
        oldDelegate.allowedSections.join() != allowedSections.join();
  }
}
