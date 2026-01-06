import 'package:flutter/material.dart';
import '../models/data_models.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/holdings_tab.dart';
import 'tabs/dividends_tab.dart';
import 'add_holding_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Mock Data
  final List<StockHolding> _holdings = [
    StockHolding(
      id: '1',
      symbol: '600519',
      name: '贵州茅台',
      quantity: 100,
      avgCost: 1700.0,
      currentPrice: 1750.0,
    ),
    StockHolding(
      id: '2',
      symbol: '00700',
      name: '腾讯控股',
      quantity: 500,
      avgCost: 300.0,
      currentPrice: 320.0,
    ),
    StockHolding(
      id: '3',
      symbol: 'AAPL',
      name: 'Apple Inc.',
      quantity: 50,
      avgCost: 150.0,
      currentPrice: 175.0,
    ),
  ];

  final List<DividendRecord> _dividends = [
    DividendRecord(
      id: '1',
      symbol: '600519',
      stockName: '贵州茅台',
      amountPerShare: 20.0,
      exDividendDate: DateTime.now().subtract(const Duration(days: 30)),
      payDate: DateTime.now().subtract(const Duration(days: 5)),
      quantityHeld: 100,
      isPaid: true,
    ),
    DividendRecord(
      id: '2',
      symbol: '00700',
      stockName: '腾讯控股',
      amountPerShare: 2.5,
      exDividendDate: DateTime.now().add(const Duration(days: 10)),
      payDate: DateTime.now().add(const Duration(days: 25)),
      quantityHeld: 500,
      isPaid: false,
    ),
  ];

  void _addHolding(StockHolding holding) {
    setState(() {
      _holdings.add(holding);
    });
  }

  void _deleteHolding(StockHolding holding) {
    setState(() {
      _holdings.removeWhere((h) => h.id == holding.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      DashboardTab(holdings: _holdings, dividends: _dividends),
      HoldingsTab(holdings: _holdings, onDelete: _deleteHolding),
      DividendsTab(dividends: _dividends),
    ];

    final List<String> titles = ['资产概览', '我的持仓', '股息记录'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: tabs[_currentIndex],
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddHoldingScreen()),
                );
                if (result != null && result is StockHolding) {
                  _addHolding(result);
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: '概览',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: '持仓',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: '股息',
          ),
        ],
      ),
    );
  }
}
