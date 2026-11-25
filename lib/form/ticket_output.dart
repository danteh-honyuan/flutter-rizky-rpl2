import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'StadiumHomePage.dart';

class TicketOutputPage extends StatelessWidget {
  const TicketOutputPage({super.key});

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
    final raw = ModalRoute.of(context)?.settings.arguments;
    final data = raw is Map
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    final name = (data['name'] as String?)?.trim().isNotEmpty == true
        ? data['name'] as String
        : 'Tamu';
    final phone = (data['phone'] as String?)?.trim().isNotEmpty == true
        ? data['phone'] as String
        : '-';
    final tribune = (data['tribune'] as String?) ?? 'Tribun Utara';
    final block = data['block'] as String?;
    final ticketName = data['ticketName'] as String?;
    final gate = data['gate'] as String?;
    final paymentMethod = (data['payment'] as String?) ?? 'QRIS';
    final seats = data['seats'] is List
        ? (data['seats'] as List).map((e) => e.toString()).toList()
        : <String>[];
    final match = data['match'] is Map
        ? Map<String, dynamic>.from(data['match'] as Map)
        : null;

    final seatCount = seats.isEmpty ? 1 : seats.length;
    int unitPrice = data['price'] is int ? data['price'] as int : 0;
    if (unitPrice <= 0) {
      unitPrice = tribune.contains('VIP') || tribune.contains('VVIP')
          ? 150000
          : 75000;
    }
    const adminFee = 5000;
    final subtotal = unitPrice * seatCount;
    final total = subtotal + adminFee;

    final matchTitle = match == null
        ? 'Banten Stadium'
        : '${match['home']} vs ${match['away']}';
    final matchMeta = match == null
        ? null
        : '${match['date']}  ·  ${match['kickoff']}';

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
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<void>(
                              builder: (_) => const StadiumHomePage(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'STRUK TIKET',
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF17233A),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(0xFFFFC84A),
                              width: 1.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFC84A).withOpacity(0.12),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.sports_soccer,
                                    color: Color(0xFFFFC84A),
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'ARENA PASS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.4,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'E-TICKET',
                                    style: TextStyle(
                                      color: Color(0xFFFFC84A),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                matchTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              if (matchMeta != null)
                                Text(
                                  matchMeta,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 14),
                              Container(
                                height: 1,
                                color: Colors.white12,
                              ),
                              const SizedBox(height: 14),
                              _row('Nama', name),
                              _row('Telepon', phone),
                              _row('Bayar', paymentMethod, accent: true),
                              if (ticketName != null)
                                _row('Paket', ticketName!),
                              if (gate != null) _row('Gate', gate!),
                              _row(
                                'Tribun',
                                block == null ? tribune : '$tribune · Blok $block',
                              ),
                              if (seats.isNotEmpty)
                                _row('Kursi', seats.join(', ')),
                              const SizedBox(height: 8),
                              Container(height: 1, color: Colors.white12),
                              const SizedBox(height: 12),
                              const Text(
                                'RINCIAN',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _priceLine(
                                '${seatCount}x ${ticketName ?? tribune}',
                                _formatRupiah(subtotal),
                              ),
                              const SizedBox(height: 6),
                              _priceLine(
                                'Biaya admin',
                                _formatRupiah(adminFee),
                                muted: true,
                              ),
                              const SizedBox(height: 12),
                              Container(height: 1, color: Colors.white12),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text(
                                    'TOTAL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _formatRupiah(total),
                                    style: const TextStyle(
                                      color: Color(0xFFFFC84A),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F1628),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '|||| |||| | |||||| |||| |||',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.85),
                                        fontSize: 18,
                                        letterSpacing: 2.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tunjukkan struk ini di gate masuk',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFFFC84A),
                                    side: const BorderSide(
                                      color: Color(0xFFFFC84A),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const StadiumHomePage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    'Kembali ke Beranda',
                                    style: TextStyle(fontWeight: FontWeight.w800),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool accent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
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
              style: TextStyle(
                color: accent ? const Color(0xFF6FCF97) : Colors.white,
                fontWeight: accent ? FontWeight.w700 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceLine(String label, String value, {bool muted = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: muted ? Colors.white54 : Colors.white70,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: muted ? Colors.white54 : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
