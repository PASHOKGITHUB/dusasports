import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class AdminDashboardScreen extends StatefulWidget {
  final int initialTab;
  const AdminDashboardScreen({super.key, this.initialTab = 0});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late int _selectedTab;

  // Event & Banner Management Controllers
  final _eventTitleController = TextEditingController();
  final _eventFeeController = TextEditingController();
  final _eventSlotsController = TextEditingController();
  String _selectedEventSport = 'Badminton';
  String? _uploadedPosterName;

  // Promotional Hero Banners State
  final List<Map<String, dynamic>> _heroBanners = [
    {
      'title': 'DUSA Monsoon Open Badminton Cup 2026',
      'subtitle': 'Cash Prize Pool ₹50,000 • Singles & Doubles',
      'status': 'ACTIVE',
      'category': 'Tournament',
    },
    {
      'title': 'Aadukalam Health Café 20% Off Whey Shakes',
      'subtitle': 'Pre-order post workout via DUSA App',
      'status': 'ACTIVE',
      'category': 'Offer',
    },
    {
      'title': 'Summer Aquatic Swimming Championship',
      'subtitle': 'Under-16 & Adult Freestyle Trials',
      'status': 'DRAFT',
      'category': 'Event',
    },
  ];

  // Scheduled Events List
  final List<Map<String, dynamic>> _scheduledEvents = [
    {
      'title': 'DUSA Monsoon Open Badminton Cup 2026',
      'date': '28 Aug 2026',
      'sport': 'Badminton',
      'fee': '₹500',
      'slots': '32 / 64 Registered',
      'poster': 'Badminton_Poster.png',
    },
    {
      'title': 'Evost Gym 100KG Bench Press Challenge',
      'date': '05 Sep 2026',
      'sport': 'Fitness',
      'fee': 'Free for Members',
      'slots': '18 / 20 Registered',
      'poster': 'Gym_Challenge.png',
    },
  ];

  // Sample Member List Data
  final List<Map<String, dynamic>> _membersList = [
    {
      'name': 'Karthik Raja',
      'mobile': '+91 98765 43210',
      'plan': 'Gold Annual Pass',
      'status': 'Expiring',
      'expiryDate': '20 Aug 2026',
      'joinDate': '20 Aug 2025',
      'streak': '14 Days',
      'qrCode': 'DUSA-M-8942',
    },
    {
      'name': 'Priya Dharshini',
      'mobile': '+91 98123 45678',
      'plan': 'Badminton Monthly Pass',
      'status': 'Expiring',
      'expiryDate': '22 Aug 2026',
      'joinDate': '22 Jul 2026',
      'streak': '8 Days',
      'qrCode': 'DUSA-M-9012',
    },
    {
      'name': 'Santhosh Kumar',
      'mobile': '+91 97890 12345',
      'plan': 'Gym & Swim Monthly',
      'status': 'Expiring',
      'expiryDate': '24 Aug 2026',
      'joinDate': '24 Jul 2026',
      'streak': '19 Days',
      'qrCode': 'DUSA-M-9104',
    },
    {
      'name': 'Ramesh Kumar',
      'mobile': '+91 94431 88900',
      'plan': 'Gold Annual Pass',
      'status': 'Active',
      'expiryDate': '15 Jan 2027',
      'joinDate': '15 Jan 2026',
      'streak': '22 Days',
      'qrCode': 'DUSA-M-7711',
    },
    {
      'name': 'Anand Viswanathan',
      'mobile': '+91 99402 33110',
      'plan': 'Badminton Court Pass',
      'status': 'Active',
      'expiryDate': '10 Nov 2026',
      'joinDate': '10 May 2026',
      'streak': '11 Days',
      'qrCode': 'DUSA-M-6540',
    },
    {
      'name': 'Vignesh M.',
      'mobile': '+91 98450 11223',
      'plan': 'Gold Annual Pass',
      'status': 'Expired',
      'expiryDate': '13 Aug 2026',
      'joinDate': '13 Aug 2025',
      'streak': '0 Days',
      'qrCode': 'DUSA-M-5401',
    },
  ];

  // Sample Coaches Data
  final List<Map<String, dynamic>> _coaches = [
    {
      'name': 'Coach Anand Kumar',
      'role': 'Head Badminton Coach',
      'rating': 4.9,
      'students': 42,
      'hoursThisMonth': 120,
      'rank': '1st',
      'badge': '🥇 Gold Performer',
      'certifications': ['BWF Level 2 Certified', 'Former State Champion'],
      'achievements': 'Trained 6 Junior National Medalists in 2025.',
      'commission': '₹45,000',
    },
    {
      'name': 'Coach Divya Ramesh',
      'role': 'Senior Swimming Specialist',
      'rating': 4.9,
      'students': 38,
      'hoursThisMonth': 110,
      'rank': '2nd',
      'badge': '🥈 Silver Performer',
      'certifications': ['ASCA Level 3 Aquatic Coach'],
      'achievements': 'Led DUSA Swim Team to 14 Medals in District Meet.',
      'commission': '₹40,000',
    },
    {
      'name': 'Trainer Vikram Sethi',
      'role': 'Master Fitness Trainer',
      'rating': 4.8,
      'students': 31,
      'hoursThisMonth': 98,
      'rank': '3rd',
      'badge': '🥉 Bronze Performer',
      'certifications': ['ACE Certified Personal Trainer'],
      'achievements': 'Transformed 25+ clients with 10kg+ fat loss.',
      'commission': '₹35,000',
    },
  ];

  // Today's Live Transactions Data
  final List<Map<String, dynamic>> _todayTransactions = [
    {'time': '06:00 PM', 'type': 'Badminton Court 1', 'user': 'Ramesh Kumar', 'amount': '₹450', 'payment': 'UPI (GPay)'},
    {'time': '06:30 PM', 'type': 'Café: Whey Shake (Choco)', 'user': 'Anand V.', 'amount': '₹120', 'payment': 'UPI (PhonePe)'},
    {'time': '07:00 PM', 'type': 'Badminton Court 2', 'user': 'Priya Dharshini', 'amount': '₹450', 'payment': 'Cash'},
    {'time': '07:15 PM', 'type': 'Café: Berry Smoothie', 'user': 'Karthik Raja', 'amount': '₹150', 'payment': 'UPI (Paytm)'},
    {'time': '08:00 PM', 'type': 'Badminton Court 3', 'user': 'Santhosh K.', 'amount': '₹450', 'payment': 'UPI (GPay)'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    _eventTitleController.dispose();
    _eventFeeController.dispose();
    _eventSlotsController.dispose();
    super.dispose();
  }

  void _showInfoDialog({
    required String title,
    required String explanation,
    required String calculation,
    required String recommendation,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4C00).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline_rounded, color: Color(0xFFFF4C00), size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('WHAT THIS METRIC MEANS', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 1.1)),
              const SizedBox(height: 4),
              Text(explanation, style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF334155), height: 1.4)),
              const SizedBox(height: 14),

              Text('CALCULATION METHOD', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 1.1)),
              const SizedBox(height: 4),
              Text(calculation, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569))),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4C00).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFFF4C00), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Tip: $recommendation', style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4C00), foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
            child: Text('Got It', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- Today's Live Transactions Modal ---
  void _showTodayTransactionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.12), shape: BoxShape.circle),
              child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF10B981), size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today\'s Live Transactions', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  Text('Court pay-per-play rentals & Café pre-orders', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _todayTransactions.length,
            separatorBuilder: (c, i) => const Divider(color: Color(0xFFE2E8F0), height: 12),
            itemBuilder: (context, index) {
              final tx = _todayTransactions[index];
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (tx['type'] as String).contains('Badminton') ? const Color(0xFFFF4C00).withOpacity(0.1) : const Color(0xFFF59E0B).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      (tx['type'] as String).contains('Badminton') ? Icons.sports_tennis : Icons.local_cafe,
                      color: (tx['type'] as String).contains('Badminton') ? const Color(0xFFFF4C00) : const Color(0xFFF59E0B),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx['type'], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        Text('${tx['user']} • ${tx['time']} (${tx['payment']})', style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  Text(tx['amount'], style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                ],
              );
            },
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4C00), foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- Full Members List Sheet ---
  void _showFullMembersListSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text('DUSA Member Directory (${_membersList.length})', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _membersList.length,
                  itemBuilder: (context, index) {
                    final m = _membersList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFFF4C00).withOpacity(0.12),
                          child: Text((m['name'] as String).substring(0, 1), style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                        ),
                        title: Text(m['name'], style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        subtitle: Text('${m['plan']} • Expiry: ${m['expiryDate']}', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                        onTap: () {
                          Navigator.pop(context);
                          _showMemberDetailsModal(m);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Member Details Modal ---
  void _showMemberDetailsModal(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFFF4C00).withOpacity(0.12),
                  child: Text((member['name'] as String).substring(0, 1), style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member['name'], style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      Text(member['mobile'], style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: member['status'] == 'Active'
                        ? const Color(0xFF10B981).withOpacity(0.12)
                        : (member['status'] == 'Expiring' ? const Color(0xFFF59E0B).withOpacity(0.12) : const Color(0xFFEF4444).withOpacity(0.12)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (member['status'] as String).toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: member['status'] == 'Active'
                          ? const Color(0xFF10B981)
                          : (member['status'] == 'Expiring' ? const Color(0xFFD97706) : const Color(0xFFEF4444)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                children: [
                  _buildDetailRow('Plan Name:', member['plan']),
                  const Divider(color: Color(0xFFE2E8F0), height: 14),
                  _buildDetailRow('Expiry Date:', member['expiryDate']),
                  const Divider(color: Color(0xFFE2E8F0), height: 14),
                  _buildDetailRow('Join Date:', member['joinDate']),
                  const Divider(color: Color(0xFFE2E8F0), height: 14),
                  _buildDetailRow('Attendance Streak:', member['streak']),
                  const Divider(color: Color(0xFFE2E8F0), height: 14),
                  _buildDetailRow('QR Gate ID:', member['qrCode']),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
        Text(val, style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
      ],
    );
  }

  // --- Coach Details Modal ---
  void _showCoachDetailsModal(Map<String, dynamic> coach) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (context) {
        final List<String> certs = List<String>.from(coach['certifications']);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFFF4C00).withOpacity(0.12),
                    child: Text((coach['name'] as String).substring(6, 7), style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coach['name'], style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        Text(coach['role'], style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildModalStat('Rating', '${coach['rating']} ★', const Color(0xFFF59E0B)),
                    Container(width: 1, height: 30, color: const Color(0xFFE2E8F0)),
                    _buildModalStat('Active Students', '${coach['students']}', const Color(0xFF3B82F6)),
                    Container(width: 1, height: 30, color: const Color(0xFFE2E8F0)),
                    _buildModalStat('Hours Trained', '${coach['hoursThisMonth']} hrs', const Color(0xFF10B981)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Certifications:', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: certs.map((c) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.3))),
                  child: Text(c, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                )).toList(),
              ),
              const SizedBox(height: 16),
              Text('Achievements:', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 4),
              Text(coach['achievements'], style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF475569), height: 1.4)),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B))),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    final List<Widget> pages = [
      _buildDashboardTab(provider),
      _buildEventsTab(provider),
      _buildCoachesTab(provider),
      _buildCafeTab(provider),
      _buildAdminProfileTab(provider),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Admin Executive Clean Header
            _buildExecutiveHeader(provider),

            // Main Body View
            Expanded(child: pages[_selectedTab]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF4C00),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10.5),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign_outlined), activeIcon: Icon(Icons.campaign_rounded), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.badge_outlined), activeIcon: Icon(Icons.badge_rounded), label: 'Coaches'),
          BottomNavigationBarItem(icon: Icon(Icons.local_cafe_outlined), activeIcon: Icon(Icons.local_cafe_rounded), label: 'Café'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  // --- Executive Header (DATE FILTER SHOWS ONLY ON DASHBOARD TAB 0) ---
  Widget _buildExecutiveHeader(BookingProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logo.png',
                width: 42,
                height: 42,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(color: Color(0xFFFF4C00), shape: BoxShape.circle),
                  child: const Icon(Icons.sports, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Dashboard',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'DUSA Sports Operations & Analytics',
                      style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Date Range Selector Filter Chips (SHOWS ONLY ON TAB 0: DASHBOARD)
          if (_selectedTab == 0) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Today', 'Yesterday', 'This Week', 'This Month'].map((filter) {
                  final bool isSelected = provider.adminDateFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: const Color(0xFFFF4C00),
                      backgroundColor: const Color(0xFFF1F5F9),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : const Color(0xFF64748B),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFFE2E8F0))),
                      onSelected: (val) {
                        if (val) provider.setAdminDateFilter(filter);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- TAB 1: Dashboard ---
  Widget _buildDashboardTab(BookingProvider provider) {
    final filter = provider.adminDateFilter;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Executive Summary (Top KPI Cards)
          _buildExecutiveSummaryCard(filter),

          const SizedBox(height: 16),

          // 2. Monthly P&L Table
          _buildMonthlyPnLCard(filter),

          const SizedBox(height: 16),

          // 3. Court Utilization Table (Critical for DUSA)
          _buildCourtUtilizationCard(filter),

          const SizedBox(height: 16),

          // 4. Facility Occupancy
          _buildFacilityOccupancyCard(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // --- SECTION 1: Executive Summary Cards ---
  Widget _buildExecutiveSummaryCard(String filter) {
    final List<Map<String, dynamic>> kpis = [
      {'kpi': 'Total Revenue', 'current': '₹25,00,000', 'target': '₹28,00,000', 'status': 'On Track', 'icon': Icons.payments_rounded, 'color': const Color(0xFF10B981)},
      {'kpi': 'Net Profit', 'current': '₹9,00,000', 'target': '₹10,00,000', 'status': 'On Track', 'icon': Icons.trending_up_rounded, 'color': const Color(0xFF0EA5E9)},
      {'kpi': 'Profit Margin %', 'current': '36%', 'target': '35%', 'status': 'Exceeded', 'icon': Icons.pie_chart_rounded, 'color': const Color(0xFF8B5CF6)},
      {'kpi': 'Active Members', 'current': '1,250', 'target': '1,300', 'status': '96% Goal', 'icon': Icons.card_membership_rounded, 'color': const Color(0xFF06B6D4)},
      {'kpi': 'New Enrollments', 'current': '145', 'target': '150', 'status': '97% Goal', 'icon': Icons.person_add_alt_1_rounded, 'color': const Color(0xFFF59E0B)},
      {'kpi': 'Member Retention %', 'current': '88%', 'target': '85%', 'status': 'Exceeded', 'icon': Icons.loop_rounded, 'color': const Color(0xFF14B8A6)},
      {'kpi': 'Court Utilization %', 'current': '84%', 'target': '80%', 'status': 'Exceeded', 'icon': Icons.sports_tennis_rounded, 'color': const Color(0xFFEC4899)},
      {'kpi': 'Customer Satisfaction', 'current': '4.7/5', 'target': '4.5/5', 'status': 'Exceeded', 'icon': Icons.star_rounded, 'color': const Color(0xFF3B82F6)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Executive Summary',
                    style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                  ),
                  Text(
                    'Key performance indicators & monthly target benchmarks',
                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: _showTodayTransactionsDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded, size: 13, color: Color(0xFF10B981)),
                        const SizedBox(width: 4),
                        Text('Receipts', style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: _showFullMembersListSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        const Icon(Icons.people_outline_rounded, size: 13, color: Color(0xFF3B82F6)),
                        const SizedBox(width: 4),
                        Text('Members', style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _showInfoDialog(
                    title: 'Executive Summary (Top KPIs)',
                    explanation: 'High-level operational and financial KPIs comparing current performance to monthly target goals.',
                    calculation: 'Real-time aggregation from POS, membership registrations, and court booking engines.',
                    recommendation: 'Track status badges daily to maintain healthy club profitability and member retention.',
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.08), shape: BoxShape.circle),
                    child: const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFFF4C00)),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Grid of modern KPI cards (2 columns layout)
        LayoutBuilder(
          builder: (context, constraints) {
            final double cardWidth = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: kpis.map((k) {
                final Color themeColor = k['color'] as Color;
                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(color: themeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                            child: Icon(k['icon'] as IconData, size: 18, color: themeColor),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              k['status'],
                              style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.bold, color: themeColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        k['kpi'],
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        k['current'],
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.outlined_flag_rounded, size: 11, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              'Target: ${k['target']}',
                              style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // --- SECTION 2: Monthly P&L Cards ---
  Widget _buildMonthlyPnLCard(String filter) {
    final List<Map<String, dynamic>> expenses = [
      {'category': 'Staff Salary', 'amount': '₹8,00,000', 'percent': 0.50, 'color': const Color(0xFF3B82F6), 'icon': Icons.badge_outlined},
      {'category': 'Rent/EMI', 'amount': '₹3,00,000', 'percent': 0.187, 'color': const Color(0xFF8B5CF6), 'icon': Icons.business_outlined},
      {'category': 'Maintenance', 'amount': '₹1,50,000', 'percent': 0.093, 'color': const Color(0xFFF59E0B), 'icon': Icons.build_outlined},
      {'category': 'Electricity', 'amount': '₹1,20,000', 'percent': 0.075, 'color': const Color(0xFFEC4899), 'icon': Icons.bolt_outlined},
      {'category': 'Other Expenses', 'amount': '₹1,00,000', 'percent': 0.062, 'color': const Color(0xFF64748B), 'icon': Icons.more_horiz_outlined},
      {'category': 'Marketing', 'amount': '₹75,000', 'percent': 0.047, 'color': const Color(0xFF06B6D4), 'icon': Icons.campaign_outlined},
      {'category': 'Equipment Cost', 'amount': '₹50,000', 'percent': 0.031, 'color': const Color(0xFF14B8A6), 'icon': Icons.fitness_center_outlined},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly P&L Summary',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              InkWell(
                onTap: () => _showInfoDialog(
                  title: 'Monthly Profit & Loss (P&L)',
                  explanation: 'Breakdown of total revenues against operational expenses including payroll, rent, utilities, and maintenance.',
                  calculation: 'Net Profit = Total Revenue (₹25,00,000) - Total Expenses (₹16,00,000).',
                  recommendation: 'Target a profit margin above 35% by keeping utility & maintenance costs optimized.',
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.08), shape: BoxShape.circle),
                  child: const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFFF4C00)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // P&L Net Profit Highlight Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Revenue', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                        Text('₹25,00,000', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    Container(width: 1, height: 30, color: const Color(0xFF334155)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Expenses', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                        Text('₹16,00,000', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFFFCA5A5))),
                      ],
                    ),
                    Container(width: 1, height: 30, color: const Color(0xFF334155)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Net Profit (36%)', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6EE7B7))),
                        Text('₹9,00,000', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF34D399))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 6,
                    child: Row(
                      children: [
                        Expanded(flex: 64, child: Container(color: const Color(0xFFEF4444))),
                        Expanded(flex: 36, child: Container(color: const Color(0xFF10B981))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('64% Expenses Ratio', style: GoogleFonts.inter(fontSize: 9.5, color: const Color(0xFF94A3B8))),
                    Text('36% Net Profit Margin', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.bold, color: const Color(0xFF34D399))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Text('Expense Breakdown (₹16,00,000 Total)', style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFF475569))),
          const SizedBox(height: 10),

          // Expense category visual bars
          ...expenses.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(e['icon'] as IconData, size: 14, color: e['color'] as Color),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            e['category'],
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
                          ),
                        ),
                        Text(
                          e['amount'],
                          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: e['percent'] as double,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFF1F5F9),
                        color: e['color'] as Color,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // --- SECTION 3: Court Utilization Cards ---
  Widget _buildCourtUtilizationCard(String filter) {
    final List<Map<String, dynamic>> courts = [
      {'name': 'Court 1', 'available': 300, 'booked': 260, 'utilization': '87%', 'percent': 0.87, 'status': 'High Demand', 'color': const Color(0xFF10B981)},
      {'name': 'Court 2', 'available': 300, 'booked': 220, 'utilization': '73%', 'percent': 0.73, 'status': 'Optimal', 'color': const Color(0xFF3B82F6)},
      {'name': 'Court 3', 'available': 300, 'booked': 250, 'utilization': '83%', 'percent': 0.83, 'status': 'High Demand', 'color': const Color(0xFF10B981)},
      {'name': 'Court 4', 'available': 300, 'booked': 275, 'utilization': '92%', 'percent': 0.92, 'status': '🔥 Peak Capacity', 'color': const Color(0xFFFF4C00)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Badminton Court Utilization',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      '⚡ Critical Operation Matrix for DUSA',
                      style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showInfoDialog(
                  title: 'Badminton Court Utilization',
                  explanation: 'Tracks total available operating hours vs actual booked playing hours across all 4 synthetic courts.',
                  calculation: 'Utilization = Booked Hours ÷ Available Hours (300 hrs/month/court).',
                  recommendation: 'Court 4 is at 92% peak capacity; consider shifting peak evening rates to balance load to Court 2 (73%).',
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.08), shape: BoxShape.circle),
                  child: const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFFF4C00)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Court visual cards list
          ...courts.map((c) {
            final Color themeColor = c['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: themeColor.withOpacity(0.12), shape: BoxShape.circle),
                            child: Icon(Icons.sports_tennis, size: 16, color: themeColor),
                          ),
                          const SizedBox(width: 8),
                          Text(c['name'], style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(c['status'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: themeColor)),
                          ),
                          const SizedBox(width: 8),
                          Text(c['utilization'], style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: c['percent'] as double,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFE2E8F0),
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Available: ${c['available']} hrs/mo', style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B))),
                      Text('Booked: ${c['booked']} hrs', style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.bold, color: const Color(0xFF334155))),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- SECTION 4: Facility Occupancy Cards ---
  Widget _buildFacilityOccupancyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Facility Occupancy',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              InkWell(
                onTap: () => _showInfoDialog(
                  title: 'Facility Occupancy',
                  explanation: 'Monitors member traffic in non-court amenities including the Olympic-size Swimming Pool and Evost Gym area.',
                  calculation: 'Check-in scans logged via member QR codes at entry turnstiles.',
                  recommendation: 'Schedule extra fitness trainers during peak gym hours (6 AM - 9 AM & 5 PM - 9 PM).',
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.08), shape: BoxShape.circle),
                  child: const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFFF4C00)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Swimming Pool Usage Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Color(0xFF0284C7), shape: BoxShape.circle),
                      child: const Icon(Icons.pool_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Swimming Pool Usage', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          const SizedBox(height: 2),
                          Text('312 / 400 Available Hours Booked', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('78%', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFF0284C7).withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                          child: Text('Optimal', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.bold, color: const Color(0xFF0369A1))),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.78,
                    minHeight: 6,
                    backgroundColor: Color(0xFFE0F2FE),
                    color: Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Gym Usage Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF2F8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFBCFE8)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Color(0xFFDB2777), shape: BoxShape.circle),
                      child: const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gym Usage', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          const SizedBox(height: 2),
                          Text('Peak: 6:00-9:00 AM & 5:00-9:00 PM', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('85%', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFFDB2777))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFDB2777).withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                          child: Text('High Demand', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.bold, color: const Color(0xFFBE185D))),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.85,
                    minHeight: 6,
                    backgroundColor: Color(0xFFFCE7F3),
                    color: Color(0xFFDB2777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: Events & Banners Manager ---
  Widget _buildEventsTab(BookingProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 📢 APP HERO PROMOTIONAL BANNERS SECTION
          _buildLightSectionCard(
            title: '📢 App Promotional Banners',
            subtitle: 'Manage live home screen carousel banners',
            infoTitle: 'Hero Banner Management',
            infoExplanation: 'Controls which promotional images and offer banners appear on the member app home screen.',
            infoCalculation: 'Active Banners Count.',
            infoRecommendation: 'Keep 2-3 active banners for maximum engagement.',
            child: Column(
              children: _heroBanners.map((b) {
                final bool isActive = b['status'] == 'ACTIVE';
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                                  child: Text(b['category'], style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                                ),
                                const SizedBox(width: 6),
                                Flexible(child: Text(b['title'], style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(b['subtitle'], style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Switch(
                        value: isActive,
                        activeColor: const Color(0xFFFF4C00),
                        onChanged: (val) {
                          setState(() {
                            b['status'] = val ? 'ACTIVE' : 'DRAFT';
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 📅 SCHEDULE NEW TOURNAMENT / EVENT FORM
          _buildLightSectionCard(
            title: '📅 Schedule New Tournament / Event',
            subtitle: 'Publish new sports events directly to DUSA members',
            infoTitle: 'Schedule Event Form',
            infoExplanation: 'Allows admin to publish new tournaments, leagues, or fitness masterclasses.',
            infoCalculation: 'Event Registration Pipeline.',
            infoRecommendation: 'Upload a custom tournament poster image to increase signups.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputLabel('Event / Tournament Title'),
                const SizedBox(height: 4),
                _buildTextField(_eventTitleController, 'e.g. DUSA Summer Squash League 2026'),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel('Entry Fee'),
                          const SizedBox(height: 4),
                          _buildTextField(_eventFeeController, 'e.g. ₹500'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel('Max Slots'),
                          const SizedBox(height: 4),
                          _buildTextField(_eventSlotsController, 'e.g. 64'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 🖼️ UPLOAD EVENT POSTER IMAGE BUTTON
                InkWell(
                  onTap: () {
                    setState(() {
                      _uploadedPosterName = 'Tournament_Banner_Graphic.png';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Poster Image Selected! 🖼️'), backgroundColor: Color(0xFF10B981)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_photo_alternate_outlined, color: Color(0xFFFF4C00), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _uploadedPosterName != null ? 'Poster Selected: $_uploadedPosterName ✓' : 'Upload Event Poster / Banner Image 🖼️',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: _uploadedPosterName != null ? const Color(0xFF10B981) : const Color(0xFF334155)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Publish Event Button
                ElevatedButton.icon(
                  onPressed: () {
                    if (_eventTitleController.text.trim().isEmpty) return;
                    setState(() {
                      _scheduledEvents.add({
                        'title': _eventTitleController.text,
                        'date': '28 Aug 2026',
                        'sport': _selectedEventSport,
                        'fee': _eventFeeController.text.isEmpty ? 'Free' : _eventFeeController.text,
                        'slots': '0 / ${_eventSlotsController.text.isEmpty ? "30" : _eventSlotsController.text} Registered',
                        'poster': _uploadedPosterName ?? 'Default_Banner.png',
                      });
                      _eventTitleController.clear();
                      _eventFeeController.clear();
                      _eventSlotsController.clear();
                      _uploadedPosterName = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New Event Published to App! 🚀'), backgroundColor: Color(0xFFFF4C00)));
                  },
                  icon: const Icon(Icons.publish_rounded, size: 16),
                  label: const Text('PUBLISH EVENT TO APP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4C00),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scheduled Events List
          Text('Scheduled Upcoming Events (${_scheduledEvents.length})', style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          const SizedBox(height: 8),

          ..._scheduledEvents.map((ev) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.image_outlined, size: 14, color: Color(0xFFFF4C00)),
                              const SizedBox(width: 4),
                              Flexible(child: Text(ev['title'], style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          Text('${ev['date']} • Fee: ${ev['fee']}', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(ev['slots'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- TAB 3: Coaches (UPGRADED TOP PERFORMERS SPOTLIGHT) ---
  Widget _buildCoachesTab(BookingProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🏆 UPGRADED TOP PERFORMING COACHES SPOTLIGHT CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF97316).withOpacity(0.4)),
              boxShadow: [BoxShadow(color: const Color(0xFFF97316).withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events_rounded, color: Color(0xFFEA580C), size: 24),
                        const SizedBox(width: 8),
                        Text('TOP PERFORMING COACHES', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF9A3412))),
                      ],
                    ),
                    InkWell(
                      onTap: () => _showInfoDialog(
                        title: 'Top Coaches Spotlight',
                        explanation: 'Ranks DUSA instructors by student ratings, retention, and monthly training hours.',
                        calculation: 'Rating × 50% + Training Hours × 50%.',
                        recommendation: 'Top ranked coaches lead our premium weekend coaching clinics.',
                      ),
                      child: const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFEA580C)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Top 3 Podium Cards Row
                Row(
                  children: _coaches.take(3).map((c) {
                    final String badge = c['badge'] as String;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFED7AA)),
                        ),
                        child: Column(
                          children: [
                            Text(badge.substring(0, 2), style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 2),
                            Text(
                              (c['name'] as String).replaceFirst('Coach ', '').replaceFirst('Trainer ', ''),
                              style: GoogleFonts.outfit(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('${c['rating']} ★', style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.bold, color: const Color(0xFFD97706))),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('DUSA Certified Coach Roster', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _coaches.length,
            itemBuilder: (context, index) {
              final coach = _coaches[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFFF4C00).withOpacity(0.12),
                    child: Text((coach['name'] as String).substring(6, 7), style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                  ),
                  title: Text(coach['name'], style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  subtitle: Text('${coach['role']} • ${coach['students']} Students', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('${coach['rating']} ★', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                    ],
                  ),
                  onTap: () => _showCoachDetailsModal(coach),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- TAB 4: Café & Orders Pipeline ---
  Widget _buildCafeTab(BookingProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLightSectionCard(
            title: '🥤 Aadukalam Café Sales & Kitchen Orders',
            subtitle: 'Real-time order dispatch and item analytics',
            infoTitle: 'Café Sales & KDS',
            infoExplanation: 'Manages live pre-orders placed by athletes.',
            infoCalculation: 'Sum of items ordered.',
            infoRecommendation: 'Smoothie orders peak between 7:00 PM and 8:30 PM.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildModalStat('Today\'s Revenue', '₹23,600', const Color(0xFFF59E0B)),
                    Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),
                    _buildModalStat('Orders Placed', '42 Orders', const Color(0xFF3B82F6)),
                    Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),
                    _buildModalStat('Top Seller', 'Whey Shake', const Color(0xFFFF4C00)),
                  ],
                ),
                const SizedBox(height: 14),

                Text('Top Selling Dishes Today:', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                const SizedBox(height: 6),
                _buildTopDishItem('1. Whey Protein Shake (Choco)', '18 Ordered • ₹2,160 Revenue', 0.9),
                const SizedBox(height: 6),
                _buildTopDishItem('2. Berry Hydration Smoothie', '12 Ordered • ₹1,140 Revenue', 0.65),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('Live Kitchen Order Pipeline (KDS)', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          const SizedBox(height: 10),

          _buildKdsOrderCard('ORD-8942', 'Priya Sharma (Badminton Court 2)', ['1x Whey Protein Shake (Choco)', '1x Fruit Oatmeal Bowl'], '06:45 PM', 'PREPARING', const Color(0xFFF59E0B)),
          _buildKdsOrderCard('ORD-8943', 'Karthik Raja (Gym Floor)', ['2x Berry Hydration Smoothie'], '07:00 PM', 'RECEIVED', const Color(0xFF3B82F6)),
          _buildKdsOrderCard('ORD-8940', 'Siddharth M.', ['1x Grilled Chicken Salad'], '06:30 PM', 'READY FOR PICKUP', const Color(0xFF10B981)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildKdsOrderCard(String orderId, String customer, List<String> items, String pickupTime, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: statusColor.withOpacity(0.4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(orderId, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.bold, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(customer, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          Text('Pickup Time: $pickupTime', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
          const SizedBox(height: 8),
          ...items.map((it) => Text('• $it', style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF334155)))),
        ],
      ),
    );
  }

  // --- TAB 5: Admin Profile & Switcher ---
  Widget _buildAdminProfileTab(BookingProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFFF4C00).withOpacity(0.2),
                  child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFFFF4C00), size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DUSA Super Admin', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('admin@dusasports.com • Operations Control', style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ⚡ SWITCH TO MEMBER APP BANNER CARD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.5), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Switch to Member App', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      Text('Return to player view & court booking interface', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                    ],
                  ),
                ),
                Switch(
                  value: provider.isAdminMode,
                  activeColor: const Color(0xFFFF4C00),
                  onChanged: (val) {
                    provider.toggleAdminMode();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Switched to Member View 👋'), backgroundColor: Color(0xFFFF4C00), duration: Duration(seconds: 2)));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildEqualMetricCard(String title, String mainValue, String subtext, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF64748B))),
              const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF94A3B8)),
            ],
          ),
          const SizedBox(height: 4),
          Text(mainValue, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          const SizedBox(height: 2),
          Text(subtext, style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.bold, color: accentColor)),
        ],
      ),
    );
  }

  Widget _buildLightSectionCard({
    required String title,
    required String subtitle,
    required String infoTitle,
    required String infoExplanation,
    required String infoCalculation,
    required String infoRecommendation,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)))),
              InkWell(
                onTap: () => _showInfoDialog(title: infoTitle, explanation: infoExplanation, calculation: infoCalculation, recommendation: infoRecommendation),
                child: const Icon(Icons.info_outline_rounded, size: 17, color: Color(0xFFFF4C00)),
              ),
            ],
          ),
          Text(subtitle, style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B))),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildLightRevenueBar(String category, String amount, double ratio, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF334155))),
            Text(amount, style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: ratio, minHeight: 5, backgroundColor: const Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(color)),
        ),
      ],
    );
  }

  Widget _buildTopDishItem(String dishName, String stats, double ratio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dishName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
            Text(stats, style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B))),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: ratio, minHeight: 5, backgroundColor: const Color(0xFFE2E8F0), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B))),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF475569)));
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF94A3B8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFF4C00))),
      ),
    );
  }
}
