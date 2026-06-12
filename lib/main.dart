import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const SozodioApp());
}

class SozodioApp extends StatefulWidget {
  const SozodioApp({super.key});
  @override
  State<SozodioApp> createState() => _SozodioAppState();
}

class _SozodioAppState extends State<SozodioApp> {
  bool isDark = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sozodio Binary Pro',
      themeMode: isDark? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: HomeScreen(toggleTheme: () => setState(() => isDark =!isDark), isDark: isDark),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;
  const HomeScreen({super.key, required this.toggleTheme, required this.isDark});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String binaryInput = '';
  bool isSigned = false;
  int bitLength = 8;
  String selectedOp = '+';

  String binaryAdd(String a, String b) {
    int da = int.parse(a, radix: 2);
    int db = int.parse(b, radix: 2);
    return (da + db).toRadixString(2);
  }
  String binarySub(String a, String b) {
    int da = int.parse(a, radix: 2);
    int db = int.parse(b, radix: 2);
    return (da - db).toRadixString(2);
  }
  String binaryMul(String a, String b) {
    int da = int.parse(a, radix: 2);
    int db = int.parse(b, radix: 2);
    return (da * db).toRadixString(2);
  }
  String binaryDiv(String a, String b) {
    int da = int.parse(a, radix: 2);
    int db = int.parse(b, radix: 2);
    if (db == 0) return 'Error';
    return (da ~/ db).toRadixString(2);
  }
  String binaryAnd(String a, String b) {
    int da = int.parse(a, radix: 2);
    int db = int.parse(b, radix: 2);
    return (da & db).toRadixString(2);
  }
  String binaryOr(String a, String b) {
    int da = int.parse(a, radix: 2);
    int db = int.parse(b, radix: 2);
    return (da | db).toRadixString(2);
  }
  String binaryXor(String a, String b) {
    int da = int.parse(a, radix: 2);
    int db = int.parse(b, radix: 2);
    return (da ^ db).toRadixString(2);
  }

  String applyOp() {
    if (!binaryInput.contains(selectedOp)) return binaryInput;
    var parts = binaryInput.split(selectedOp);
    if (parts.length!= 2 || parts[1].isEmpty) return binaryInput;
    String a = parts[0], b = parts[1];
    try {
      switch (selectedOp) {
        case '+': return binaryAdd(a, b);
        case '-': return binarySub(a, b);
        case '×': return binaryMul(a, b);
        case '÷': return binaryDiv(a, b);
        case 'AND': return binaryAnd(a, b);
        case 'OR': return binaryOr(a, b);
        case 'XOR': return binaryXor(a, b);
      }
    } catch (e) {
      return 'Error';
    }
    return binaryInput;
  }

  String toDec(String bin) {
    if (bin.isEmpty || bin == 'Error') return '0';
    int val = int.parse(bin, radix: 2);
    if (isSigned && bin.length == bitLength && bin[0] == '1') {
      val = val - (1 << bitLength);
    }
    return val.toString();
  }

  String toHex(String bin) {
    if (bin.isEmpty || bin == 'Error') return '0';
    return int.parse(bin, radix: 2).toRadixString(16).toUpperCase();
  }

  Widget buildCalc() {
    String result = applyOp();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(binaryInput, style: GoogleFonts.jetBrainsMono(fontSize: 32)),
                const SizedBox(height: 8),
                Text('Dec: ${toDec(result)} | Hex: ${toHex(result)}', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(label: const Text('4-bit'), selected: bitLength == 4, onSelected: (_) => setState(() => bitLength = 4)),
              ChoiceChip(label: const Text('8-bit'), selected: bitLength == 8, onSelected: (_) => setState(() => bitLength = 8)),
              ChoiceChip(label: const Text('16-bit'), selected: bitLength == 16, onSelected: (_) => setState(() => bitLength = 16)),
              ChoiceChip(label: const Text('32-bit'), selected: bitLength == 32, onSelected: (_) => setState(() => bitLength = 32)),
            ],
          ),
          SwitchListTile(
            title: const Text("Signed 2's Complement"),
            value: isSigned,
            onChanged: (v) => setState(() => isSigned = v),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
               ...['0', '1'].map((e) => ElevatedButton(onPressed: () => setState(() => binaryInput += e), child: Text(e)).animate().scale()),
               ...['+', '-', '×', '÷', 'AND', 'OR', 'XOR'].map((e) => ElevatedButton(onPressed: () => setState(() { binaryInput += e; selectedOp = e; }), child: Text(e, style: const TextStyle(fontSize: 12)))),
                ElevatedButton(onPressed: () => setState(() => binaryInput = ''), child: const Text('C')),
                ElevatedButton(onPressed: () => setState(() => binaryInput = binaryInput.isNotEmpty? binaryInput.substring(0, binaryInput.length - 1) : ''), child: const Icon(Icons.backspace)),
                ElevatedButton(onPressed: () => setState(() => binaryInput = applyOp()), child: const Text('=')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConvert() {
    String result = applyOp();
    int dec = int.tryParse(toDec(result))?? 0;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Binary: $binaryInput', style: GoogleFonts.jetBrainsMono(fontSize: 24)),
          const SizedBox(height: 20),
          Card(child: ListTile(title: const Text('Decimal'), subtitle: Text('$dec'))),
          Card(child: ListTile(title: const Text('Hexadecimal'), subtitle: Text(dec.toRadixString(16).toUpperCase()))),
          Card(child: ListTile(title: const Text('Octal'), subtitle: Text(dec.toRadixString(8)))),
        ],
      ),
    );
  }

  Widget buildProgram() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(child: ListTile(title: Text('Logic Gates'), subtitle: Text('AND, OR, NOT, XOR Simulator - Coming Soon'))),
        Card(child: ListTile(title: Text('IEEE 754 Float'), subtitle: Text('32-bit Float to Binary - Coming Soon'))),
        Card(child: ListTile(title: Text('IP Calculator'), subtitle: Text('Subnet Mask Binary - Coming Soon'))),
      ],
    );
  }

  Widget buildLearn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.quiz), label: const Text('Start Quiz')),
          const SizedBox(height: 16),
          ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.school), label: const Text('Tutorials')),
          const SizedBox(height: 40),
          Text('Sozodio © 2026', style: TextStyle(color: Theme.of(context).colorScheme.outline)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [buildCalc(), buildConvert(), buildProgram(), buildLearn()];
    return Scaffold(
      appBar: AppBar(
        title: Text('Sozodio Binary Pro', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: widget.toggleTheme, icon: Icon(widget.isDark? Icons.light_mode : Icons.dark_mode))],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => setState(() => currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calculate), label: 'Calc'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Convert'),
          NavigationDestination(icon: Icon(Icons.code), label: 'Program'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Learn'),
        ],
      ),
    );
  }
}
