import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.material(
      title: 'DUSA Sports Academy',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
          cardColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFFF4C00),
            selectionHandleColor: Color(0xFFFF4C00),
            selectionColor: Color(0x33FF4C00),
          ),
        ),
        child: child!,
      ),
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadSlateColorScheme.light(
          background: Color(0xFFF8FAFC),
          foreground: Color(0xFF0F172A),
          card: Colors.white,
          popover: Colors.white,
          border: Color(0xFFE2E8F0),
          primary: Color(0xFFFF4C00),
          primaryForeground: Colors.white,
          secondary: Color(0xFF1F2937),
          secondaryForeground: Colors.white,
          muted: Color(0xFFF1F5F9),
          mutedForeground: Color(0xFF64748B),
        ),
        primaryButtonTheme: ShadButtonTheme(
          backgroundColor: const Color(0xFFFF4C00),
          hoverBackgroundColor: const Color(0xFFE04300),
          foregroundColor: Colors.white,
          hoverForegroundColor: Colors.white,
        ),
        outlineButtonTheme: ShadButtonTheme(
          hoverBackgroundColor: const Color(0xFFFF4C00).withOpacity(0.08),
          hoverForegroundColor: const Color(0xFFFF4C00),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class BookingProvider extends ChangeNotifier {
  String _selectedPlan = 'Gold Pass';
  String _selectedSubPlan = '1 Year';

  // Onboarding & Profile details
  bool _isOnboarded = false;
  bool _isAdminMode = false;
  String _adminDateFilter = 'Today';
  String _profileName = 'Ashok Kumar';
  String _profileMobile = '+91 98765 43210';
  String _profileEmail = 'ashok@dusasports.com';
  String _activeMembership = 'Gold Annual Pass';
  String _memberId = 'DUSA-2026-9842';
  int _selectedFacilityTab = 0;

  // Streaks & Badges
  int _gymStreak = 14;
  int _badmintonStreak = 8;
  int _swimStreak = 5;
  final List<String> _unlockedBadges = ['Early Bird 🌅', '10-Day Streak 🔥', 'Badminton Ace 🏸', 'Café VIP 🥤'];

  // Café Cart
  final Map<String, int> _cafeCart = {};

  // Café Orders
  final List<Map<String, dynamic>> _cafeOrders = [
    {
      'orderId': 'ORD-8942',
      'item': '1x Whey Protein Shake (Choco)',
      'amount': '₹120',
      'date': 'Today @ 06:30 PM',
      'status': 'Completed',
    },
    {
      'orderId': 'ORD-8710',
      'item': '2x Berry Hydration Smoothie',
      'amount': '₹240',
      'date': 'Yesterday @ 07:15 PM',
      'status': 'Completed',
    },
  ];

  // Enquiry Details
  final List<Map<String, dynamic>> _enquiries = [];
  
  // 2D Court Selection State
  final Set<String> _selectedCourtSlots = {};

  // Chatbot State
  final List<Map<String, String>> _chatMessages = [
    {
      'sender': 'ai',
      'text': 'Welcome to DUSA Sports Academy! How can I assist you with your fitness journey or slot bookings today? (You can also ask me in Tamil!)'
    }
  ];

  // Dynamic Calculator Config
  bool _includeGym = true;
  int _gymMonths = 12;
  bool _includeSwimming = false;
  bool _includeCoaching = false;
  bool _includeSauna = false;

  // Getters
  String get selectedPlan => _selectedPlan;
  String get selectedSubPlan => _selectedSubPlan;
  bool get isOnboarded => _isOnboarded;
  bool get isAdminMode => _isAdminMode;
  String get adminDateFilter => _adminDateFilter;
  String get profileName => _profileName;
  String get profileMobile => _profileMobile;
  String get profileEmail => _profileEmail;
  String get activeMembership => _activeMembership;
  String get memberId => _memberId;
  int get selectedFacilityTab => _selectedFacilityTab;
  int get gymStreak => _gymStreak;
  int get badmintonStreak => _badmintonStreak;
  int get swimStreak => _swimStreak;
  List<String> get unlockedBadges => _unlockedBadges;
  Map<String, int> get cafeCart => _cafeCart;
  List<Map<String, dynamic>> get cafeOrders => _cafeOrders;
  List<Map<String, dynamic>> get enquiries => _enquiries;
  Set<String> get selectedCourtSlots => _selectedCourtSlots;
  List<Map<String, String>> get chatMessages => _chatMessages;

  bool get includeGym => _includeGym;
  int get gymMonths => _gymMonths;
  bool get includeSwimming => _includeSwimming;
  bool get includeCoaching => _includeCoaching;
  bool get includeSauna => _includeSauna;

  // Pricing Logic
  int get calculatedTotal {
    int total = 0;
    if (_includeGym) {
      if (_gymMonths == 1) total += 2500;
      else if (_gymMonths == 3) total += 6500;
      else if (_gymMonths == 6) total += 11000;
      else if (_gymMonths == 12) total += 18000;
    }
    if (_includeSwimming) total += (_gymMonths * 1200);
    if (_includeCoaching) total += (_gymMonths * 2000);
    if (_includeSauna) total += 1500;

    return total;
  }

  void toggleGym(bool val) { _includeGym = val; notifyListeners(); }
  void setGymMonths(int months) { _gymMonths = months; notifyListeners(); }
  void toggleSwimming(bool val) { _includeSwimming = val; notifyListeners(); }
  void toggleCoaching(bool val) { _includeCoaching = val; notifyListeners(); }
  void toggleSauna(bool val) { _includeSauna = val; notifyListeners(); }

  void addCafeItem(String item) {
    _cafeCart[item] = (_cafeCart[item] ?? 0) + 1;
    notifyListeners();
  }

  void removeCafeItem(String item) {
    if (_cafeCart.containsKey(item)) {
      if (_cafeCart[item]! > 1) {
        _cafeCart[item] = _cafeCart[item]! - 1;
      } else {
        _cafeCart.remove(item);
      }
      notifyListeners();
    }
  }

  void placeCafeOrder([String? item]) {
    if (item != null) {
      _cafeOrders.insert(0, {
        'orderId': 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        'item': item,
        'amount': '₹180',
        'date': 'Just Now',
        'status': 'Preparing',
      });
    } else if (_cafeCart.isNotEmpty) {
      final String summary = _cafeCart.entries.map((e) => '${e.value}x ${e.key}').join(', ');
      _cafeOrders.insert(0, {
        'orderId': 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        'item': summary,
        'amount': '₹180',
        'date': 'Just Now',
        'status': 'Preparing',
      });
      _cafeCart.clear();
    }
    notifyListeners();
  }

  void toggleCourtSlot(String slotId) {
    if (_selectedCourtSlots.contains(slotId)) {
      _selectedCourtSlots.remove(slotId);
    } else {
      _selectedCourtSlots.add(slotId);
    }
    notifyListeners();
  }

  void clearCourtSlots() {
    _selectedCourtSlots.clear();
    notifyListeners();
  }

  void clearSelectedSlots() {
    _selectedCourtSlots.clear();
    notifyListeners();
  }

  void setPlan(String plan, {String subPlan = '1 Year'}) {
    _selectedPlan = plan;
    _selectedSubPlan = subPlan;
    notifyListeners();
  }

  void setSelectedPlan(String plan, String subPlan) {
    _selectedPlan = plan;
    _selectedSubPlan = subPlan;
    notifyListeners();
  }

  void setFacilityTab(int index) {
    _selectedFacilityTab = index;
    notifyListeners();
  }

  void onboardUser({required String name, required String mobile, required String email}) {
    _profileName = name;
    _profileMobile = mobile;
    _profileEmail = email;
    _isOnboarded = true;
    notifyListeners();
  }

  void updateProfile({required String name, required String mobile, required String email}) {
    _profileName = name;
    _profileMobile = mobile;
    _profileEmail = email;
    notifyListeners();
  }

  void saveProfile({required String name, required String mobile, required String email}) {
    _profileName = name;
    _profileMobile = mobile;
    _profileEmail = email;
    _isOnboarded = true;
    _activeMembership = 'Gold Annual Pass';
    _memberId = 'DUSA-2026-9842';
    notifyListeners();
  }

  void toggleAdminMode() {
    _isAdminMode = !_isAdminMode;
    notifyListeners();
  }

  void setAdminDateFilter(String filter) {
    _adminDateFilter = filter;
    notifyListeners();
  }

  void sendMessage(String text) {
    _chatMessages.add({'sender': 'user', 'text': text});
    notifyListeners();
  }

  void addChatMessage(String sender, String text) {
    _chatMessages.add({'sender': sender, 'text': text});
    notifyListeners();
  }

  void incrementGymStreak() {
    _gymStreak += 1;
    notifyListeners();
  }

  void incrementBadmintonStreak() {
    _badmintonStreak += 1;
    notifyListeners();
  }

  void purchaseMembership({String? plan, String? duration, String? planName, String? subPlanName}) {
    final String p = plan ?? planName ?? _selectedPlan;
    final String d = duration ?? subPlanName ?? _selectedSubPlan;
    _activeMembership = '$p ($d)';
    _selectedPlan = p;
    _selectedSubPlan = d;
    notifyListeners();
  }

  void submitEnquiry({String? name, String? mobile, String? phone, String? category, String? note, String? email, String? source}) {
    _enquiries.insert(0, {
      'id': 'ENQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'name': name ?? _profileName,
      'phone': mobile ?? phone ?? _profileMobile,
      'category': category ?? 'General',
      'note': note ?? '',
      'date': 'Today',
      'status': 'Pending',
    });
    notifyListeners();
  }
}
