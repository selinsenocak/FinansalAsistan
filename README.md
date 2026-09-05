# Finansal Asistan

Gelir ve giderlerin kategori bazlı takip edildiği, harcama dağılımının
görselleştirildiği ve güncel piyasa verilerinin (döviz, altın, BIST) tek
ekranda gösterildiği bir kişisel finans uygulaması. Flutter ile
geliştirilmiştir; tek kod tabanından hem **Web** hem **iOS** hedefler,
telefon genişliğinde alt gezinme çubuğu, geniş ekranlarda kenar
çubuklu bir web düzeni kullanır (bkz. `lib/widgets/adaptive_shell.dart`).

Bu sürüm bir prototip / çalışır temel sistemdir — production değildir
(bkz. `uploads/intent-2.md` kapsam dışı maddeleri: gerçek banka
entegrasyonu, production seviye kimlik doğrulama, push bildirimleri yok).

Bu proje, `Finansal Asistan.dc.html` altında Claude Design'da hazırlanan
etkileşimli prototipten (Modernist tasarım sistemi tokenlarıyla)
yola çıkılarak gerçek bir Flutter uygulamasına dönüştürülmüştür.

## Kurulum

```bash
flutter pub get
```

Flutter SDK kurulu değilse: https://docs.flutter.dev/get-started/install

## Çalıştırma

```bash
flutter devices          # bağlı cihaz/simülatörleri listeler
flutter run -d chrome    # Web (localhost)
flutter run              # bağlı bir iOS simülatörü/cihazı seçerek
```

iOS için Xcode ve bir Mac ortamı gerekir; `flutter run` ilk seferde
gerekli derlemeyi kendisi yapar.

## Test

```bash
flutter analyze   # statik analiz
flutter test      # widget testleri — auth akışı + her ekranın her demo
                   # kullanıcı ve her iki genişlik kırılımında (telefon /
                   # geniş ekran) hatasız render edildiğini doğrular
```

## Demo hesaplar

Giriş ekranındaki üç demo hesap, `uploads/intent-2.md`'de tanımlanan
profilleri yansıtır (bkz. `lib/data/demo_data.dart`):

| Hesap | Profil |
|---|---|
| Ayşe Kaya | Düzenli maaşlı kullanıcı — sabit aylık maaş, düzenli gider |
| Mert Demir | Freelance / değişken gelirli — aydan aya değişen proje ödemeleri |
| Elif Şahin | Dar bütçeli kullanıcı — düşük gelir, yüksek gider/gelir oranı |

Her hesabın Temmuz–Eylül 2026 arası gerçekçi bir gelir/gider geçmişi
önceden yüklüdür; "Kayıt Ol" ile oluşturulan yeni bir hesap ise boş bir
defterle başlar.

## Mimari notları

- **Durum yönetimi**: Tek bir `AppState` (ChangeNotifier, `provider`
  paketiyle) — auth, tema, ekran, gelir/gider/hedef listeleri ve
  bunlardan türetilen tüm sayılar (toplam gelir/gider, bakiye, tasarruf
  oranı, kategori kırılımı, bütçe ilerlemesi, aylık trend) burada.
- **"Güncel dönem"**: Takvimdeki gerçek "bugün" yerine, defterdeki en
  güncel tarih esas alınır (`AppState._periodAnchor`) — böylece uygulama
  ileride hangi tarihte açılırsa açılsın demo verisiyle tutarlı bir
  "bu ay" gösterir.
- **Piyasa verileri**: `lib/services/market_service.dart`, USD/TRY ve
  EUR/TRY için ücretsiz, anahtarsız `@fawazahmed0/currency-api`
  aynasından canlı veri çeker (bugün/dün karşılaştırmasıyla değişim
  yüzdesi). Altın ve BIST 100 için ücretsiz/anahtarsız bir kaynak
  bulunmadığından referans değerlerde kalır — gerçek bir sağlayıcı
  bağlanacaksa bu dosya güncellenmelidir. Ağ isteği başarısız olursa
  ekran hiçbir zaman boş kalmaz, son bilinen/varsayılan değerler
  gösterilir.
- **Tasarım sistemi**: Renk tokenları, tipografi ve bileşen stilleri
  `lib/theme/palette.dart` ve `lib/theme/app_theme.dart` içinde,
  orijinal prototipin `getTokens()` fonksiyonu ve
  `uploads/design-3.md` renk spesifikasyonuyla birebir eşleşecek
  şekilde tanımlıdır (Archivo yazı tipi, koyu/aydınlık tema).
