import 'package:flutter/material.dart';
import '../../models/data_models.dart';

class DashboardTab extends StatelessWidget {
  final List<StockHolding> holdings;
  final List<DividendRecord> dividends;

  const DashboardTab({
    super.key,
    required this.holdings,
    required this.dividends,
  });

  @override
  Widget build(BuildContext context) {
    // 计算总资产
    double totalAssetValue = holdings.fold(0, (sum, item) => sum + item.totalValue);
    double totalProfit = holdings.fold(0, (sum, item) => sum + item.profitLoss);
    
    // 计算股息
    double totalDividendsReceived = dividends
        .where((d) => d.isPaid)
        .fold(0, (sum, item) => sum + item.totalAmount);
        
    double pendingDividends = dividends
        .where((d) => !d.isPaid)
        .fold(0, (sum, item) => sum + item.totalAmount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssetCard(context, totalAssetValue, totalProfit),
          const SizedBox(height: 20),
          const Text(
            '股息概览',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  '已获股息',
                  totalDividendsReceived,
                  Colors.green.shade100,
                  Colors.green.shade800,
                  Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  '待收股息',
                  pendingDividends,
                  Colors.orange.shade100,
                  Colors.orange.shade800,
                  Icons.schedule,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '近期动态',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildRecentActivityList(dividends),
        ],
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, double totalValue, double totalProfit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '总持仓市值',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '¥${totalValue.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      totalProfit >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${totalProfit >= 0 ? '+' : ''}${totalProfit.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                '总盈亏',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, double amount, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: textColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '¥${amount.toStringAsFixed(2)}',
            style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList(List<DividendRecord> dividends) {
    if (dividends.isEmpty) {
      return const Center(child: Text('暂无动态', style: TextStyle(color: Colors.grey)));
    }
    
    // 取最近3条
    final recent = dividends.take(3).toList();
    
    return Column(
      children: recent.map((d) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0,
          color: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: d.isPaid ? Colors.green.shade100 : Colors.orange.shade100,
              child: Icon(
                d.isPaid ? Icons.check : Icons.access_time,
                color: d.isPaid ? Colors.green : Colors.orange,
                size: 20,
              ),
            ),
            title: Text(d.stockName),
            subtitle: Text('${d.payDate.year}-${d.payDate.month}-${d.payDate.day} 派息'),
            trailing: Text(
              '+${d.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
        );
      }).toList(),
    );
  }
}
