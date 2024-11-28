import 'package:allgames/utils/size_config.dart';
import 'package:flutter/material.dart';

class WithdrawalMethodScreen extends StatefulWidget {
  const WithdrawalMethodScreen({Key? key}) : super(key: key);

  @override
  _WithdrawalMethodScreenState createState() => _WithdrawalMethodScreenState();
}

class _WithdrawalMethodScreenState extends State<WithdrawalMethodScreen> {
  String selectedMethod = 'UPI';
  final TextEditingController upiController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController beneficiaryController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  String? selectedBank;

  final List<String> banks = [
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    // Add more banks as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: showWithdrawalSummarySheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F3660),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Withdraw',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF1E1E2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/home/back_home1.png',
                      width: 44,
                    ),
                  ),
                  SizedBox(width: 22.w),
                  Center(
                    child: const Text(
                      'Withdrawal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'PoetsenOne-Regular',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Amount Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Quantity',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '₹50',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Withdrawal Method Selection
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xff24202E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Withdrawal Method',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    // Radio Options
                    Row(
                      children: [
                        Radio(
                          value: 'UPI',
                          groupValue: selectedMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedMethod = value.toString();
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        const Text('UPI',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'Bank Account',
                          groupValue: selectedMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedMethod = value.toString();
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        const Text('Bank Account',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Conditional Form Fields
                    if (selectedMethod == 'UPI') ...[
                      const Text('UPI ID',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextField(
                          controller: upiController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter UPI ID',
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                            filled: true,
                            fillColor: Color(0xff3F3660),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(Icons.content_paste,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Bank Account Fields
                      const Text('Bank Name',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: DropdownButtonFormField<String>(
                          value: selectedBank,
                          dropdownColor: const Color(0xFF2E2E3E),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            fillColor: Color(0xff3F3660),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: banks.map((String bank) {
                            return DropdownMenuItem(
                              value: bank,
                              child: Text(bank),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBank = newValue;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      _buildTextField('Branch Name', branchController),
                      _buildTextField(
                          'Beneficiary Name', beneficiaryController),
                      _buildTextField('Account Number', accountController),
                      _buildTextField('IFSC Code', ifscController),
                    ],
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void showWithdrawalSummarySheet() {
    // Create a local variable to track selection within bottom sheet
    String summarySelection = 'Auto'; // Default value

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Add StatefulBuilder here
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Withdrawal Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Auto option
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F1F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RadioListTile(
                      title: const Text('Auto'),
                      value: 'Auto',
                      groupValue: summarySelection,
                      onChanged: (value) {
                        setState(() {
                          summarySelection = value.toString();
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Manual option
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F1F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RadioListTile(
                      title: const Text('Manual'),
                      value: 'Manual',
                      groupValue: summarySelection,
                      onChanged: (value) {
                        setState(() {
                          summarySelection = value.toString();
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // OK Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                        showWithdrawalDetailsDialog(); // Show the details dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F3660),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showWithdrawalDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Center(
                  child: Text(
                    'Withdrawal Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Details Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F1F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [],
                      ),
                      // Withdrawal Amount
                      const Text(
                        'Withdrawal Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        '250.00',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Priority
                      const Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        'High',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Withdraw to
                      const Text(
                        'Withdraw to',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        'abc@oksbi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date & Time
                      const Text(
                        'Date & Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        '24 - 01- 2024 11:11:11',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F3660),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            fillColor: Color(0xff3F3660),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
