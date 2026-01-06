import 'package:flutter/material.dart';
import '../../models/data_models.dart';

class DividendsTab extends StatelessWidget {
  final List<DividendRecord> dividends;

  const DividendsTab({
    super.key,
    required this.dividends,
  });

  @override
  Widget build(BuildContext context) {
    if (dividends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('暂无股息记录', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    // 按日期排序
    final sortedDividends = List<DividendRecord>.from(dividends)
      ..sort((a, b) => b.payDate.compareTo(a.payDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDividends.length,
      itemBuilder: (context, index) {
        final record = sortedDividends[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: record.isPaid ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                record.isPaid ? Icons.check : Icons.schedule,
                color: record.isPaid ? Colors.green : Colors.orange,
              ),
            ),
            title: Text(
              record.stockName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('派息日: ${record.payDate.year}-${record.payDate.month}-${record.payDate.day}'),
                Text('每股: ¥${record.amountPerShare} x ${record.quantityHeld}股'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+¥${record.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.isPaid ? '已到账' : '待发放',
                  style: TextStyle(
                    fontSize: 12,
                    color: record.isPaid ? Colors.grey : Colors.orange,
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
