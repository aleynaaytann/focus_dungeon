# 🏰 Focus Dungeon

Focus Dungeon, oyunlaştırma (gamification) dinamiklerini kullanarak kullanıcıların odaklanma sürelerini artırmayı ve üretkenliklerini bir RPG (Rol Yapma Oyunu) evreniyle birleştirmeyi amaçlayan **Mobil Odaklanma ve Pomodoro Uygulamasıdır.**

Bu proje, bir üniversite dönem projesi kapsamında Flutter framework'ü ve Firebase servisleri kullanılarak geliştirilmiştir.

---

## 🚀 Proje Özellikleri

### 1. 🛡️ Karakter ve Sınıf Seçimi
* **Farklı Yetenek Sınıfları:** Kod Savaşçısı, Pomodoro Büyücüsü ve Tasarım Okçusu olmak üzere 3 benzersiz karakter sınıfı.
* **Özelleştirilmiş İlerleme:** Her sınıfın kendine has odaklanma gücü bonusları ve görsel tasarımları bulunmaktadır.

### 2. ⏳ Zindan Mücadelesi (Pomodoro Mekaniği)
* **Özelleştirilebilir Sayaç:** Kullanıcılar girmek istedikleri odaklanma süresini dakika cinsinden kendileri belirleyebilirler.
* **Gerçek Zamanlı Takip:** Süre ilerledikçe XP (Deneyim) barı dolarken, odaklanma süresi başarıyla bittiğinde karakter Seviye (Level) atlar ve Altın kazanır.

### 3. 💀 RPG Dinamikleri ve Ceza Sistemi
* **Durdurma Cezası:** Oturum durdurulduğunda (Pause) karakter altın kaybeder.
* **Pes Etme Hasarı:** Mücadeleden tamamen çekilindiğinde karakterin canı (HP) azalır.
* **Ölüm Ekranı (Game Over):** Canı tamamen tükenen kullanıcılar için iki seçenek sunulur: Altın harcayarak mistik ritüelle zindandan canlanmak veya köye ücretsiz dönerek canı yenilemek.

### 4. 💼 Mistik Market ve Envanter Sistemi
* **Şifa İksiri:** Marketten altın karşılığı alınarak sırt çantasından (Envanter) kullanılabilir ve canı anında yeniler.
* **Efsanevi Kod Kılıcı:** Satın alındığında pasif olarak envantere eklenir; pes etme hasarını azaltırken, zindan bitiminde kazanılan altın miktarını 2 katına çıkarır.

---

## 🛠️ Kullanılan Teknolojiler

* **Framework:** [Flutter](https://flutter.dev) (Dart dili ile)
* **Backend & Veritabanı:** * **Firebase Auth:** Güvenli e-posta ve şifre tabanlı kullanıcı kayıt/giriş mekanizması.
  * **Cloud Firestore:** Kullanıcıların seviye, altın, can ve envanter verilerinin anlık olarak bulutta saklanması (Save/Load sistemi).
* **Geliştirme Ortamı:** Visual Studio Code & Git / GitHub

---

## 📦 Kurulum ve Çalıştırma

Projeyi yerel bilgisayarınızda çalıştırmak için aşağıdaki adımları takip edebilirsiniz:

1. **Projeyi Klonlayın:**
   ```bash
   git clone [https://github.com/kullanici_adin/focus_dungeon.git](https://github.com/kullanici_adin/focus_dungeon.git)
