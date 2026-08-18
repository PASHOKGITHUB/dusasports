import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../main.dart';

class DusaPlayScreen extends StatefulWidget {
  const DusaPlayScreen({super.key});

  @override
  State<DusaPlayScreen> createState() => _DusaPlayScreenState();
}

class _DusaPlayScreenState extends State<DusaPlayScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Matchmaking State
  String _selectedSport = 'Badminton';
  String _selectedSkill = 'Intermediate';
  bool _isSearchingPartners = false;
  List<Map<String, dynamic>>? _searchResults;

  // Photo Finder State
  bool _isScanning = false;
  bool _scanComplete = false;
  String _scanStatus = 'Idle';

  final List<Map<String, dynamic>> _simulatedPartners = [
    {'name': 'Arun Kumar', 'sport': 'Badminton', 'skill': 'Intermediate', 'preferredTime': '6:00 PM', 'rating': '4.1/5'},
    {'name': 'Ramesh Raj', 'sport': 'Badminton', 'skill': 'Intermediate', 'preferredTime': '7:00 PM', 'rating': '4.3/5'},
    {'name': 'Sanjay Singh', 'sport': 'Pickleball', 'skill': 'Beginner', 'preferredTime': '8:00 AM', 'rating': '3.8/5'},
    {'name': 'Divya Sundar', 'sport': 'Badminton', 'skill': 'Advanced', 'preferredTime': '5:00 PM', 'rating': '4.8/5'},
    {'name': 'Vikram Prabhu', 'sport': 'Pickleball', 'skill': 'Intermediate', 'preferredTime': '6:00 PM', 'rating': '4.2/5'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _searchOpponents() {
    setState(() {
      _isSearchingPartners = true;
      _searchResults = null;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isSearchingPartners = false;
          _searchResults = _simulatedPartners
              .where((p) => p['sport'] == _selectedSport && p['skill'] == _selectedSkill)
              .toList();
        });
      }
    });
  }

  void _startPhotoScan() {
    setState(() {
      _isScanning = true;
      _scanComplete = false;
      _scanStatus = 'Uploading Selfie...';
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _scanStatus = 'AI Analysis & Feature Matching...';
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _scanComplete = true;
          _scanStatus = 'Matching Complete!';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFFF4C00),
            indicatorWeight: 3,
            labelColor: const Color(0xFFFF4C00),
            unselectedLabelColor: const Color(0xFF64748B),
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: 'DUSA Play Lobby', icon: Icon(Icons.sports_esports_outlined, size: 18)),
              Tab(text: 'Smart Photo Finder', icon: Icon(Icons.camera_alt_outlined, size: 18)),
            ],
          ),
        ),

        // Tab views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPlayLobbyTab(),
              _buildPhotoFinderTab(),
            ],
          ),
        ),
      ],
    );
  }

  // --- DUSA Play Lobby Tab ---
  Widget _buildPlayLobbyTab() {
    final provider = Provider.of<BookingProvider>(context, listen: false);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Matchmaking Config Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Find Playing Partners',
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                ),
                Text(
                  'Match with other DUSA players based on your game choices.',
                  style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                
                 _buildToggleChips(
                   label: 'Select Sport',
                   options: ['Badminton', 'Pickleball'],
                   selectedValue: _selectedSport,
                   onSelected: (val) => setState(() => _selectedSport = val),
                 ),
                 const SizedBox(height: 16),
                 const Divider(color: Color(0xFFE2E8F0)),
                 const SizedBox(height: 12),
                 
                 _buildToggleChips(
                   label: 'Skill Level',
                   options: ['Beginner', 'Intermediate', 'Advanced'],
                   selectedValue: _selectedSkill,
                   onSelected: (val) => setState(() => _selectedSkill = val),
                 ),
                 const SizedBox(height: 24),
                
                ShadButton(
                  backgroundColor: const Color(0xFFFF4C00),
                  hoverBackgroundColor: const Color(0xFFE04300),
                  onPressed: _searchOpponents,
                  child: _isSearchingPartners
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Search Players', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // Search Results
          if (_searchResults != null) ...[
            Text(
              'Available Partners Found (${_searchResults!.length})',
              style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),
            if (_searchResults!.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Center(
                  child: Text('No players active for these filters right now.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResults!.length,
                itemBuilder: (context, index) {
                  final p = _searchResults![index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF4C00).withOpacity(0.03),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.015),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['name'],
                              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rating: ${p['rating']} • Prefers: ${p['preferredTime']}',
                              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        ShadButton.outline(
                          onPressed: () {
                            provider.incrementBadmintonStreak();
                            ShadToaster.of(context).show(
                              ShadToast(
                                title: const Text('Challenge Sent!'),
                                description: Text('Invitation sent to ${p['name']}. Match pending.'),
                              ),
                            );
                          },
                          child: Text('Challenge', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],

          const SizedBox(height: 24),

          // Academy Tournaments
          Text(
            'Academy Tournament Tracker',
            style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          
          _buildTournamentCard(
            title: 'DUSA Independence Badminton Cup 2026',
            status: 'Ongoing Match Schedule',
            date: 'Aug 15 - Aug 18, 2026',
            bracketInfo: 'Men\'s Singles • Semi-finals scheduled',
          ),
          const SizedBox(height: 12),
          _buildTournamentCard(
            title: 'Madurai Open Pickleball Blitz',
            status: 'Registration Open',
            date: 'Sep 05, 2026',
            bracketInfo: 'Mixed Doubles • Cash prize of ₹20,000',
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard({
    required String title,
    required String status,
    required String date,
    required String bracketInfo,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4C00).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                ),
              ),
              Text(
                date,
                style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          Text(
            bracketInfo,
            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  ShadToaster.of(context).show(
                    const ShadToast(
                      title: Text('Draw Bracket loaded'),
                      description: Text('Redirecting to the official tournament chart sheets.'),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text('View Brackets', style: GoogleFonts.outfit(fontSize: 11, color: const Color(0xFFFF4C00), fontWeight: FontWeight.bold)),
                    const Icon(Icons.chevron_right, size: 14, color: Color(0xFFFF4C00)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Smart Photo Finder Tab ---
  Widget _buildPhotoFinderTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.face_retouching_natural, color: Color(0xFFFF4C00), size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'AI Face Match Photos',
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'We capture your best action moments during DUSA tournament leagues. Simply upload a selfie, and our AI scanner will instantly locate all photos of you across our database—100% free and secure.',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Upload Box Simulator
          if (!_isScanning && !_scanComplete) ...[
            InkWell(
              onTap: _startPhotoScan,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4C00).withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Color(0xFFFF4C00), size: 28),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to Take or Upload Selfie',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'JPG or PNG format • AI deletes photo after search',
                      style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Scanning Animation State
          if (_isScanning) ...[
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFFF4C00), width: 2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(Icons.face_unlock_outlined, size: 40, color: Color(0xFFFF4C00)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _scanStatus,
                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Matches Found State
          if (_scanComplete) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Color(0xFF16A34A)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'AI matching complete! 3 matches discovered.',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF16A34A)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Photo Result Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
              children: [
                _buildPhotoResultCard('Action smash slot', 'Independence Cup', 'Court 1'),
                _buildPhotoResultCard('Trophy award photo', 'Independence Cup', 'Podium'),
                _buildPhotoResultCard('Team lobby post-game', 'Weekend Leagues', 'Lounge Area'),
              ],
            ),
            const SizedBox(height: 20),
            
            ShadButton.outline(
              onPressed: () {
                setState(() {
                  _scanComplete = false;
                });
              },
              child: Text(
                'Upload Different Selfie',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoResultCard(String eventName, String tournament, String locationText) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mock photo box
          Expanded(
            child: Container(
              color: const Color(0xFFF1F5F9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.image, size: 28, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 4),
                    Text(
                      locationText,
                      style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF64748B), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  tournament,
                  style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF64748B)),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 24,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4C00),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      ShadToaster.of(context).show(
                        const ShadToast(
                          title: Text('Saving photo...'),
                          description: Text('Photo saving to gallery storage in HD.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download, size: 10, color: Colors.white),
                    label: Text('Download', style: GoogleFonts.outfit(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChips({
    required String label,
    required List<String> options,
    required String selectedValue,
    required void Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((opt) {
            final isSelected = opt == selectedValue;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onSelected(opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFF4C00).withOpacity(0.08) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFFE2E8F0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
