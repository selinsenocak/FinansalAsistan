import '../models/category.dart';
import '../models/demo_user.dart';
import '../models/expense_entry.dart';
import '../models/goal.dart';
import '../models/income_entry.dart';

/// Seed data for the three demo accounts offered on the auth screen.
/// Each profile spans three calendar months (Temmuz–Eylül 2026) so the
/// Reports/Grafikler trend has real history to show, and each is shaped
/// after its stated persona (see uploads/intent-2.md — düzenli maaşlı,
/// freelance/değişken gelirli, dar bütçeli).
int _seq = 0;
String _id(String prefix) => '$prefix-${_seq++}';

DateTime _d(int y, int m, int d) => DateTime(y, m, d);

// ─────────────────────────────────────────────────────────────
// Ayşe Kaya — düzenli maaşlı kullanıcı
// ─────────────────────────────────────────────────────────────
List<IncomeEntry> _ayseIncomes() => [
      IncomeEntry(id: _id('inc'), desc: 'Maaş — ABC Yazılım A.Ş.', amount: 42000, date: _d(2026, 9, 1)),
      IncomeEntry(id: _id('inc'), desc: 'Maaş — ABC Yazılım A.Ş.', amount: 42000, date: _d(2026, 8, 1)),
      IncomeEntry(id: _id('inc'), desc: 'Maaş — ABC Yazılım A.Ş.', amount: 41000, date: _d(2026, 7, 1)),
    ];

List<ExpenseEntry> _ayseExpenses() => [
      // Temmuz
      ExpenseEntry(id: _id('exp'), desc: 'Kira Ödemesi', category: CategoryKey.kira, amount: 11500, date: _d(2026, 7, 1)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 2100, date: _d(2026, 7, 3)),
      ExpenseEntry(id: _id('exp'), desc: 'Elektrik Faturası', category: CategoryKey.faturalar, amount: 420, date: _d(2026, 7, 5)),
      ExpenseEntry(id: _id('exp'), desc: 'Metro Kart Dolum', category: CategoryKey.ulasim, amount: 300, date: _d(2026, 7, 7)),
      ExpenseEntry(id: _id('exp'), desc: 'Sinema Bileti', category: CategoryKey.eglence, amount: 250, date: _d(2026, 7, 10)),
      ExpenseEntry(id: _id('exp'), desc: 'Eczane', category: CategoryKey.diger, amount: 140, date: _d(2026, 7, 12)),
      ExpenseEntry(id: _id('exp'), desc: 'Su Faturası', category: CategoryKey.faturalar, amount: 165, date: _d(2026, 7, 18)),
      ExpenseEntry(id: _id('exp'), desc: 'Restoran', category: CategoryKey.yiyecek, amount: 480, date: _d(2026, 7, 22)),
      // Ağustos
      ExpenseEntry(id: _id('exp'), desc: 'Kira Ödemesi', category: CategoryKey.kira, amount: 11800, date: _d(2026, 8, 1)),
      ExpenseEntry(id: _id('exp'), desc: 'Elektrik Faturası', category: CategoryKey.faturalar, amount: 455, date: _d(2026, 8, 2)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 1980, date: _d(2026, 8, 4)),
      ExpenseEntry(id: _id('exp'), desc: 'Metro Kart Dolum', category: CategoryKey.ulasim, amount: 320, date: _d(2026, 8, 6)),
      ExpenseEntry(id: _id('exp'), desc: 'Netflix + Spotify', category: CategoryKey.eglence, amount: 280, date: _d(2026, 8, 9)),
      ExpenseEntry(id: _id('exp'), desc: 'Su Faturası', category: CategoryKey.faturalar, amount: 175, date: _d(2026, 8, 14)),
      ExpenseEntry(id: _id('exp'), desc: 'Kitap', category: CategoryKey.diger, amount: 190, date: _d(2026, 8, 19)),
      ExpenseEntry(id: _id('exp'), desc: 'Restoran', category: CategoryKey.yiyecek, amount: 540, date: _d(2026, 8, 24)),
      // Eylül
      ExpenseEntry(id: _id('exp'), desc: 'Kira Ödemesi', category: CategoryKey.kira, amount: 12000, date: _d(2026, 9, 1)),
      ExpenseEntry(id: _id('exp'), desc: 'Elektrik Faturası', category: CategoryKey.faturalar, amount: 640, date: _d(2026, 9, 2)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 1240, date: _d(2026, 9, 3)),
      ExpenseEntry(id: _id('exp'), desc: 'Metro Kart Dolum', category: CategoryKey.ulasim, amount: 350, date: _d(2026, 9, 4)),
      ExpenseEntry(id: _id('exp'), desc: 'Netflix + Spotify', category: CategoryKey.eglence, amount: 280, date: _d(2026, 9, 4)),
      ExpenseEntry(id: _id('exp'), desc: 'Su Faturası', category: CategoryKey.faturalar, amount: 190, date: _d(2026, 9, 5)),
      ExpenseEntry(id: _id('exp'), desc: 'Eczane', category: CategoryKey.diger, amount: 150, date: _d(2026, 9, 5)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 860, date: _d(2026, 9, 6)),
      ExpenseEntry(id: _id('exp'), desc: 'Sinema Bileti', category: CategoryKey.eglence, amount: 320, date: _d(2026, 9, 7)),
      ExpenseEntry(id: _id('exp'), desc: 'Otobüs Kart', category: CategoryKey.ulasim, amount: 140, date: _d(2026, 9, 8)),
      ExpenseEntry(id: _id('exp'), desc: 'Kitap', category: CategoryKey.diger, amount: 220, date: _d(2026, 9, 8)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 1450, date: _d(2026, 9, 9)),
      ExpenseEntry(id: _id('exp'), desc: 'Restoran', category: CategoryKey.yiyecek, amount: 620, date: _d(2026, 9, 10)),
    ];

List<Goal> _ayseGoals() => [
      Goal(id: _id('goal'), name: 'Acil Durum Fonu', target: 30000, current: 22000),
      Goal(id: _id('goal'), name: 'Tatil Fonu', target: 20000, current: 8500),
      Goal(id: _id('goal'), name: 'Yeni Laptop', target: 15000, current: 15000),
    ];

// ─────────────────────────────────────────────────────────────
// Mert Demir — freelance / değişken gelirli kullanıcı
// ─────────────────────────────────────────────────────────────
List<IncomeEntry> _mertIncomes() => [
      IncomeEntry(id: _id('inc'), desc: 'Freelance Tasarım — Studio X', amount: 4800, date: _d(2026, 9, 15)),
      IncomeEntry(id: _id('inc'), desc: 'Proje Ödemesi — Acme Studio', amount: 26000, date: _d(2026, 9, 2)),
      IncomeEntry(id: _id('inc'), desc: 'Proje Ödemesi — Acme Studio', amount: 5200, date: _d(2026, 8, 28)),
      IncomeEntry(id: _id('inc'), desc: 'Danışmanlık Ücreti — Kobi A.Ş.', amount: 14500, date: _d(2026, 8, 17)),
      IncomeEntry(id: _id('inc'), desc: 'Proje Ödemesi — Beta Teknoloji', amount: 9800, date: _d(2026, 8, 3)),
      IncomeEntry(id: _id('inc'), desc: 'Proje Ödemesi — Nova Yazılım', amount: 6500, date: _d(2026, 7, 20)),
      IncomeEntry(id: _id('inc'), desc: 'Proje Ödemesi — Acme Studio', amount: 22000, date: _d(2026, 7, 5)),
    ];

List<ExpenseEntry> _mertExpenses() => [
      // Temmuz
      ExpenseEntry(id: _id('exp'), desc: 'Kira Ödemesi', category: CategoryKey.kira, amount: 9500, date: _d(2026, 7, 1)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 1450, date: _d(2026, 7, 4)),
      ExpenseEntry(id: _id('exp'), desc: 'Elektrik Faturası', category: CategoryKey.faturalar, amount: 380, date: _d(2026, 7, 6)),
      ExpenseEntry(id: _id('exp'), desc: 'Ulaşım (Taksi)', category: CategoryKey.ulasim, amount: 620, date: _d(2026, 7, 9)),
      ExpenseEntry(id: _id('exp'), desc: 'Co-working Aidatı', category: CategoryKey.diger, amount: 1800, date: _d(2026, 7, 15)),
      ExpenseEntry(id: _id('exp'), desc: 'Restoran', category: CategoryKey.yiyecek, amount: 950, date: _d(2026, 7, 21)),
      // Ağustos
      ExpenseEntry(id: _id('exp'), desc: 'Kira Ödemesi', category: CategoryKey.kira, amount: 9500, date: _d(2026, 8, 1)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 1600, date: _d(2026, 8, 5)),
      ExpenseEntry(id: _id('exp'), desc: 'Elektrik Faturası', category: CategoryKey.faturalar, amount: 410, date: _d(2026, 8, 8)),
      ExpenseEntry(id: _id('exp'), desc: 'Ulaşım (Taksi)', category: CategoryKey.ulasim, amount: 540, date: _d(2026, 8, 12)),
      ExpenseEntry(id: _id('exp'), desc: 'Co-working Aidatı', category: CategoryKey.diger, amount: 1800, date: _d(2026, 8, 16)),
      ExpenseEntry(id: _id('exp'), desc: 'Sinema + Yemek', category: CategoryKey.eglence, amount: 620, date: _d(2026, 8, 26)),
      // Eylül
      ExpenseEntry(id: _id('exp'), desc: 'Kira Ödemesi', category: CategoryKey.kira, amount: 9500, date: _d(2026, 9, 1)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 1380, date: _d(2026, 9, 3)),
      ExpenseEntry(id: _id('exp'), desc: 'Elektrik Faturası', category: CategoryKey.faturalar, amount: 395, date: _d(2026, 9, 5)),
      ExpenseEntry(id: _id('exp'), desc: 'Ulaşım (Taksi)', category: CategoryKey.ulasim, amount: 580, date: _d(2026, 9, 10)),
      ExpenseEntry(id: _id('exp'), desc: 'Co-working Aidatı', category: CategoryKey.diger, amount: 1800, date: _d(2026, 9, 14)),
      ExpenseEntry(id: _id('exp'), desc: 'Netflix + Spotify', category: CategoryKey.eglence, amount: 280, date: _d(2026, 9, 18)),
      ExpenseEntry(id: _id('exp'), desc: 'Restoran', category: CategoryKey.yiyecek, amount: 720, date: _d(2026, 9, 20)),
    ];

List<Goal> _mertGoals() => [
      Goal(id: _id('goal'), name: 'Ekipman Yenileme', target: 25000, current: 9000),
      Goal(id: _id('goal'), name: 'Vergi Rezervi', target: 15000, current: 11000),
      Goal(id: _id('goal'), name: 'Tatil Fonu', target: 10000, current: 2500),
    ];

// ─────────────────────────────────────────────────────────────
// Elif Şahin — dar bütçeli kullanıcı
// ─────────────────────────────────────────────────────────────
List<IncomeEntry> _elifIncomes() => [
      IncomeEntry(id: _id('inc'), desc: 'Maaş — Perakende Mağaza', amount: 20000, date: _d(2026, 9, 1)),
      IncomeEntry(id: _id('inc'), desc: 'Maaş — Perakende Mağaza', amount: 19500, date: _d(2026, 8, 1)),
      IncomeEntry(id: _id('inc'), desc: 'Maaş — Perakende Mağaza', amount: 19500, date: _d(2026, 7, 1)),
    ];

List<ExpenseEntry> _elifExpenses() => [
      // Temmuz
      ExpenseEntry(id: _id('exp'), desc: 'Kira Ödemesi', category: CategoryKey.kira, amount: 8500, date: _d(2026, 7, 1)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 3200, date: _d(2026, 7, 3)),
      ExpenseEntry(id: _id('exp'), desc: 'Elektrik Faturası', category: CategoryKey.faturalar, amount: 480, date: _d(2026, 7, 5)),
      ExpenseEntry(id: _id('exp'), desc: 'Su Faturası', category: CategoryKey.faturalar, amount: 210, date: _d(2026, 7, 6)),
      ExpenseEntry(id: _id('exp'), desc: 'Otobüs Kart', category: CategoryKey.ulasim, amount: 380, date: _d(2026, 7, 8)),
      ExpenseEntry(id: _id('exp'), desc: 'Eczane', category: CategoryKey.diger, amount: 320, date: _d(2026, 7, 15)),
      ExpenseEntry(id: _id('exp'), desc: 'Doğalgaz Faturası', category: CategoryKey.faturalar, amount: 540, date: _d(2026, 7, 22)),
      // Ağustos
      ExpenseEntry(id: _id('exp'), desc: 'Kira Ödemesi', category: CategoryKey.kira, amount: 8500, date: _d(2026, 8, 1)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 3450, date: _d(2026, 8, 4)),
      ExpenseEntry(id: _id('exp'), desc: 'Elektrik Faturası', category: CategoryKey.faturalar, amount: 510, date: _d(2026, 8, 6)),
      ExpenseEntry(id: _id('exp'), desc: 'Su Faturası', category: CategoryKey.faturalar, amount: 195, date: _d(2026, 8, 7)),
      ExpenseEntry(id: _id('exp'), desc: 'Otobüs Kart', category: CategoryKey.ulasim, amount: 400, date: _d(2026, 8, 11)),
      ExpenseEntry(id: _id('exp'), desc: 'Eczane', category: CategoryKey.diger, amount: 280, date: _d(2026, 8, 19)),
      // Eylül
      ExpenseEntry(id: _id('exp'), desc: 'Kira Ödemesi', category: CategoryKey.kira, amount: 8500, date: _d(2026, 9, 1)),
      ExpenseEntry(id: _id('exp'), desc: 'Elektrik Faturası', category: CategoryKey.faturalar, amount: 520, date: _d(2026, 9, 2)),
      ExpenseEntry(id: _id('exp'), desc: 'Su Faturası', category: CategoryKey.faturalar, amount: 205, date: _d(2026, 9, 3)),
      ExpenseEntry(id: _id('exp'), desc: 'Migros Market', category: CategoryKey.yiyecek, amount: 3600, date: _d(2026, 9, 4)),
      ExpenseEntry(id: _id('exp'), desc: 'Otobüs Kart', category: CategoryKey.ulasim, amount: 420, date: _d(2026, 9, 6)),
      ExpenseEntry(id: _id('exp'), desc: 'Doğalgaz Faturası', category: CategoryKey.faturalar, amount: 560, date: _d(2026, 9, 9)),
      ExpenseEntry(id: _id('exp'), desc: 'Eczane', category: CategoryKey.diger, amount: 340, date: _d(2026, 9, 12)),
      ExpenseEntry(id: _id('exp'), desc: 'Sinema Bileti', category: CategoryKey.eglence, amount: 180, date: _d(2026, 9, 16)),
    ];

List<Goal> _elifGoals() => [
      Goal(id: _id('goal'), name: 'Acil Durum Fonu', target: 10000, current: 1200),
      Goal(id: _id('goal'), name: 'Yeni Telefon', target: 8000, current: 1500),
    ];

final List<DemoUser> kDemoUsers = [
  const DemoUser(
    id: 'ayse',
    name: 'Ayşe Kaya',
    role: 'Düzenli maaşlı kullanıcı',
    seedIncomes: _ayseIncomes,
    seedExpenses: _ayseExpenses,
    seedGoals: _ayseGoals,
  ),
  const DemoUser(
    id: 'mert',
    name: 'Mert Demir',
    role: 'Freelance / değişken gelirli',
    seedIncomes: _mertIncomes,
    seedExpenses: _mertExpenses,
    seedGoals: _mertGoals,
  ),
  const DemoUser(
    id: 'elif',
    name: 'Elif Şahin',
    role: 'Dar bütçeli kullanıcı',
    seedIncomes: _elifIncomes,
    seedExpenses: _elifExpenses,
    seedGoals: _elifGoals,
  ),
];
