# Finansal Asistan

Gelir ve giderlerin kategori bazlı takip edildiği, harcama dağılımının
görselleştirildiği ve güncel piyasa verilerinin (döviz, altın, BIST) tek
ekranda gösterildiği bir kişisel finans uygulaması. Flutter ile
geliştirilmiştir ve **Web** hedefler; dar pencerelerde alt gezinme
çubuğu, geniş pencerelerde kenar çubuklu bir düzen kullanan tek bir
duyarlı (responsive) arayüzü vardır (bkz.
`lib/widgets/adaptive_shell.dart`).

Bu sürüm bir prototip / çalışır temel sistemdir — production değildir
(gerçek banka entegrasyonu, production seviye kimlik doğrulama, push
bildirimleri kapsam dışıdır).

Bu proje, Claude Design'da hazırlanan etkileşimli bir prototipten
(Modernist tasarım sistemi tokenlarıyla) yola çıkılarak gerçek bir
Flutter uygulamasına dönüştürülmüştür.

## Kurulum

```bash
flutter pub get
```

Flutter SDK kurulu değilse: https://docs.flutter.dev/get-started/install

## Çalıştırma

```bash
flutter run -d chrome        # Chrome yüklüyse
flutter run -d web-server    # Chrome gerekmeden, verilen localhost adresinden
```

## Test

```bash
flutter analyze   # statik analiz
flutter test      # widget testleri — auth akışı + her ekranın her demo
                   # kullanıcı ve her iki genişlik kırılımında (dar
                   # pencere / geniş pencere) hatasız render edildiğini
                   # doğrular
```

## Hesaplar

Giriş ekranı iki tür hesap listeler, ikisi de bu tarayıcının yerel
deposunda (`shared_preferences` → web'de `localStorage`) kalıcı olarak
saklanır — sunucu yok, veriler yalnızca o tarayıcıda yaşar:

- **Demo hesaplar** (bkz. `lib/data/demo_data.dart`) — farklı gelir
  profillerini gösteren, koda gömülü üç örnek hesap:

  | Hesap | Profil |
  |---|---|
  | Ayşe Kaya | Düzenli maaşlı kullanıcı — sabit aylık maaş, düzenli gider |
  | Mert Demir | Freelance / değişken gelirli — aydan aya değişen proje ödemeleri |
  | Elif Şahin | Dar bütçeli kullanıcı — düşük gelir, yüksek gider/gelir oranı |

  Her biri Temmuz–Eylül 2026 arası gerçekçi bir gelir/gider geçmişiyle
  başlar; o hesapla yapılan değişiklikler de kalıcı olarak saklanır.

- **Kayıtlı hesaplar** — "Kayıt Ol" ile oluşturulan, ad/e-posta/şifre
  içeren hesaplar. Sayıları **sınırsızdır**; her biri boş bir defterle
  başlar. "Giriş Yap" bu hesapların e-posta/şifresiyle gerçekten
  eşleştirilir (yanlış şifre veya bulunamayan e-posta hata mesajı
  gösterir; aynı e-posta ile ikinci kez kayıt reddedilir).

Her hesap satırının yanındaki simge o hesabı listeden **kaldırır**:
demo hesaplarda bu geri alınabilir bir gizlemedir ("Gizlenen demo
hesapları geri getir" ile geri gelir); kayıtlı hesaplarda ise onay
istenen, **kalıcı bir silmedir** (hesap ve tüm gelir/gider/hedef
verisi bir daha geri gelmez).

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
  yüzdesi) ve her 5 dakikada bir otomatik yeniler. Altın ve BIST 100
  için ücretsiz/anahtarsız bir kaynak bulunmadığından referans
  değerlerde kalır — gerçek bir sağlayıcı bağlanacaksa bu dosya
  güncellenmelidir. Ağ isteği başarısız olursa ekran hiçbir zaman boş
  kalmaz, son bilinen/varsayılan değerler gösterilir.
- **Tasarım sistemi**: Renk tokenları, tipografi ve bileşen stilleri
  `lib/theme/palette.dart` ve `lib/theme/app_theme.dart` içinde
  tanımlıdır (Archivo yazı tipi, koyu/aydınlık tema).
- **Hesap depolama**: `lib/services/account_store.dart`, hesap listesini
  ve her hesabın defterini `shared_preferences` (web'de `localStorage`)
  üzerinde JSON olarak saklar. `lib/services/prefs.dart`'taki kısa
  zaman aşımı, `shared_preferences`'ın platform kanalının hiç
  yanıtlamadığı ortamlarda (ör. bazı test çalıştırıcıları) uygulamanın
  sonsuza kadar askıda kalmak yerine zarifçe bellek-içi moda düşmesini
  sağlar — gerçek web hedefinde bu yol zaten anında sonuçlanır.
