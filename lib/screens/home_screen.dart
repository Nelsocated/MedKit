import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = IndexedStack(
      index: _selectedIndex,
      children: const [
        Center(child: Text('Dashboard coming soon')),
        Center(child: Text('Medicines coming soon')),
        Center(child: Text('Drug Info coming soon')),
      ],
    );

    final width = MediaQuery.of(context).size.width;

    if (width < 800) {
      return Scaffold(
        appBar: AppBar(title: const Text('MedKit')),
        body: tabs,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _selectTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.medication),
              label: 'Medicines',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: 'Drug Info'),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('MedKit')),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectTab,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.medication),
                label: Text('Medicines'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                label: Text('Drug Info'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: tabs),
        ],
      ),
    );
  }
}
