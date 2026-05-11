// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Firebase'i uyandırıyoruz
  } catch (e) {
    print("Bağlantı hatası: $e");
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
        brightness: Brightness.dark, // Zindan havası için karanlık tema
        primaryColor: Colors.deepPurple,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Maceracı Kaydı Fonksiyonu
  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("Yeni bir kahraman doğdu!");
      if (mounted) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const CharacterSelectionScreen()),
  );
}
    } catch (e) {
      print("Kayıt hatası: $e");
    }
  }

  // Zindana Giriş Fonksiyonu
  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("Zindana geri dönüldü!");
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CharacterSelectionScreen()),
        );
      }
    } catch (e) {
      print("Giriş hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.castle, size: 80, color: Colors.deepPurpleAccent),
            const SizedBox(height: 20),
            const Text(
              "FOCUS DUNGEON",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "E-posta", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Şifre", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text("Giriş Yap"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: register,
                    child: const Text("Kayıt Ol"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class CharacterSelectionScreen extends StatelessWidget {
  const CharacterSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sınıfını Seç")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Zindana hangi yetenekle gireceksin?", 
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 30),
            _buildClassCard(context, "Kod Savaşçısı", Icons.terminal, Colors.blue),
            _buildClassCard(context, "Pomodoro Büyücüsü", Icons.auto_fix_high, Colors.orange),
            _buildClassCard(context, "Tasarım Okçusu", Icons.brush, Colors.pink),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: color, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Odaklanma gücü +10"),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          print("$title seçildi!");
          // 3. ekran olan Ana Sayaç sayfasına burada gideceğiz
          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DungeonScreen(className: title)),
);
        },
      ),
    );
  }
}
class DungeonScreen extends StatefulWidget {
  final String className;
  const DungeonScreen({super.key, required this.className});

  @override
  State<DungeonScreen> createState() => _DungeonScreenState();
}

class _DungeonScreenState extends State<DungeonScreen> {
  int _seconds = 1500; // 25 dakika
  bool _isActive = false;

Timer? _timer;
  void _startTimer() {
    if (_isActive) return;
    setState(() => _isActive = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--; // İşte burada saniye değiştiği için o 'final' uyarısı uçup gidecek!
        } else {
          _timer?.cancel();
          _isActive = false;
          print("Zindan Tamamlandı! Altın Kazandın.");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.className, style: const TextStyle(color: Colors.purpleAccent, fontSize: 24)),
            const Icon(Icons.shield, size: 100, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text("ZİNDAN DERİNLİĞİ", style: TextStyle(letterSpacing: 4)),
            Text(
              "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _startTimer,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[900]),
              child: Text(_isActive ? "ODAKLANILIYOR..." : "MÜCADELEYİ BAŞLAT"),
            ),
          ],
        ),
      ),
    );
  }
}