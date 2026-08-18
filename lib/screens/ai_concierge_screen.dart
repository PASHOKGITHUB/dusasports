import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../main.dart';

class AiConciergeScreen extends StatefulWidget {
  const AiConciergeScreen({super.key});

  @override
  State<AiConciergeScreen> createState() => _AiConciergeScreenState();
}

class _AiConciergeScreenState extends State<AiConciergeScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  bool _isThinking = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(String text, BookingProvider provider) {
    if (text.trim().isEmpty) return;
    
    provider.sendMessage(text);
    _chatController.clear();
    setState(() {
      _isThinking = true;
    });
    _scrollToBottom();
    
    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) {
        setState(() {
          _isThinking = false;
        });
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    return Column(
      children: [
        // AI header banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4C00).withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFF4C00)),
                    ),
                    child: const Icon(Icons.android, size: 20, color: Color(0xFFFF4C00)),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DUSA AI Concierge',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                    ),
                    Text(
                      'Ask details in English & Tamil',
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Chat Bubble Area
        Expanded(
          child: Container(
            color: const Color(0xFFF8FAFC),
            child: ListView.builder(
              controller: _chatScrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: provider.chatMessages.length,
              itemBuilder: (context, index) {
                final msg = provider.chatMessages[index];
                final isUser = msg['sender'] == 'user';
                
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFFFF4C00) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                        bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                      ),
                      border: isUser ? null : Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    child: Text(
                      msg['text']!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isUser ? Colors.white : const Color(0xFF0F172A),
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Thinking Animation
        if (_isThinking)
          Container(
            color: const Color(0xFFF8FAFC),
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF4C00)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI is typing...',
                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B), fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),

        // Presets Chips Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildPresetChip('வணக்கம்', provider),
                _buildPresetChip('Gold Plan prices', provider),
                _buildPresetChip('Gym hours', provider),
                _buildPresetChip('Badminton coaching', provider),
                _buildPresetChip('Aadukalam Café menu', provider),
                _buildPresetChip('Sauna Recovery', provider),
              ],
            ),
          ),
        ),

        // Input Box
        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ShadInput(
                    controller: _chatController,
                    placeholder: const Text('Type your query here...'),
                    style: GoogleFonts.inter(fontSize: 13.5, color: const Color(0xFF0F172A)),
                    onSubmitted: (val) => _handleSendMessage(val, provider),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4C00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(12),
                  ),
                  icon: const Icon(Icons.send, size: 18, color: Colors.white),
                  onPressed: () => _handleSendMessage(_chatController.text, provider),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChip(String text, BookingProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, bottom: 4),
      child: ActionChip(
        label: Text(text),
        backgroundColor: const Color(0xFFF8FAFC),
        labelStyle: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF475569)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        onPressed: () => _handleSendMessage(text, provider),
      ),
    );
  }
}
