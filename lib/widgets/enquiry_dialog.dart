import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class EnquiryDialog extends StatefulWidget {
  const EnquiryDialog({super.key});

  @override
  State<EnquiryDialog> createState() => _EnquiryDialogState();
}

class _EnquiryDialogState extends State<EnquiryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  String _selectedPlan = 'Gold';
  String _selectedSource = 'Choose...';
  bool _isSuccess = false;

  final List<String> _plans = [
    'Gold',
    'Platinum',
    'Couple',
    'Family',
    'Gym Package',
    'Badminton Court Booking',
    'Swimming Pool Pack',
    'Snooker Zone',
    'Table Tennis Booking',
    'Coaching Classes',
  ];

  final List<String> _sources = [
    'Choose...',
    'Social Media (Instagram/Facebook)',
    'Friends or Family Referral',
    'Walk-in / Direct Visit',
    'Google Search',
    'Flyer or Banner',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BookingProvider>(context, listen: false);
    _selectedPlan = provider.selectedPlan;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSource == 'Choose...') {
        ShadToaster.of(context).show(
          const ShadToast.destructive(
            title: Text('Validation Error'),
            description: Text('Please select a valid enquiry source.'),
          ),
        );
        return;
      }

      final provider = Provider.of<BookingProvider>(context, listen: false);
      provider.setPlan(_selectedPlan);
      provider.submitEnquiry(
        name: _nameController.text,
        mobile: _mobileController.text,
        email: _emailController.text,
        source: _selectedSource,
      );

      setState(() {
        _isSuccess = true;
      });
    }
  }

  String _getBannerImage() {
    final plan = _selectedPlan.toLowerCase();
    if (plan.contains('gym')) {
      return 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=350';
    } else if (plan.contains('badminton')) {
      return 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=350';
    } else if (plan.contains('swim')) {
      return 'https://images.unsplash.com/photo-1519315901367-f34ff9154487?q=80&w=350';
    } else if (plan.contains('snooker') || plan.contains('pool')) {
      return 'https://images.unsplash.com/photo-1544322492-23727f288b4b?q=80&w=350';
    } else if (plan.contains('tennis') || plan.contains('table')) {
      return 'https://images.unsplash.com/photo-1534067783941-51c9c23eccfd?q=80&w=350';
    } else {
      // Default membership image
      return 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?q=80&w=350';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    if (_isSuccess) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 32, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Enquiry Submitted!',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Hi ${_nameController.text}, we have received your enquiry for the $_selectedPlan plan. Our DUSA representative will contact you shortly.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF475569),
                  height: 1.4,
                ),
              ),
              if (provider.selectedCourtSlots.isNotEmpty) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attached Court Slots:',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF4C00),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...provider.selectedCourtSlots.map((slot) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text('• $slot', style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF334155))),
                      )),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ShadButton(
                  backgroundColor: const Color(0xFFFF4C00),
                  hoverBackgroundColor: const Color(0xFFE04300),
                  onPressed: () {
                    provider.clearSelectedSlots();
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dynamic Premium Header Banner Image
              Stack(
                children: [
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      image: DecorationImage(
                        image: NetworkImage(_getBannerImage()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      radius: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 16),
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DUSA Sports Academy',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF4C00),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Membership & Facility Enquiry',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Form content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selected Plan Input
                      Text(
                        'Select Interest Plan *',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ShadSelectFormField<String>(
                        id: 'selected_plan',
                        placeholder: const Text('Select plan'),
                        initialValue: _selectedPlan,
                        options: _plans.map((p) => ShadOption(value: p, child: Text(p))).toList(),
                        selectedOptionBuilder: (context, value) => Text(value),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedPlan = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),

                      // Name Input
                      Text(
                        'Full Name *',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        cursorColor: const Color(0xFFFF4C00),
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F172A)),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          hintText: 'Enter your name',
                          hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                          prefixIconConstraints: const BoxConstraints(minWidth: 40),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10, right: 4),
                            child: Icon(Icons.person_outline, size: 18, color: Color(0xFF64748B)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFF4C00), width: 1.5)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Mobile Input
                      Text(
                        'Mobile Number *',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _mobileController,
                        cursorColor: const Color(0xFFFF4C00),
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F172A)),
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(v.trim())) {
                            return 'Please enter a valid 10-digit number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          hintText: 'Enter 10-digit mobile number',
                          hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                          prefixIconConstraints: const BoxConstraints(minWidth: 40),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10, right: 4),
                            child: Icon(Icons.phone_outlined, size: 18, color: Color(0xFF64748B)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFF4C00), width: 1.5)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Email Input
                      Text(
                        'Email Address (Optional)',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: const Color(0xFFFF4C00),
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F172A)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                              return 'Please enter a valid email';
                            }
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          hintText: 'Enter your email address',
                          hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                          prefixIconConstraints: const BoxConstraints(minWidth: 40),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10, right: 4),
                            child: Icon(Icons.email_outlined, size: 18, color: Color(0xFF64748B)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFF4C00), width: 1.5)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Source Input
                      Text(
                        'How did you hear about us? *',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ShadSelectFormField<String>(
                        id: 'source',
                        placeholder: const Text('Choose...'),
                        initialValue: _selectedSource,
                        options: _sources.map((s) => ShadOption(value: s, child: Text(s))).toList(),
                        selectedOptionBuilder: (context, value) => Text(value),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedSource = val;
                            });
                          }
                        },
                      ),
                      
                      if (provider.selectedCourtSlots.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4C00).withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.15)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 15, color: Color(0xFFFF4C00)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${provider.selectedCourtSlots.length} Court Slot(s) Attached',
                                  style: GoogleFonts.inter(
                                    fontSize: 12, 
                                    fontWeight: FontWeight.bold, 
                                    color: const Color(0xFFFF4C00),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 20),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ShadButton(
                          backgroundColor: const Color(0xFFFF4C00),
                          hoverBackgroundColor: const Color(0xFFE04300),
                          onPressed: _handleSubmit,
                          child: Text(
                            'Submit Enquiry',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
