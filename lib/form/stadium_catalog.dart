/// Match catalog as plain maps. There is no model class.
/// Each match carries its own `detailItems` list (several ticket options).
const List<Map<String, dynamic>> kStadiumItems = [
  <String, dynamic>{
    'id': 'dew-psm',
    'competition': 'Liga 1',
    'badge': 'NEXT',
    'home': 'Dewa United',
    'homeShort': 'DEW',
    'homeColor': 0xFF1565C0,
    'away': 'PSM Makassar',
    'awayShort': 'PSM',
    'awayColor': 0xFFC62828,
    'date': 'Sab, 22 Nov 2026',
    'kickoff': '19:00 WIB',
    'venue': 'Banten Stadium',
    'blurb':
        'Laga kandang Dewa United. Tribune timur biasanya paling ramai — datang lebih awal kalau mau dekat choreo.',
    'detailItems': <Map<String, dynamic>>[
      <String, dynamic>{
        'name': 'VIP Lounge',
        'gate': 'Gate A',
        'price': 450000,
        'left': 48,
        'note': 'Kursi empuk, akses lounge, 1 minuman.',
      },
      <String, dynamic>{
        'name': 'Tribune Barat',
        'gate': 'Gate B',
        'price': 175000,
        'left': 640,
        'note': 'Tribun beratap, dekat sisi tamu.',
      },
      <String, dynamic>{
        'name': 'Tribune Timur',
        'gate': 'Gate C',
        'price': 150000,
        'left': 980,
        'note': 'Tribun beratap, sisi suporter tuan rumah.',
      },
      <String, dynamic>{
        'name': 'Tribune Utara',
        'gate': 'Gate D',
        'price': 75000,
        'left': 2200,
        'note': 'Tribune terbuka, harga paling hemat.',
      },
    ],
  },
  <String, dynamic>{
    'id': 'psb-psj',
    'competition': 'Liga 1',
    'badge': 'BIG MATCH',
    'home': 'Persib Bandung',
    'homeShort': 'PSB',
    'homeColor': 0xFF0D47A1,
    'away': 'Persija Jakarta',
    'awayShort': 'PSJ',
    'awayColor': 0xFFB71C1C,
    'date': 'Sab, 29 Nov 2026',
    'kickoff': '15:30 WIB',
    'venue': 'Banten Stadium',
    'blurb':
        'Duel klasiker dipindah ke Banten. Beberapa kategori cepat habis — cek sisa kursi di tiap item.',
    'detailItems': <Map<String, dynamic>>[
      <String, dynamic>{
        'name': 'VVIP Pitchside',
        'gate': 'Gate A1',
        'price': 850000,
        'left': 24,
        'note': 'Baris depan, welcome drink, parkir prioritas.',
      },
      <String, dynamic>{
        'name': 'VIP Lounge',
        'gate': 'Gate A',
        'price': 500000,
        'left': 70,
        'note': 'Lounge ber-AC dan kursi bernomor.',
      },
      <String, dynamic>{
        'name': 'Tribune Barat',
        'gate': 'Gate B',
        'price': 200000,
        'left': 410,
        'note': 'Beratap, pandangan lurus ke tengah lapangan.',
      },
      <String, dynamic>{
        'name': 'Tribune Timur',
        'gate': 'Gate C',
        'price': 200000,
        'left': 390,
        'note': 'Beratap, suasana paling nyaring.',
      },
      <String, dynamic>{
        'name': 'Tribune Selatan',
        'gate': 'Gate E',
        'price': 120000,
        'left': 860,
        'note': 'Campuran, cocok kalau datang berombongan.',
      },
      <String, dynamic>{
        'name': 'Tribune Utara',
        'gate': 'Gate D',
        'price': 90000,
        'left': 1500,
        'note': 'Terbuka. Bawa jas hujan kalau langit mendung.',
      },
    ],
  },
  <String, dynamic>{
    'id': 'dew-bli',
    'competition': 'Liga 1',
    'badge': 'HOME',
    'home': 'Dewa United',
    'homeShort': 'DEW',
    'homeColor': 0xFF1565C0,
    'away': 'Bali United',
    'awayShort': 'BLI',
    'awayColor': 0xFFE65100,
    'date': 'Rab, 3 Des 2026',
    'kickoff': '19:00 WIB',
    'venue': 'Banten Stadium',
    'blurb': 'Kick-off malam. Gate dibuka 2 jam sebelum laga.',
    'detailItems': <Map<String, dynamic>>[
      <String, dynamic>{
        'name': 'VIP Lounge',
        'gate': 'Gate A',
        'price': 400000,
        'left': 110,
        'note': 'Lounge + kursi bernomor.',
      },
      <String, dynamic>{
        'name': 'Tribune Barat',
        'gate': 'Gate B',
        'price': 160000,
        'left': 700,
        'note': 'Beratap, sisi barat.',
      },
      <String, dynamic>{
        'name': 'Tribune Utara',
        'gate': 'Gate D',
        'price': 70000,
        'left': 2600,
        'note': 'Terbuka, paling banyak ketersediaan.',
      },
    ],
  },
  <String, dynamic>{
    'id': 'btn-arm',
    'competition': 'Friendly',
    'badge': 'FRIENDLY',
    'home': 'Seleksi Banten',
    'homeShort': 'BTN',
    'homeColor': 0xFF2E7D32,
    'away': 'Arema FC',
    'awayShort': 'ARM',
    'awayColor': 0xFF1A237E,
    'date': 'Min, 7 Des 2026',
    'kickoff': '16:00 WIB',
    'venue': 'Banten Stadium',
    'blurb': 'Ujicoba sore. Harga lebih ringan dari liga, dua item saja.',
    'detailItems': <Map<String, dynamic>>[
      <String, dynamic>{
        'name': 'Tribun Utama',
        'gate': 'Gate B',
        'price': 100000,
        'left': 900,
        'note': 'Kursi bernomor di tribun beratap.',
      },
      <String, dynamic>{
        'name': 'Tribun Ekonomi',
        'gate': 'Gate D',
        'price': 40000,
        'left': 3000,
        'note': 'Berdiri / terbuka, masuk gratis untuk anak di bawah 5 tahun di loket.',
      },
    ],
  },
  <String, dynamic>{
    'id': 'psj-brn',
    'competition': 'Piala',
    'badge': 'MALAM PIALA',
    'home': 'Persija Jakarta',
    'homeShort': 'PSJ',
    'homeColor': 0xFFB71C1C,
    'away': 'Borneo FC',
    'awayShort': 'BRN',
    'awayColor': 0xFF1B5E20,
    'date': 'Sab, 13 Des 2026',
    'kickoff': '20:30 WIB',
    'venue': 'Banten Stadium',
    'blurb': 'Perempat final. Kategori 1 dan VVIP terbatas.',
    'detailItems': <Map<String, dynamic>>[
      <String, dynamic>{
        'name': 'VVIP Pitchside',
        'gate': 'Gate A1',
        'price': 750000,
        'left': 36,
        'note': 'Hampir habis. Termasuk snack dan parkir.',
      },
      <String, dynamic>{
        'name': 'VIP Lounge',
        'gate': 'Gate A',
        'price': 425000,
        'left': 88,
        'note': 'Lounge ber-AC.',
      },
      <String, dynamic>{
        'name': 'Kategori 1',
        'gate': 'Gate B',
        'price': 180000,
        'left': 520,
        'note': 'Tribun beratap, tengah lapangan.',
      },
      <String, dynamic>{
        'name': 'Kategori 2',
        'gate': 'Gate D',
        'price': 80000,
        'left': 1800,
        'note': 'Tribune terbuka di belakang gawang.',
      },
    ],
  },
];

List<Map<String, dynamic>> detailItemsOf(Map<String, dynamic> item) {
  final raw = item['detailItems'];
  if (raw is! List) return const [];
  return [
    for (final entry in raw)
      if (entry is Map) Map<String, dynamic>.from(entry),
  ];
}

int lowestPrice(Map<String, dynamic> item) {
  final details = detailItemsOf(item);
  if (details.isEmpty) return 0;
  var low = details.first['price'] as int;
  for (final detail in details.skip(1)) {
    final price = detail['price'] as int;
    if (price < low) low = price;
  }
  return low;
}

String formatRupiah(int value) {
  final digits = value.toString();
  final out = StringBuffer('Rp ');
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    if (i > 0 && fromEnd % 3 == 0) out.write('.');
    out.write(digits[i]);
  }
  return out.toString();
}
