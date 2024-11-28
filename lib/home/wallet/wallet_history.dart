import 'package:flutter/material.dart';

class WalletHistoryScreen extends StatelessWidget {
  final List<WithdrawalHistoryItem> withdrawalHistory = [
    WithdrawalHistoryItem(
      date: '24-12-2024 11:11:11',
      amount: 250.00,
    ),
    WithdrawalHistoryItem(
      date: '24-12-2024 11:11:11',
      amount: 250.00,
    ),
    WithdrawalHistoryItem(
      date: '24-12-2024 11:11:11',
      amount: 250.00,
    ),
    // Add more withdrawal history items here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1226),
      appBar: AppBar(
        backgroundColor: Color(0xFF1D1226),

        // Add leading icon button
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Withdrawal History',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "PoetsenOne-Regular",
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        itemCount: withdrawalHistory.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showWithdrawalDetailsDialog(context);
            },
            child: WithdrawalHistoryItem(
              date: withdrawalHistory[index].date,
              amount: withdrawalHistory[index].amount,
            ),
          );
        },
      ),
    );
  }

  void showWithdrawalDetailsDialog(BuildContext context) {
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

class WithdrawalHistoryItem extends StatelessWidget {
  final String date;
  final double amount;

  WithdrawalHistoryItem({
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          Text(
            '- ₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
