import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'shell_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _completeOnboarding(BookingProvider provider) {
    if (_formKey.currentState?.validate() ?? false) {
      provider.onboardUser(
        name: _nameController.text.trim(),
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ShellScreen()),
      );
    }
  }

  void _nextPage(BookingProvider provider) {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding(provider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Page View (Full Screen Images + Overlay Content)
          PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              // Slide 1: Multi-Sport Academy
              _buildFullScreenSlide(
                imagePath: 'assets/onboarding_multisport_hero.png',
                headline: 'We don\'t just build gyms.\nWe build champions.',
                subheadline: 'Madurai\'s premier multi-sport & athletic performance academy.',
                badgeText: 'BADMINTON • GYM • POOL • RECOVERY',
                cardContent: _buildPhilosophyOverlay(),
              ),

              // Slide 2: Wooden Badminton Courts
              _buildFullScreenSlide(
                imagePath: 'assets/onboarding_badminton_hero.png',
                headline: 'One tap court reserve.\nReal-time availability.',
                subheadline: 'Book 4 tournament wooden courts or find local players to play with.',
                badgeText: 'DUSA PLAY • 4 WOODEN COURTS',
                cardContent: _buildCourtOverlay(),
              ),

              // Slide 3: Gym & Strength Deck
              _buildFullScreenSlide(
                imagePath: 'assets/onboarding_gym_hero.png',
                headline: 'World-class training.\nCertified coaches.',
                subheadline: 'Evost strength machines, personal training, weight loss & smart workout plans.',
                badgeText: 'AT-CENTER GYM & COACHING',
                cardContent: _buildGymOverlay(),
              ),

              // Slide 4: Aadukalam Health Café
              _buildFullScreenSlide(
                imagePath: 'assets/onboarding_cafe_hero.png',
                headline: 'Clean athlete fuel.\nPre-order post-workout.',
                subheadline: 'High-protein smoothies, clean meals & scheduled pickup when your session ends.',
                badgeText: 'AADUKALAM HEALTH CAFÉ',
                cardContent: _buildCafeOverlay(),
              ),

              // Slide 5: AI Assistant
              _buildFullScreenSlide(
                imagePath: 'assets/onboarding_ai_hero.png',
                headline: 'Your AI Concierge.\nAnswers in English & Tamil.',
                subheadline: 'Instant 24/7 help for court slot bookings, cafe pre-orders & match scorecards.',
                badgeText: 'DUSA AI ASSISTANT',
                cardContent: _buildAiOverlay(),
              ),

              // Slide 6: Profile Setup & Pass Generation
              _buildFormSlide(provider),
            ],
          ),

          // Top Header Branding & Skip
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 54,
                      width: 54,
                      errorBuilder: (c, e, s) => const Icon(Icons.sports, color: Color(0xFFFF4C00), size: 36),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'DUSA SPORTS',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                if (_currentPage < 5)
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        5,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF4C00),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Bar Navigation (Flash AI Style)
          Positioned(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Indicators (Dot style)
                Row(
                  children: List.generate(6, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 6),
                      height: 6,
                      width: isActive ? 24 : 6,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFFF4C00) : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),

                // Circular Action Arrow FAB Button
                GestureDetector(
                  onTap: () => _nextPage(provider),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4C00),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4C00).withOpacity(0.5),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Full Screen Slide Widget Template ---
  Widget _buildFullScreenSlide({
    required String imagePath,
    required String headline,
    required String subheadline,
    required String badgeText,
    required Widget cardContent,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Full Screen Background Image
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(color: const Color(0xFF0F172A)),
        ),

        // 2. High-Contrast Gradient Overlay (Dark bottom gradient for crystal clear text readability)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.35),
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.88),
                Colors.black.withOpacity(0.98),
              ],
              stops: const [0.0, 0.35, 0.75, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // 3. Text & Visual Overlay (Positioned above image)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 60),
                // Badge Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4C00),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Headline (Serif & Italic - Flash AI Style)
                Text(
                  headline,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    height: 1.22,
                    shadows: [
                      Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 10, offset: const Offset(0, 2)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subheadline
                Text(
                  subheadline,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: const Color(0xFFCBD5E1),
                    height: 1.4,
                    shadows: [
                      Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                
                // Floating Card Content Snippet
                cardContent,
                const SizedBox(height: 90), // Space for bottom controls
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Feature Overlay 1: Philosophy ---
  Widget _buildPhilosophyOverlay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGlassBadge(Icons.sports_tennis, '4 Courts'),
        _buildGlassBadge(Icons.fitness_center, 'Evost Gym'),
        _buildGlassBadge(Icons.pool, 'Olympic Pool'),
        _buildGlassBadge(Icons.hot_tub, 'Ice & Sauna'),
      ],
    );
  }

  // --- Feature Overlay 2: Court Booking ---
  Widget _buildCourtOverlay() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Court 1 (Wooden)', style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('06:00 AM - 07:00 AM • Tomorrow', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(8)),
            child: Text('AVAILABLE', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- Feature Overlay 3: Gym & Personal Training ---
  Widget _buildGymOverlay() {
    return Row(
      children: [
        Expanded(child: _buildServicePill('Personal Training', Icons.person)),
        const SizedBox(width: 8),
        Expanded(child: _buildServicePill('Weight Loss', Icons.monitor_weight_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _buildServicePill('Smart Routine', Icons.assignment_outlined)),
      ],
    );
  }

  // --- Feature Overlay 4: Aadukalam Health Café ---
  Widget _buildCafeOverlay() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_cafe, color: Color(0xFFFF4C00), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Whey Protein Shake (Choco)', style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('24g Protein • Pickup Post-Workout (06:30 PM)', style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF94A3B8))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFFF4C00), borderRadius: BorderRadius.circular(6)),
            child: Text('PRE-ORDER', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- Feature Overlay 5: AI Concierge ---
  Widget _buildAiOverlay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.smart_toy_rounded, color: Color(0xFFFF4C00), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text('AI Assistant: DUSA-வில் பேட்மிண்டன் பயிற்சி timings காலை 6:00 - இரவு 9:00!', style: GoogleFonts.inter(fontSize: 11, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- Slide 6: Profile Setup & Pass Generation Form (Flash AI Luxury Style) ---
  Widget _buildFormSlide(BookingProvider provider) {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 70),
                
                // Brand Crest & Badge Header
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 90,
                        width: 90,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(Icons.sports, color: Color(0xFFFF4C00), size: 50),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4C00).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.4)),
                        ),
                        child: Text(
                          'MEMBER LOGIN & REGISTRATION',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF4C00),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Headline
                Text(
                  'Welcome to DUSA Sports.\nLogin to Continue.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    height: 1.22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter your name and mobile number to access your membership dashboard & court bookings.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8), height: 1.4),
                ),
                const SizedBox(height: 24),

                // Form Glassmorphic Card Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Field
                      _buildInputLabel('Full Name *'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        cursorColor: const Color(0xFFFF4C00),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter your name' : null,
                        style: GoogleFonts.inter(fontSize: 13.5, color: Colors.white),
                        decoration: _buildInputDecoration('Enter your full name', Icons.person_outline),
                      ),
                      const SizedBox(height: 16),

                      // Mobile Field
                      _buildInputLabel('Mobile Number *'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _mobileController,
                        cursorColor: const Color(0xFFFF4C00),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Please enter mobile number';
                          if (val.trim().length != 10) return 'Mobile number must be 10 digits';
                          return null;
                        },
                        style: GoogleFonts.inter(fontSize: 13.5, color: Colors.white),
                        decoration: _buildInputDecoration('Enter 10-digit mobile number', Icons.phone_outlined),
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      _buildInputLabel('Email Address (Optional)'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: const Color(0xFFFF4C00),
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.inter(fontSize: 13.5, color: Colors.white),
                        decoration: _buildInputDecoration('Enter your email address', Icons.email_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                GestureDetector(
                  onTap: () => _completeOnboarding(provider),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4C00),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4C00).withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LOG IN TO DUSA SPORTS 🚀',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helpers ---
  Widget _buildGlassBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFF4C00), size: 18),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildServicePill(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFFF4C00), size: 14),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              title,
              style: GoogleFonts.outfit(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFCBD5E1)));
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
      prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF4C00), width: 1.5)),
    );
  }
}

