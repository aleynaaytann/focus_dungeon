// ignore_for_file: avoid_print, prefer_final_fields
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); 
    print("Firebase başarıyla uyandırıldı.");
  } catch (e) {
    print("Firebase başlatılamadı: $e");
  }
  runApp(const FocusDungeonApp());
}

class FocusDungeonApp extends StatelessWidget {
  const FocusDungeonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
      ),
      home: const LoginScreen(),
    );
  }
}

// --- GİRİŞ EKRANI (DOKUNULMADI) ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(), password: _passwordController.text.trim());
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CharacterSelectionScreen()));
    } catch (e) { print(e); }
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), password: _passwordController.text.trim());
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CharacterSelectionScreen()));
    } catch (e) { print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.deepPurple.withValues(alpha: 0.3), Colors.black])),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.deepPurpleAccent.withValues(alpha: 0.1), shape: BoxShape.circle, border: Border.all(color: Colors.deepPurpleAccent.withValues(alpha: 0.3), width: 2)), child: const Icon(Icons.castle, size: 75, color: Colors.deepPurpleAccent)),
                  const SizedBox(height: 24),
                  const Text("FOCUS DUNGEON", style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white, shadows: [Shadow(color: Colors.deepPurpleAccent, blurRadius: 15)])),
                  const SizedBox(height: 45),
                  TextField(controller: _emailController, decoration: InputDecoration(labelText: "E-posta", prefixIcon: const Icon(Icons.shield, color: Colors.deepPurpleAccent))),
                  const SizedBox(height: 15),
                  TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Şifre", prefixIcon: const Icon(Icons.vpn_key, color: Colors.deepPurpleAccent))),
                  const SizedBox(height: 30),
                  Row(children: [
                    Expanded(child: ElevatedButton(onPressed: login, child: const Text("Giriş Yap"))),
                    const SizedBox(width: 10),
                    Expanded(child: OutlinedButton(onPressed: register, child: const Text("Kayıt Ol"))),
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- KARAKTER SEÇİM EKRANI (DOKUNULMADI) ---
class CharacterSelectionScreen extends StatelessWidget {
  const CharacterSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.deepPurple.withValues(alpha: 0.15), Colors.black])),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text("Sınıfını Seç", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white, shadows: [Shadow(color: Colors.deepPurpleAccent, blurRadius: 12)])),
              const SizedBox(height: 12),
              Text("Zindana hangi yetenekle gireceksin?", style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 15, fontStyle: FontStyle.italic)),
              const SizedBox(height: 40),
              Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 24), children: [
                _buildModernCard(context, "Kod Savaşçısı", "assets/images/warrior.png", Colors.blue, "Zorlu bug'ları temizlemede üstün hayatta kalma gücü."),
                _buildModernCard(context, "Pomodoro Büyücüsü", "assets/images/mage.png", Colors.orange, "Zamanı bükerek yüksek odaklanma ve hızlı seviye atlama."),
                _buildModernCard(context, "Tasarım Okçusu", "assets/images/archer.png", Colors.pink, "Arayüz hatalarını uzaktan, nokta atışıyla yok etme."),
              ])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, String title, String img, Color color, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.deepPurpleAccent.withValues(alpha: 0.25))),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DungeonScreen(className: title))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Container(width: 65, height: 65, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: color, width: 2)), child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(img, fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.person, color: color)))),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
              const SizedBox(height: 6),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text("Odaklanma gücü +10", style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold))),
            ])),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withValues(alpha: 0.3), size: 16),
          ]),
        ),
      ),
    );
  }
}

// --- ZİNDAN EKRANI ---
class DungeonScreen extends StatefulWidget {
  final String className;
  const DungeonScreen({super.key, required this.className});
  @override
  State<DungeonScreen> createState() => _DungeonScreenState();
}

class _DungeonScreenState extends State<DungeonScreen> {
  int _seconds = 1500;
  int _customResetSeconds = 1500; 
  bool _isActive = false;
  Timer? _timer;
  double _hp = 1.0, _xp = 0.0;
  int _level = 1, _gold = 0;
  List<String> _inventory = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _loadSave(); }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  Future<void> _loadSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('characters').doc(widget.className).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      setState(() { _level = data['level']; _gold = data['gold']; _hp = data['hp'].toDouble(); _inventory = List<String>.from(data['inventory']); _isLoading = false; });
    } else { setState(() => _isLoading = false); _save(); }
  }

  Future<void> _save() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('characters').doc(widget.className).set({'level': _level, 'gold': _gold, 'hp': _hp, 'inventory': _inventory}, SetOptions(merge: true));
  }

  void _startTimer() {
    if (_isActive || _hp <= 0.0) return; 
    setState(() => _isActive = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) { 
          _seconds--; 
          _xp = (1.0 - (_seconds / _customResetSeconds)).clamp(0.0, 1.0); 
        } else { 
          _timer?.cancel(); 
          _isActive = false; 
          _level++; 
          
          if (_inventory.contains("Efsanevi Kod Kılıcı")) {
            _gold += 100;
          } else {
            _gold += 50;
          }
          
          _hp = 1.0; 
          _save(); 
        }
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Zindan mücadelesi başladı! Odaklanma zamanı."), backgroundColor: Colors.deepPurpleAccent)
    );
  }

  void _pauseTimer() {
    if (!_isActive) return;
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _gold = (_gold - 10).clamp(0, double.infinity).toInt(); 
    });
    _save();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Oturum durduruldu! 10 Altın kaybettiniz."), backgroundColor: Colors.orangeAccent)
    );
  }

  void _giveUp() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      if (_inventory.contains("Efsanevi Kod Kılıcı")) {
        _hp = (_hp - 0.1).clamp(0.0, 1.0);
      } else {
        _hp = (_hp - 0.2).clamp(0.0, 1.0);
      }
    });
    _save();
    
    if (_hp <= 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yaralarınız çok ağır! Bilincinizi kaybettiniz..."), backgroundColor: Colors.red)
      );
    } else {
      String mesaj = _inventory.contains("Efsanevi Kod Kılıcı") 
          ? "Kod Kılıcı sayesinde korundunuz! Canınız hafifçe azaldı." 
          : "Mücadeleden çekildiniz! Canınız azaldı.";
          
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mesaj), backgroundColor: Colors.redAccent)
      );
    }
  }

  void _showDurationPickerDialog() {
    if (_isActive || _hp <= 0.0) return; 
    final controller = TextEditingController(text: (_seconds ~/ 60).toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Zindan Süresi Ayarla"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Dakika Cinsinden Süre", suffixText: "dk"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              final minutes = int.tryParse(controller.text) ?? 25;
              setState(() {
                _seconds = minutes * 60;
                _customResetSeconds = minutes * 60; 
                _xp = 0.0;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Mücadele süresi $minutes dakika olarak ayarlandı!"), backgroundColor: Colors.teal)
              );
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }

  void _respawnWithGold() {
    if (_gold >= 50) {
      setState(() {
        _gold -= 50;
        _hp = 1.0;
        _seconds = _customResetSeconds; 
        _xp = 0.0;
      });
      _save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mistik güçler sizi canlandırdı! Zindana devam ediyorsunuz."), backgroundColor: Colors.green)
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yetersiz altın! Canlanma ritüeli başarısız oldu."), backgroundColor: Colors.redAccent)
      );
    }
  }

  void _goToTown() {
    setState(() {
      _hp = 1.0;
      _seconds = _customResetSeconds;
      _xp = 0.0;
      _isActive = false;
    });
    _save();
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => const CharacterSelectionScreen()),
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<dynamic>> detailsMap = {
      "Kod Savaşçısı": [Colors.blue, "assets/images/warrior.png"],
      "Pomodoro Büyücüsü": [Colors.orange, "assets/images/mage.png"],
      "Tasarım Okçusu": [Colors.pink, "assets/images/archer.png"]
    };
    final List<dynamic> details = detailsMap[widget.className] ?? [Colors.deepPurple, "assets/images/warrior.png"];
    final Color cColor = details[0];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.deepPurple.withValues(alpha: 0.1), Colors.black])),
            child: SafeArea(
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator()) 
                  : CustomScrollView(
                      physics: const NeverScrollableScrollPhysics(), 
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios)),
                                  Row(children: [const Icon(Icons.monetization_on, color: Colors.amber, size: 20), const SizedBox(width: 5), Text("$_gold", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber))]),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(builder: (context) => ShopScreen(currentGold: _gold, currentInventory: _inventory))
                                      ).then((value) {
                                        if (value != null && value is Map<String, dynamic>) {
                                          setState(() {
                                            _gold = value['gold'] as int;
                                            _inventory = List<String>.from(value['inventory'] as List);
                                          });
                                          _save();
                                        }
                                      });
                                    }, 
                                    icon: const Icon(Icons.shopping_bag, color: Colors.greenAccent)
                                  ),
                                ]),
                                
                                Column(children: [
                                  Text("${widget.className.toUpperCase()} [LVL $_level]", style: TextStyle(color: cColor, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                  const SizedBox(height: 15),
                                  Container(width: 170, height: 170, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: cColor, width: 3), boxShadow: [BoxShadow(color: cColor.withValues(alpha: 0.25), blurRadius: 15)]), child: ClipRRect(borderRadius: BorderRadius.circular(27), child: Image.asset(details[1], fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.person, size: 80, color: cColor)))),
                                ]),

                                Column(children: [
                                  _buildBar("HP", _hp, Colors.red),
                                  const SizedBox(height: 10),
                                  _buildBar("XP", _xp, Colors.green),
                                ]),

                                InkWell(
                                  onTap: _isActive ? null : _showDurationPickerDialog, 
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 20), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16), border: Border.all(color: _isActive ? Colors.transparent : cColor.withValues(alpha: 0.3))), child: Column(children: [
                                    Text(_isActive ? "ZİNDAN DERİNLİĞİ" : "⏳ SÜREYİ DEĞİŞTİRMEK İÇİN TIKLA", style: TextStyle(letterSpacing: 2, color: _isActive ? Colors.white54 : cColor, fontSize: 12, fontWeight: _isActive ? FontWeight.normal : FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text("${(_seconds ~/ 60).toString().padLeft(2, '0')} : ${(_seconds % 60).toString().padLeft(2, '0')}", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                                  ])),
                                ),

                                Column(children: [
                                  ElevatedButton(
                                    onPressed: _isActive ? _giveUp : _startTimer, 
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isActive ? Colors.red : cColor, 
                                      minimumSize: const Size(200, 50), 
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                                    ), 
                                    child: Text(
                                      _isActive ? "🏳 PES ET" : "▶ MÜCADELEYİ BAŞLAT", 
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                    )
                                  ),
                                  const SizedBox(height: 20),
                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    ElevatedButton(
                                      onPressed: _isActive ? _pauseTimer : null, 
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white24), 
                                      child: const Text("⏸ DURDUR")
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: _openInventoryModal, 
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal), 
                                      child: Text("💼 ENVANTER (${_inventory.length})")
                                    ),
                                  ]),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () { 
                                      setState(() { 
                                        _seconds = _customResetSeconds; 
                                        _hp = 1.0;                     
                                        _isActive = false; 
                                        _timer?.cancel(); 
                                        _xp = 0.0; 
                                      }); 
                                      _save(); 
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Zindan yenilendi, canınız fullendi!"), backgroundColor: Colors.grey)
                                      );
                                    }, 
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white24), 
                                    child: const Text("🔄 SIFIRLA")
                                  ),
                                ]),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          // --- ÖLÜM OVERLAY KATMANI (GÜNCELLENDİ) ---
          if (_hp <= 0.0)
            Container(
              color: Colors.black.withValues(alpha: 0.85),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.redAccent, width: 2),
                          boxShadow: [BoxShadow(color: Colors.redAccent.withValues(alpha: 0.3), blurRadius: 20)]
                        ),
                        child: const Icon(Icons.dangerous, size: 80, color: Colors.redAccent), // skull yerine geçerli Icons.dangerous kullanıldı
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "MÜCADELEN EN KANLI SONLA BİTTİ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "ÖLDÜNÜZ",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white, shadows: [Shadow(color: Colors.red, blurRadius: 15)]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Odaklanma mücadelesinde zindan yaratıklarına veya bug'lara yenik düştün. Şimdi ne yapacaksın?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 40),
                      
                      ElevatedButton(
                        onPressed: _gold >= 50 ? _respawnWithGold : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent[700],
                          disabledBackgroundColor: Colors.white10,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 5
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bolt, color: Colors.white),
                            const SizedBox(width: 8),
                            const Text("MİSTİK CANLANMA ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                            Text("(-50 🪙)", style: TextStyle(fontWeight: FontWeight.bold, color: _gold >= 50 ? Colors.amberAccent : Colors.white30, fontSize: 15)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      
                      OutlinedButton(
                        onPressed: _goToTown,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          side: const BorderSide(color: Colors.white30),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [ // const buraya taşınarak gereksiz const uyarısı giderildi
                            Icon(Icons.gite, color: Colors.white70),
                            SizedBox(width: 8),
                            Text("KÖYE/ŞEHRE GERİ DÖN (ÜCRETSİZ)", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double val, Color color) {
    return Row(children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(width: 10),
      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: val, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation<Color>(color)))),
    ]);
  }

  void _openInventoryModal() {
    showModalBottomSheet(
      context: context, 
      backgroundColor: Colors.grey[950], 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))), 
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24), 
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      const Text("SIRT ÇANTASI (ENVANTER)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)), 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                        child: Text("${_inventory.length} Eşya", style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 12))
                      )
                    ]
                  ),
                  const Divider(color: Colors.white12, height: 30),
                  _inventory.isEmpty 
                      ? const Padding(padding: EdgeInsets.all(40), child: Text("Çantan şu an boş. Marketten eşya alabilirsin!", style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic))) 
                      : SizedBox(
                          height: 250, 
                          child: ListView.builder(
                            itemCount: _inventory.length, 
                            itemBuilder: (c, i) {
                              String itemName = _inventory[i];
                              bool isPotion = itemName == "Şifa İksiri";
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: isPotion ? Colors.redAccent.withValues(alpha: 0.2) : Colors.cyanAccent.withValues(alpha: 0.2))
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    isPotion ? Icons.science : Icons.colorize, 
                                    color: isPotion ? Colors.redAccent : Colors.cyanAccent
                                  ),
                                  title: Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  subtitle: Text(
                                    isPotion ? "Canını %20 yeniler." : "Pes etme hasarını azaltır, altını artırır.", 
                                    style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))
                                  ),
                                  trailing: isPotion 
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(horizontal: 12)
                                          ),
                                          onPressed: () {
                                            if (_hp >= 1.0) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Canın zaten tamamen dolu!"), backgroundColor: Colors.orangeAccent)
                                              );
                                              return;
                                            }
                                            setState(() {
                                              _hp = (_hp + 0.2).clamp(0.0, 1.0);
                                              _inventory.removeAt(i);
                                            });
                                            _save();
                                            Navigator.pop(context); 
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Şifa İksiri kullanıldı! Canınız yenilendi."), backgroundColor: Colors.green)
                                            );
                                          },
                                          child: const Text("KULLAN", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: Colors.cyan.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                          child: const Text("PASİF", style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold))
                                        ),
                                ),
                              );
                            }
                          )
                        )
                ],
              ),
            );
          }
        );
      }
    );
  }
}

// --- MARKET EKRANI ---
class ShopScreen extends StatefulWidget {
  final int currentGold;
  final List<String> currentInventory;
  const ShopScreen({super.key, required this.currentGold, required this.currentInventory});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late int _gold;
  late List<String> _inventory;

  @override
  void initState() {
    super.initState();
    _gold = widget.currentGold;
    _inventory = List<String>.from(widget.currentInventory);
  }

  void _buy(String name, int p, bool isUnique) {
    if (isUnique && _inventory.contains(name)) {
      return; 
    }

    if (_gold >= p) {
      setState(() {
        _gold -= p;
        _inventory.add(name);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$name satın alındı!"), 
          backgroundColor: Colors.deepPurpleAccent,
          duration: const Duration(seconds: 1)
        )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yetersiz altın! Duyuluyor zindanın yankısı..."), backgroundColor: Colors.redAccent)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasSword = _inventory.contains("Efsanevi Kod Kılıcı");

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, 
            end: Alignment.bottomCenter, 
            colors: [Colors.deepPurple.withValues(alpha: 0.15), Colors.black]
          )
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context, {'gold': _gold, 'inventory': _inventory}),
                    ),
                    const Text(
                      "MİSTİK MARKET", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 3, shadows: [Shadow(color: Colors.deepPurpleAccent, blurRadius: 10)])
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withValues(alpha: 0.3))),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                          const SizedBox(width: 6),
                          Text("$_gold", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildShopItem(
                      "Şifa İksiri", 
                      20, 
                      "Canını anında tazelemek için mistik karışım. Envanterden kullanılabilir.", 
                      Icons.science, 
                      Colors.redAccent,
                      false, 
                      false  
                    ),
                    
                    _buildShopItem(
                      "Efsanevi Kod Kılıcı", 
                      100, 
                      "Envanterdeyken pes edince daha az can düşer (%10) ve zindan tamamlanınca 2 kat fazla altın (+100) kazandırır.", 
                      Icons.colorize, 
                      Colors.cyanAccent,
                      true,  
                      hasSword 
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopItem(String name, int price, String desc, IconData iconData, Color itemColor, bool isUnique, bool isPurchasedAndUnique) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white10, 
        borderRadius: BorderRadius.circular(18), 
        border: Border.all(color: isPurchasedAndUnique ? Colors.greenAccent.withValues(alpha: 0.3) : Colors.deepPurpleAccent.withValues(alpha: 0.25))
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 55, 
              height: 55, 
              decoration: BoxDecoration(
                color: isPurchasedAndUnique ? Colors.greenAccent.withValues(alpha: 0.1) : itemColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12), 
                border: Border.all(color: isPurchasedAndUnique ? Colors.greenAccent : itemColor, width: 1.5)
              ), 
              child: Icon(iconData, color: isPurchasedAndUnique ? Colors.greenAccent : itemColor, size: 28)
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isPurchasedAndUnique ? Colors.white60 : Colors.white)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: isPurchasedAndUnique ? Colors.white24 : Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        isPurchasedAndUnique ? "TÜKENDİ" : "$price Altın", 
                        style: TextStyle(color: isPurchasedAndUnique ? Colors.white38 : Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ]
              )
            ),
            
            ElevatedButton(
              onPressed: isPurchasedAndUnique ? null : () => _buy(name, price, isUnique), 
              style: ElevatedButton.styleFrom(
                backgroundColor: isPurchasedAndUnique ? Colors.greenAccent.withValues(alpha: 0.15) : Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: isPurchasedAndUnique ? const BorderSide(color: Colors.greenAccent, width: 1) : BorderSide.none
              ),
              child: isPurchasedAndUnique 
                ? const Icon(Icons.check, color: Colors.greenAccent, size: 18)
                : const Text("AL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
            ),
          ],
        ),
      ),
    );
  }
}