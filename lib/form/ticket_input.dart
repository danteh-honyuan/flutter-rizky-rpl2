import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello/routes/app_routes.dart';

import 'SeatingMapPage.dart';

class TicketInputPage extends StatefulWidget {
  const TicketInputPage({super.key});

  @override
  State<TicketInputPage> createState() => _TicketInputPageState();
}

class _TicketInputPageState extends State<TicketInputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String selectedTribune = 'Tribun Utara';
  String? selectedBlock;
  List<String> seatLabels = [];
  String? ticketName;
  String? gate;
  int? ticketPrice;
  Map<String, dynamic>? match;
  bool fromSeatingMap = false;
  bool _argsRead = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsRead) return;
    _argsRead = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Map) return;

    final map = Map<String, dynamic>.from(args);
    final section = map['section'] as String?;
    if (section != null && section.isNotEmpty) {
      selectedTribune = section;
    }
    selectedBlock = map['block'] as String?;
    ticketName = map['ticketName'] as String?;
    gate = map['gate'] as String?;
    ticketPrice = map['price'] is int ? map['price'] as int : null;

    final seats = map['seatLabels'] ?? map['seats'];
    if (seats is List) {
      seatLabels = seats.map((e) => e.toString()).toList();
    }

    final rawMatch = map['match'];
    if (rawMatch is Map) {
      match = Map<String, dynamic>.from(rawMatch);
    }

    fromSeatingMap =
        section != null || seatLabels.isNotEmpty || ticketName != null;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
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

  int get _seatCount => seatLabels.isEmpty ? 1 : seatLabels.length;

  int get _unitPrice {
    if (ticketPrice != null && ticketPrice! > 0) return ticketPrice!;
    if (selectedTribune.contains('VIP') || selectedTribune.contains('VVIP')) {
      return 150000;
    }
    return 75000;
  }

  int get _subtotal => _unitPrice * _seatCount;
  int get _adminFee => 5000;
  int get _total => _subtotal + _adminFee;

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: const Color(0xFFFFC84A)),
      filled: true,
      fillColor: const Color(0xFF162033),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFFC84A), width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matchTitle = match == null
        ? 'Banten Stadium'
        : '${match!['home']} vs ${match!['away']}';
    final matchMeta = match == null
        ? null
        : '${match!['date']}  ·  ${match!['kickoff']}';

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
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
                  child: Row(
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
                          'FORM TIKET',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        _OrderPreviewCard(
                          matchTitle: matchTitle,
                          matchMeta: matchMeta,
                          ticketName: ticketName,
                          gate: gate,
                          tribune: selectedTribune,
                          block: selectedBlock,
                          seats: seatLabels,
                          unitPrice: _unitPrice,
                          seatCount: _seatCount,
                          subtotal: _subtotal,
                          adminFee: _adminFee,
                          total: _total,
                          formatRupiah: _formatRupiah,
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Data pemesan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          fromSeatingMap
                              ? 'Kursi sudah dipilih di peta. Isi nama & nomor untuk mencetak tiket.'
                              : 'Isi data diri untuk konfirmasi tiket.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          textCapitalization: TextCapitalization.words,
                          decoration: _fieldDecoration(
                            label: 'Nama Lengkap',
                            icon: Icons.person_outline,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Nama wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: phoneController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.phone,
                          decoration: _fieldDecoration(
                            label: 'Nomor Telepon / WhatsApp',
                            icon: Icons.phone_outlined,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Nomor wajib diisi';
                            }
                            return null;
                          },
                        ),
                        if (!fromSeatingMap) ...[
                          const SizedBox(height: 18),
                          const Text(
                            'TRIBUN',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedTribune,
                            dropdownColor: const Color(0xFF1E2740),
                            style: const TextStyle(color: Colors.white),
                            decoration: _fieldDecoration(
                              label: 'Kategori tribun',
                              icon: Icons.stadium_outlined,
                            ),
                            items: const [
                              'Tribun Utara',
                              'Tribun Selatan',
                              'Tribun Timur',
                              'Tribun Barat',
                              'VIP Utara',
                              'VIP Selatan',
                            ]
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => selectedTribune = v);
                            },
                          ),
                        ],
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC84A),
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;

                              // Mark seats as claimed when the user confirms
                              // the ticket form and proceeds to the ticket output.
                              if (fromSeatingMap &&
                                  seatLabels.isNotEmpty &&
                                  selectedBlock != null) {
                                SeatReservationStore.reserve(
                                  match: match,
                                  section: selectedTribune,
                                  block: selectedBlock!,
                                  seatLabels: seatLabels,
                                );
                              }

                              Navigator.pushNamed(
                                context,
                                AppRoutes.ticketOutput,
                                arguments: {
                                  'name': nameController.text.trim(),
                                  'phone': phoneController.text.trim(),
                                  'tribune': selectedTribune,
                                  'block': selectedBlock,
                                  'seats': seatLabels,
                                  'ticketName': ticketName,
                                  'gate': gate,
                                  'price': _unitPrice,
                                  'match': match,
                                  'payment': 'QRIS',
                                  'seatCount': _seatCount,
                                  'subtotal': _subtotal,
                                  'adminFee': _adminFee,
                                  'total': _total,
                                },
                              );
                            },
                            child: Text(
                              'Cetak Tiket · ${_formatRupiah(_total)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderPreviewCard extends StatelessWidget {
  const _OrderPreviewCard({
    required this.matchTitle,
    required this.matchMeta,
    required this.ticketName,
    required this.gate,
    required this.tribune,
    required this.block,
    required this.seats,
    required this.unitPrice,
    required this.seatCount,
    required this.subtotal,
    required this.adminFee,
    required this.total,
    required this.formatRupiah,
  });

  final String matchTitle;
  final String? matchMeta;
  final String? ticketName;
  final String? gate;
  final String tribune;
  final String? block;
  final List<String> seats;
  final int unitPrice;
  final int seatCount;
  final int subtotal;
  final int adminFee;
  final int total;
  final String Function(int) formatRupiah;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF17233A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x66FFC84A)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFC84A).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  color: Color(0xFFFFC84A),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'PREVIEW PESANAN',
                    style: TextStyle(
                      color: Color(0xFFFFC84A),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x33FFC84A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$seatCount kursi',
                    style: const TextStyle(
                      color: Color(0xFFFFC84A),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matchTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                if (matchMeta != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    matchMeta!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                _previewRow(
                  Icons.local_activity_outlined,
                  'Paket',
                  ticketName ?? tribune,
                ),
                if (gate != null)
                  _previewRow(Icons.door_front_door_outlined, 'Gate', gate!),
                _previewRow(
                  Icons.stadium_outlined,
                  'Tribun',
                  block == null ? tribune : '$tribune · Blok $block',
                ),
                if (seats.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    'KURSI DIPILIH',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final seat in seats)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F1628),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFFFC84A).withOpacity(0.55),
                            ),
                          ),
                          child: Text(
                            seat,
                            style: const TextStyle(
                              color: Color(0xFFFFC84A),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada kursi dari peta — lanjut tetap bisa, 1 tiket.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Container(height: 1, color: Colors.white12),
                const SizedBox(height: 12),
                _moneyRow(
                  '$seatCount × ${formatRupiah(unitPrice)}',
                  formatRupiah(subtotal),
                ),
                const SizedBox(height: 4),
                _moneyRow('Biaya admin', formatRupiah(adminFee), muted: true),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Total bayar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatRupiah(total),
                      style: const TextStyle(
                        color: Color(0xFFFFC84A),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white38),
          const SizedBox(width: 8),
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneyRow(String label, String value, {bool muted = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: muted ? Colors.white54 : Colors.white70,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: muted ? Colors.white54 : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
