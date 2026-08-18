import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DusaPlayScreen extends StatefulWidget {
  const DusaPlayScreen({super.key});

  @override
  State<DusaPlayScreen> createState() => _DusaPlayScreenState();
}

class _DusaPlayScreenState extends State<DusaPlayScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Matchmaking Search State
  String _selectedSport = 'Badminton';
  String _selectedSkill = 'Intermediate';
  bool _isSearchingPartners = false;
  List<Map<String, dynamic>>? _searchResults;

  // Photo Finder State
  bool _isScanning = false;
  bool _scanComplete = false;

  // Form Controllers for "Post Match Request"
  final _requestCourtController = TextEditingController(text: 'Court 2 (Wooden)');
  final _requestTimeController = TextEditingController(text: 'Today @ 07:00 PM');
  String _requestPlayersNeeded = 'Need 1 Player (+1)';
  String _requestSkillLevel = 'Intermediate';

  // Sample Partners Data
  final List<Map<String, dynamic>> _simulatedPartners = [
    {'name': 'Arun Kumar', 'sport': 'Badminton', 'skill': 'Intermediate', 'preferredTime': '06:00 PM', 'rating': '4.8 ★', 'winRate': '68%', 'gamesPlayed': 42},
    {'name': 'Ramesh Raj', 'sport': 'Badminton', 'skill': 'Intermediate', 'preferredTime': '07:00 PM', 'rating': '4.9 ★', 'winRate': '74%', 'gamesPlayed': 58},
    {'name': 'Sanjay Singh', 'sport': 'Pickleball', 'skill': 'Beginner', 'preferredTime': '08:00 AM', 'rating': '4.2 ★', 'winRate': '50%', 'gamesPlayed': 12},
    {'name': 'Divya Sundar', 'sport': 'Badminton', 'skill': 'Advanced', 'preferredTime': '05:00 PM', 'rating': '4.8 ★', 'winRate': '82%', 'gamesPlayed': 95},
    {'name': 'Vikram Prabhu', 'sport': 'Pickleball', 'skill': 'Intermediate', 'preferredTime': '06:00 PM', 'rating': '4.5 ★', 'winRate': '60%', 'gamesPlayed': 28},
  ];

  // Sample "Match Requests" Lobbies (with Host Accept/Decline workflow)
  final List<Map<String, dynamic>> _matchLobbies = [
    {
      'id': 'LOB-101',
      'host': 'Ramesh & Team',
      'isMyPost': false,
      'sport': 'Badminton Doubles',
      'court': 'Court 2 (Wooden)',
      'time': 'Today @ 07:00 PM',
      'playersCount': '3 / 4 Players Ready',
      'needed': 'Need 1 More Player! ⚡',
      'skill': 'Intermediate',
      'requestSent': false,
    },
    {
      'id': 'LOB-102',
      'host': 'Priya & Santhosh',
      'isMyPost': false,
      'sport': 'Badminton Doubles',
      'court': 'Court 4 (Wooden)',
      'time': 'Tomorrow @ 06:00 AM',
      'playersCount': '2 / 4 Players Ready',
      'needed': 'Need 2 More Players! ⚡',
      'skill': 'Open to All',
      'requestSent': false,
    },
  ];

  // Incoming Requests for My Hosted Posts
  final List<Map<String, dynamic>> _myPostRequests = [
    {
      'applicantName': 'Anand Viswanathan',
      'rating': '4.9 ★',
      'winRate': '76%',
      'skill': 'Intermediate',
      'timeApplied': '5 mins ago',
      'status': 'PENDING',
    },
    {
      'applicantName': 'Karthik Raja',
      'rating': '4.6 ★',
      'winRate': '64%',
      'skill': 'Intermediate',
      'timeApplied': '12 mins ago',
      'status': 'PENDING',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _requestCourtController.dispose();
    _requestTimeController.dispose();
    super.dispose();
  }

  void _searchOpponents() {
    setState(() {
      _isSearchingPartners = true;
      _searchResults = null;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
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
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _scanComplete = true;
        });
      }
    });
  }

  // --- "Post Match Request" Modal ---
  void _showPostMatchRequestDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.12), shape: BoxShape.circle),
                  child: const Icon(Icons.post_add_rounded, color: Color(0xFFFF4C00), size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create Match Post', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      Text('Players will send requests to join your court', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                    ],
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('Booked Court Location'),
                  const SizedBox(height: 4),
                  _buildTextField(_requestCourtController, 'e.g. Court 2 (Wooden)'),
                  const SizedBox(height: 10),

                  _buildInputLabel('Court Date & Slot Time'),
                  const SizedBox(height: 4),
                  _buildTextField(_requestTimeController, 'e.g. Today @ 07:00 PM'),
                  const SizedBox(height: 10),

                  _buildInputLabel('How many players do you need?'),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _requestPlayersNeeded,
                    dropdownColor: Colors.white,
                    decoration: _inputDecoration(),
                    style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
                    items: ['Need 1 Player (+1)', 'Need 2 Players (+2)'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => _requestPlayersNeeded = val);
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildInputLabel('Preferred Skill Level'),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _requestSkillLevel,
                    dropdownColor: Colors.white,
                    decoration: _inputDecoration(),
                    style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
                    items: ['Open to All', 'Beginner', 'Intermediate', 'Advanced'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => _requestSkillLevel = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFF64748B))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4C00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    _matchLobbies.insert(0, {
                      'id': 'LOB-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
                      'host': 'My Hosted Court',
                      'isMyPost': true,
                      'sport': 'Badminton Doubles',
                      'court': _requestCourtController.text,
                      'time': _requestTimeController.text,
                      'playersCount': _requestPlayersNeeded.contains('1') ? '3 / 4 Players Ready' : '2 / 4 Players Ready',
                      'needed': _requestPlayersNeeded,
                      'skill': _requestSkillLevel,
                      'requestSent': false,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Match Post Created! Other players can now send join requests 🚀'), backgroundColor: Color(0xFFFF4C00)),
                  );
                },
                child: Text('Publish Post', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub-Navigation Tab Bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFFF4C00),
            indicatorWeight: 3,
            labelColor: const Color(0xFFFF4C00),
            unselectedLabelColor: const Color(0xFF64748B),
            labelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.inter(fontSize: 11.5),
            tabs: const [
              Tab(icon: Icon(Icons.people_outline_rounded, size: 19), text: 'Find Partners'),
              Tab(icon: Icon(Icons.group_add_outlined, size: 19), text: 'Match Requests'),
              Tab(icon: Icon(Icons.camera_enhance_outlined, size: 19), text: 'AI Photo Finder'),
            ],
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFindPartnersTab(),
              _buildMatchRequestsTab(),
              _buildAiPhotoFinderTab(),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 1: Find Playing Partners ---
  Widget _buildFindPartnersTab() {
    final partnersToDisplay = _searchResults ?? _simulatedPartners;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.handshake_rounded, color: Color(0xFFFF4C00), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DUSA Matchmaker', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('Connect with active members based on skill level & court slots', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filters Card (LIGHT DROPDOWN COLOR FIX)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel('Select Sport'),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: _selectedSport,
                            dropdownColor: Colors.white,
                            decoration: _inputDecoration(),
                            style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
                            items: ['Badminton', 'Pickleball', 'Swimming', 'Gym Workout'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedSport = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel('Skill Level'),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: _selectedSkill,
                            dropdownColor: Colors.white,
                            decoration: _inputDecoration(),
                            style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
                            items: ['Beginner', 'Intermediate', 'Advanced'].map((sk) => DropdownMenuItem(value: sk, child: Text(sk))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedSkill = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Search Button
                ElevatedButton.icon(
                  onPressed: _searchOpponents,
                  icon: _isSearchingPartners
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.search_rounded, size: 18),
                  label: Text(_isSearchingPartners ? 'SEARCHING MATCHES...' : 'FIND MATCHING PARTNERS'),
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

          // Partners Roster Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Partners (${partnersToDisplay.length})', style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              Text('Tap to challenge', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: partnersToDisplay.length,
            itemBuilder: (context, index) {
              final p = partnersToDisplay[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFFFF4C00).withOpacity(0.12),
                          child: Text((p['name'] as String).substring(0, 1), style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(p['name'], style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                                    child: Text(p['skill'], style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                                  ),
                                ],
                              ),
                              Text('Preferred Slot: ${p['preferredTime']} • ${p['gamesPlayed']} Matches Played', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Rating: ${p['rating']}', style: GoogleFonts.outfit(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFFD97706))),
                          Container(width: 1, height: 16, color: const Color(0xFFCBD5E1)),
                          Text('Win Rate: ${p['winRate']}', style: GoogleFonts.outfit(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invite & Challenge sent to ${p['name']}! 🏸'), backgroundColor: const Color(0xFFFF4C00)),
                        );
                      },
                      icon: const Icon(Icons.sports_tennis_rounded, size: 16),
                      label: const Text('INVITE TO MATCH'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4C00),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 38),
                        textStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- TAB 2: Match Requests (HOST ACCEPT / DECLINE WORKFLOW) ---
  Widget _buildMatchRequestsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner & Create Post Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF97316).withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFFEA580C), shape: BoxShape.circle),
                      child: const Icon(Icons.group_add_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Match Matchmaker & Requests', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF9A3412))),
                          Text('Create a match post when you need players. Review incoming join requests from members!', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFC2410C))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                ElevatedButton.icon(
                  onPressed: _showPostMatchRequestDialog,
                  icon: const Icon(Icons.post_add_rounded, size: 18),
                  label: const Text('+ CREATE NEW MATCH POST'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA580C),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 42),
                    textStyle: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 📩 HOST MANAGER: INCOMING JOIN REQUESTS ON MY POSTS
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.4), width: 1.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.mark_email_unread_rounded, color: Color(0xFFFF4C00), size: 18),
                        const SizedBox(width: 6),
                        Text('Incoming Join Requests (Your Post)', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                      child: Text('${_myPostRequests.where((r) => r['status'] == 'PENDING').length} Pending', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                    ),
                  ],
                ),
                Text('Review players requesting to join your Court 2 match today @ 7:00 PM', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                const SizedBox(height: 12),

                ..._myPostRequests.map((req) {
                  final String status = req['status'] as String;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFFFF4C00).withOpacity(0.12),
                                  child: Text((req['applicantName'] as String).substring(0, 1), style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(req['applicantName'], style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                                    Text('Rating: ${req['rating']} • Win Rate: ${req['winRate']}', style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B))),
                                  ],
                                ),
                              ],
                            ),
                            Text(req['timeApplied'], style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8))),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // ACCEPT / DECLINE ACTION BUTTONS
                        if (status == 'PENDING') ...[
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      req['status'] = 'DECLINED';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Declined ✕'), backgroundColor: Color(0xFFEF4444)));
                                  },
                                  icon: const Icon(Icons.close_rounded, size: 14, color: Color(0xFFEF4444)),
                                  label: const Text('DECLINE'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFEF4444),
                                    side: const BorderSide(color: Color(0xFFEF4444)),
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    textStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      req['status'] = 'ACCEPTED';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${req['applicantName']} Accepted into Match! 🎉'), backgroundColor: const Color(0xFF10B981)));
                                  },
                                  icon: const Icon(Icons.check_rounded, size: 14),
                                  label: const Text('ACCEPT ✓'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    textStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                            decoration: BoxDecoration(
                              color: status == 'ACCEPTED' ? const Color(0xFF10B981).withOpacity(0.12) : const Color(0xFFEF4444).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                status == 'ACCEPTED' ? 'ACCEPTED ✓ (Slot Reserved)' : 'DECLINED ✕',
                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: status == 'ACCEPTED' ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // OPEN MATCH POSTS FEED
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Open Match Posts (${_matchLobbies.length})', style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              Text('Send join request to host', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _matchLobbies.length,
            itemBuilder: (context, index) {
              final lobby = _matchLobbies[index];
              final bool isRequestSent = lobby['requestSent'] == true;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.sports_tennis_rounded, color: Color(0xFFFF4C00), size: 18),
                            const SizedBox(width: 6),
                            Text(lobby['sport'], style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                          child: Text(lobby['needed'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Host: ${lobby['host']} • ${lobby['court']}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                    Text('Slot: ${lobby['time']} • Skill: ${lobby['skill']}', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lobby['playersCount'], style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              lobby['requestSent'] = !isRequestSent;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(!isRequestSent ? 'Join Request Sent to Host (${lobby['host']})! 📩' : 'Join Request Cancelled'),
                                backgroundColor: const Color(0xFFFF4C00),
                              ),
                            );
                          },
                          icon: Icon(isRequestSent ? Icons.hourglass_top_rounded : Icons.send_rounded, size: 14),
                          label: Text(isRequestSent ? 'REQUEST PENDING ⏳' : 'REQUEST TO JOIN'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRequestSent ? const Color(0xFFF59E0B) : const Color(0xFFFF4C00),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- TAB 3: AI Photo Finder ---
  Widget _buildAiPhotoFinderTab() {
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFFF4C00).withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.center_focus_strong_rounded, color: Color(0xFFFF4C00), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DUSA AI Match Photo Finder', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('Upload a selfie to find all your tournament action shots', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Upload Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 40, color: Color(0xFFFF4C00)),
                const SizedBox(height: 10),
                Text('Upload Your Selfie', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                Text('AI will scan all DUSA match photography galleries', style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B))),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _startPhotoScan,
                  icon: _isScanning
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.face_retouching_natural_rounded, size: 18),
                  label: Text(_isScanning ? 'SCANNING GALLERY...' : 'START AI SCAN'),
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

          if (_scanComplete) ...[
            Text('Matched Photos Found (2 Action Shots):', style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/onboarding_badminton_hero.png', height: 140, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/onboarding_multisport_hero.png', height: 140, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildInputLabel(String label) {
    return Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF475569)));
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
      decoration: _inputDecoration(hint: hint),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF94A3B8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFF4C00))),
    );
  }
}
