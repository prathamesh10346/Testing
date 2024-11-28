import 'package:allgames/home/wallet/wallet_option.dart';
import 'package:allgames/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  String selectedAmount = '₹50';

  // Sample withdrawal history data
  final List<Map<String, String>> withdrawalHistory = List.generate(
    6,
    (index) => {
      'date': '24-12-2024 11:11:11',
      'amount': '₹250.00',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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

              // Amount Selection Text
              const Text(
                'Select Quantity',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              // Amount Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final amounts = [
                    '₹50',
                    '₹500',
                    '₹5000',
                    '₹10',
                    '₹500',
                    '₹5000',
                    '₹50',
                    '₹500',
                    '₹5000'
                  ];
                  return AmountButton(
                    amount: amounts[index % 3],
                    isSelected: selectedAmount == amounts[index % 3],
                    onTap: () {
                      setState(() {
                        selectedAmount = amounts[index % 3];
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Selected Amount Display
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Withdrawal Quantity',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white24),
                        ),
                      ),
                      child: Text(
                        selectedAmount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recent Withdrawals

              const Text(
                'Recent Withdrawal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'PoetsenOne-Regular',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: withdrawalHistory.length,
                  itemBuilder: (context, index) {
                    final history = withdrawalHistory[index];
                    return GestureDetector(
                      onTap: showWithdrawalDetailsDialog,
                      child: WithdrawalHistoryItem(
                        date: history['date']!,
                        amount: history['amount']!,
                      ),
                    );
                  },
                ),
              ),

              // Withdraw Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Withdrawal logic
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WithdrawalMethodScreen()));
                  },
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
            ],
          ),
        ),
      ),
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
}

// Amount Button Widget
class AmountButton extends StatelessWidget {
  final String amount;
  final bool isSelected;
  final VoidCallback onTap;

  const AmountButton({
    Key? key,
    required this.amount,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.white24,
          ),
        ),
        child: Text(
          amount,
          style: TextStyle(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
          ),
        ),
      ),
    );
  }
}

// Withdrawal History Item Widget
class WithdrawalHistoryItem extends StatelessWidget {
  final String date;
  final String amount;

  const WithdrawalHistoryItem({
    Key? key,
    required this.date,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            '-$amount',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
