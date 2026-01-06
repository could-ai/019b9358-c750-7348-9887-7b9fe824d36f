class StockHolding {
  final String id;
  final String symbol; // 代码 e.g., AAPL, 00700
  final String name;   // 名称
  final int quantity;  // 持仓数量
  final double avgCost; // 平均成本
  final double currentPrice; // 当前价格 (Mock)

  StockHolding({
    required this.id,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.avgCost,
    required this.currentPrice,
  });

  double get totalValue => quantity * currentPrice;
  double get totalCost => quantity * avgCost;
  double get profitLoss => totalValue - totalCost;
  double get profitLossPercent => totalCost == 0 ? 0 : (profitLoss / totalCost) * 100;
}

class DividendRecord {
  final String id;
  final String symbol;
  final String stockName;
  final double amountPerShare; // 每股分红
  final DateTime exDividendDate; // 除息日
  final DateTime payDate; // 派息日
  final int quantityHeld; // 当时持仓
  final bool isPaid; // 是否已发放

  DividendRecord({
    required this.id,
    required this.symbol,
    required this.stockName,
    required this.amountPerShare,
    required this.exDividendDate,
    required this.payDate,
    required this.quantityHeld,
    required this.isPaid,
  });

  double get totalAmount => amountPerShare * quantityHeld;
}
