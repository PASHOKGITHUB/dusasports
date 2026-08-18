import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../main.dart';

class CheckoutPaymentDialog extends StatefulWidget {
  final String planName;
  final String duration;
  final int basePrice;
  final List<String> benefits;
  final bool cameFromPlansScreen;

  const CheckoutPaymentDialog({
    super.key,
    required this.planName,
    required this.duration,
    required this.basePrice,
    required this.benefits,
    this.cameFromPlansScreen = false,
  });

  @override
  State<CheckoutPaymentDialog> createState() => _CheckoutPaymentDialogState();
}

class _CheckoutPaymentDialogState extends State<CheckoutPaymentDialog> {
  int _currentStep = 1; // 1: Review, 2: Payment Method, 3: Processing, 4: Success
  String _selectedMethod = 'UPI'; // UPI, Card
  String _selectedUpiProvider = 'GPay'; // GPay, PhonePe
  final TextEditingController _upiIdController = TextEditingController();
  
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final _cardFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _upiIdController.text = 'dusa.academy@okaxis';
  }

  @override
  void dispose() {
    _upiIdController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _startPaymentProcess() {
    if (_selectedMethod == 'Card' && _currentStep == 2) {
      if (!_cardFormKey.currentState!.validate()) return;
    }

    setState(() {
      _currentStep = 3; // Processing loader
    });

    // Simulate Payment network delays
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        final provider = Provider.of<BookingProvider>(context, listen: false);
        // Commit purchase to state
        provider.purchaseMembership(
          plan: widget.planName,
          duration: widget.duration,
        );
        setState(() {
          _currentStep = 4; // Success
        });

        // Auto-navigate to home screen after displaying receipt details
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            Navigator.of(context).pop(); // Close checkout dialog
            if (widget.cameFromPlansScreen) {
              Navigator.of(context).pop(); // Close plans screen, returning back to home
            }
            
            ShadToaster.of(context).show(
              ShadToast(
                title: const Text('Subscription Active!'),
                description: Text('Welcome to the ${widget.planName} Club!'),
              ),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double gst = widget.basePrice * 0.18;
    final double totalAmount = widget.basePrice + gst;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              if (_currentStep < 4) _buildHeader(),

              Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildStepContent(totalAmount, gst),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Dark Midnight Navy
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Secure Checkout',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.lock, color: Color(0xFFFF4C00), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '256-bit SSL',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Steps Indicator
          Row(
            children: [
              _buildStepIndicator(1, 'Review'),
              _buildStepConnector(),
              _buildStepIndicator(2, 'Payment'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isDone = _currentStep > step;
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive 
                ? const Color(0xFFFF4C00) 
                : (isDone ? const Color(0xFF22C55E) : const Color(0xFF334155)),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : Text(
                    '$step',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.white : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector() {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: _currentStep > 1 ? const Color(0xFF22C55E) : const Color(0xFF334155),
      ),
    );
  }

  Widget _buildStepContent(double totalAmount, double gst) {
    switch (_currentStep) {
      case 1:
        return _buildReviewStep(totalAmount, gst);
      case 2:
        return _buildPaymentStep(totalAmount);
      case 3:
        return _buildProcessingStep();
      case 4:
        return _buildSuccessStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- STEP 1: REVIEW ---
  Widget _buildReviewStep(double total, double gstAmount) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Plan Summary
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4C00).withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.planName} Membership',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 2),
              Text(
                'Duration: ${widget.duration}',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Plan Benefits Title
        Text(
          'Included Benefits:',
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 8),

        // Plan Benefits List
        Column(
          children: widget.benefits.map((benefit) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 14, color: Color(0xFF22C55E)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit,
                      style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF475569)),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 12),

        // Pricing Summary
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Base Subscription Fee', style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF64748B))),
            Text('₹${widget.basePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A), fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('GST (18%)', style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF64748B))),
            Text('₹${gstAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A), fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Grand Total', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
            Text(
              '₹${total.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Proceed Button
        ShadButton(
          backgroundColor: const Color(0xFFFF4C00),
          hoverBackgroundColor: const Color(0xFFE04300),
          onPressed: () => setState(() => _currentStep = 2),
          child: Text('Proceed to Pay', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }

  // --- STEP 2: PAYMENT METHOD ---
  Widget _buildPaymentStep(double totalAmount) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Total Amount Banner
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Payable Amount:', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
            Text('₹${totalAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
          ],
        ),
        const SizedBox(height: 16),

        Text(
          'Select Payment Option:',
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        
        // Option 1: UPI Applications
        _buildPaymentOptionCard(
          method: 'UPI',
          title: 'UPI Applications (GPay, PhonePe)',
          icon: Icons.phone_android_rounded,
          child: _selectedMethod == 'UPI' ? Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _buildUpiBody(),
          ) : const SizedBox.shrink(),
        ),
        const SizedBox(height: 10),

        // Option 2: Credit/Debit Card
        _buildPaymentOptionCard(
          method: 'Card',
          title: 'Credit / Debit Card',
          icon: Icons.credit_card_rounded,
          child: _selectedMethod == 'Card' ? Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _buildCardBody(),
          ) : const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),

        // Action Row
        Row(
          children: [
            Expanded(
              child: ShadButton.outline(
                onPressed: () => setState(() => _currentStep = 1),
                child: Text('Back', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ShadButton(
                backgroundColor: const Color(0xFFFF4C00),
                hoverBackgroundColor: const Color(0xFFE04300),
                onPressed: _startPaymentProcess,
                child: Text('Pay Securely', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOptionCard({
    required String method,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final isSelected = _selectedMethod == method;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFFE2E8F0),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: const Color(0xFFFF4C00).withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedMethod = method),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFF94A3B8),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Icon(icon, color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFF64748B), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildUpiBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // GPay, PhonePe Toggles
        Row(
          children: [
            _buildUpiProviderChip('GPay', 'Google Pay'),
            const SizedBox(width: 8),
            _buildUpiProviderChip('PhonePe', 'PhonePe'),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'UPI ID / Virtual Payment Address',
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _upiIdController,
          cursorColor: const Color(0xFFFF4C00),
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F172A)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            hintText: 'e.g. name@okhdfcbank',
            hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFF4C00), width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildUpiProviderChip(String val, String label) {
    final isSelected = _selectedUpiProvider == val;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedUpiProvider = val;
            _upiIdController.text = val == 'GPay' ? 'dusa.academy@okaxis' : 'dusa.academy@ybl';
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF4C00).withOpacity(0.04) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF4C00).withOpacity(0.5) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFF475569),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBody() {
    return Form(
      key: _cardFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Card Number',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _cardNumberController,
            cursorColor: const Color(0xFFFF4C00),
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || v.trim().length < 16) ? 'Invalid Card Number' : null,
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F172A)),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              hintText: '4000 1234 5678 9010',
              hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFF4C00), width: 1.5)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expiry Date',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _expiryController,
                      cursorColor: const Color(0xFFFF4C00),
                      validator: (v) => (v == null || !v.contains('/')) ? 'Invalid' : null,
                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        hintText: 'MM/YY',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFF4C00), width: 1.5)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CVV',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _cvvController,
                      cursorColor: const Color(0xFFFF4C00),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.trim().length < 3) ? 'Invalid' : null,
                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        hintText: '•••',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFF4C00), width: 1.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- STEP 3: PROCESSING ---
  Widget _buildProcessingStep() {
    return Column(
      key: const ValueKey(3),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        const SizedBox(
          width: 45,
          height: 45,
          child: CircularProgressIndicator(
            color: Color(0xFFFF4C00),
            strokeWidth: 3.5,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Processing Payment...',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        Text(
          'Please do not close this window or hit back.',
          style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // --- STEP 4: SUCCESS ---
  Widget _buildSuccessStep() {
    final provider = Provider.of<BookingProvider>(context);

    return Column(
      key: const ValueKey(4),
      children: [
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFFDCFCE7),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            color: Color(0xFF22C55E),
            size: 38,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Payment Successful!',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome to the DUSA Sports Elite Club!',
          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF22C55E), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),

        // Member ID Details
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Member Name:', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                  Text(provider.profileName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Active Plan:', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                  Text('${widget.planName} (${widget.duration})', style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Member ID:', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                  Text(provider.memberId, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Finish button
        ShadButton(
          backgroundColor: const Color(0xFFFF4C00),
          hoverBackgroundColor: const Color(0xFFE04300),
          onPressed: () {
            Navigator.pop(context); // Close dialog
          },
          child: Text('Done', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }
}
