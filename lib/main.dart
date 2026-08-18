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
          background: Color(0xFFF8FAFC), // Cool clean off-white background
          foreground: Color(0xFF0F172A),
          card: Colors.white, // Pure white cards
          popover: Colors.white,
          border: Color(0xFFE2E8F0), // Clean grey borders
          primary: Color(0xFFFF4C00), // DUSA Sports Orange
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
  String _selectedPlan = 'Gold';
  String _selectedSubPlan = '1 Year';

  // Onboarding & Profile details
  bool _isOnboarded = false;
  String _profileName = 'Guest Player';
  String _profileMobile = '';
  String _profileEmail = '';
  String _activeMembership = 'No Active Plan';
  String _memberId = 'DUSA-NEW-MEMBER';
  int _selectedFacilityTab = 0;

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
  int _gymMonths = 12; // 1, 3, 6, 12
  bool _includeSwimming = false;
  bool _includeCoaching = false;
  bool _includeSauna = false;

  // Aadukalam Café Cart State
  final Map<String, int> _cafeCart = {};
  final List<Map<String, dynamic>> _cafeOrders = [];

  // Gamification State
  int _gymStreak = 0;
  int _badmintonStreak = 0;
  int _swimStreak = 0;
  final Set<String> _unlockedBadges = {};

  // Getters
  bool get isOnboarded => _isOnboarded;
  String get selectedPlan => _selectedPlan;
  String get selectedSubPlan => _selectedSubPlan;
  String get profileName => _profileName;
  String get profileMobile => _profileMobile;
  String get profileEmail => _profileEmail;
  String get activeMembership => _activeMembership;
  String get memberId => _memberId;
  List<Map<String, dynamic>> get enquiries => _enquiries;
  Set<String> get selectedCourtSlots => _selectedCourtSlots;
  List<Map<String, String>> get chatMessages => _chatMessages;
  
  bool get includeGym => _includeGym;
  int get gymMonths => _gymMonths;
  bool get includeSwimming => _includeSwimming;
  bool get includeCoaching => _includeCoaching;
  bool get includeSauna => _includeSauna;

  Map<String, int> get cafeCart => _cafeCart;
  List<Map<String, dynamic>> get cafeOrders => _cafeOrders;

  int get gymStreak => _gymStreak;
  int get badmintonStreak => _badmintonStreak;
  int get swimStreak => _swimStreak;
  Set<String> get unlockedBadges => _unlockedBadges;
  int get selectedFacilityTab => _selectedFacilityTab;

  // Setters & Actions
  void onboardUser({required String name, required String mobile, required String email}) {
    _profileName = name;
    _profileMobile = mobile;
    _profileEmail = email;
    _activeMembership = 'Platinum Plan (Annual)';
    _memberId = 'DUSA-2026-${(1000 + (name.hashCode % 9000)).abs()}';
    _gymStreak = 8;
    _badmintonStreak = 4;
    _unlockedBadges.addAll({'Early Bird', 'Gym Warrior', 'Hydration Hero'});
    _isOnboarded = true;
    notifyListeners();
  }

  void purchaseMembership({required String plan, required String duration}) {
    _activeMembership = '$plan ($duration)';
    if (_memberId == 'DUSA-NEW-MEMBER' || _memberId.isEmpty) {
      _memberId = 'DUSA-2026-${(1000 + (_profileName.hashCode % 9000)).abs()}';
    }
    if (plan.contains('Booking') || plan.contains('Court')) {
      _selectedCourtSlots.clear();
    }
    notifyListeners();
  }

  void setPlan(String plan, {String subPlan = '1 Year'}) {
    _selectedPlan = plan;
    _selectedSubPlan = subPlan;
    notifyListeners();
  }

  void setFacilityTab(int index) {
    _selectedFacilityTab = index;
    notifyListeners();
  }

  void updateProfile({required String name, required String mobile, required String email}) {
    _profileName = name;
    _profileMobile = mobile;
    _profileEmail = email;
    notifyListeners();
  }

  void toggleCourtSlot(String slotKey) {
    if (_selectedCourtSlots.contains(slotKey)) {
      _selectedCourtSlots.remove(slotKey);
    } else {
      if (_selectedCourtSlots.length < 3) {
        _selectedCourtSlots.add(slotKey);
      }
    }
    notifyListeners();
  }

  void clearSelectedSlots() {
    _selectedCourtSlots.clear();
    notifyListeners();
  }

  void configureCalculator({
    bool? gym,
    int? months,
    bool? swimming,
    bool? coaching,
    bool? sauna,
  }) {
    if (gym != null) _includeGym = gym;
    if (months != null) _gymMonths = months;
    if (swimming != null) _includeSwimming = swimming;
    if (coaching != null) _includeCoaching = coaching;
    if (sauna != null) _includeSauna = sauna;
    notifyListeners();
  }

  double calculateCustomPrice() {
    double total = 0.0;
    if (_includeGym) {
      if (_gymMonths == 1) total += 3000;
      else if (_gymMonths == 3) total += 5999;
      else if (_gymMonths == 6) total += 9999;
      else if (_gymMonths == 12) total += 15999;
    }
    if (_includeSwimming) total += 10000;
    if (_includeCoaching) total += 30000;
    if (_includeSauna) total += 5000;
    return total;
  }

  void submitEnquiry({
    required String name,
    required String mobile,
    required String email,
    required String source,
  }) {
    final newEnquiry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'mobile': mobile,
      'email': email.isEmpty ? 'N/A' : email,
      'source': source,
      'plan': _selectedPlan,
      'subPlan': _selectedSubPlan,
      'slots': _selectedCourtSlots.toList(),
      'customCalculatorPrice': _selectedPlan == 'Custom Builder' ? calculateCustomPrice() : null,
      'timestamp': DateTime.now(),
      'status': 'Pending Reply',
    };
    _enquiries.add(newEnquiry);
    notifyListeners();
  }

  // Café operations
  void addCafeItem(String name) {
    _cafeCart[name] = (_cafeCart[name] ?? 0) + 1;
    notifyListeners();
  }

  void removeCafeItem(String name) {
    if (_cafeCart.containsKey(name)) {
      if (_cafeCart[name] == 1) {
        _cafeCart.remove(name);
      } else {
        _cafeCart[name] = _cafeCart[name]! - 1;
      }
      notifyListeners();
    }
  }

  void clearCafeCart() {
    _cafeCart.clear();
    notifyListeners();
  }

  void placeCafeOrder(String scheduleTime) {
    if (_cafeCart.isEmpty) return;
    
    final newOrder = {
      'id': 'CAF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'items': Map<String, int>.from(_cafeCart),
      'time': scheduleTime,
      'timestamp': DateTime.now(),
      'status': 'Preparing',
    };
    _cafeOrders.add(newOrder);
    _cafeCart.clear();
    notifyListeners();
  }

  void incrementGymStreak() {
    _gymStreak++;
    if (_gymStreak == 10) {
      _unlockedBadges.add('10-Day Streak');
    }
    notifyListeners();
  }

  void incrementBadmintonStreak() {
    _badmintonStreak++;
    notifyListeners();
  }

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;
    
    _chatMessages.add({'sender': 'user', 'text': message});
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 600), () {
      String responseText = "Thank you for reaching out! For slot bookings, pricing plans, or café orders, please feel free to submit an Enquiry or check out the respective tabs.";
      
      final msgLower = message.toLowerCase();
      if (msgLower.contains('gold') || msgLower.contains('price')) {
        responseText = "Our Gold membership costs ₹30,000/yr inclusive of GST. It includes full access to the Gym, Swimming Pool, Zumba classes, Ice Bath, and Steam & Infrared Sauna Bath.";
      } else if (msgLower.contains('tamil') || msgLower.contains('வணக்கம்') || msgLower.contains('nalam')) {
        responseText = "வணக்கம்! DUSA விளையாட்டு அகாடமிக்கு உங்களை வரவேற்கிறோம். உங்களுக்கு என்ன உதவி தேவை? பேட்மிண்டன் கோர்ட், நீச்சல் குளம் அல்லது ஜிம் பற்றி கேட்கலாம்.";
      } else if (msgLower.contains('badminton') || msgLower.contains('court') || msgLower.contains('coaching')) {
        responseText = "DUSA features 4 premium indoor wooden badminton courts. Coaching is ₹2,500/month for kids and adults, with batches from 6:00 AM to 9:00 PM.";
      } else if (msgLower.contains('gym') || msgLower.contains('fitness') || msgLower.contains('workout')) {
        responseText = "Our Gym packages start at ₹3,000 for 1 month, up to ₹15,999 for a full year. Gym hours are 5:00 AM - 10:00 PM daily. We use premium Evost machines.";
      } else if (msgLower.contains('cafe') || msgLower.contains('smoothie') || msgLower.contains('food') || msgLower.contains('shake')) {
        responseText = "Aadukalam Café inside DUSA offers nutritious shakes, high-protein foods, and refreshing hydration drinks. You can pre-order via the Bookings/Café tab to have it ready post-workout!";
      } else if (msgLower.contains('pool') || msgLower.contains('swim') || msgLower.contains('swimming')) {
        responseText = "Our well-maintained pool is open for kids and adults. Swim packages are ₹10,000/year, or you can register for seasonal coaching batches.";
      } else if (msgLower.contains('sauna') || msgLower.contains('recovery') || msgLower.contains('steam')) {
        responseText = "Our Recovery Zone features Steam Bath, Infrared Sauna, and Ice Bath Hydrotherapy to help ease muscle soreness and reduce fatigue.";
      }
      
      _chatMessages.add({'sender': 'ai', 'text': responseText});
      notifyListeners();
    });
  }
}

