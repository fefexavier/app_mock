import 'package:app_mock/core/colors';
import 'package:app_mock/core/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class RedeCredenciadaPage extends StatefulWidget {
  const RedeCredenciadaPage({super.key});

  @override
  State<RedeCredenciadaPage> createState() => _DualListPageState();
}

class _DualListPageState extends State<RedeCredenciadaPage> {
  List<String> listA = [];
  List<String> listB = [];

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    // Substitua isso pelas chamadas reais do seu controller
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      listA = List.generate(10, (i) => 'Item da Lista A ${i + 1}');
      listB = List.generate(8, (i) => 'Item da Lista B ${i + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
     appBar: AppBar(
        backgroundColor: lightColor.brandPrimary,
        title: GradientText(
          'Rede credenciada',
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(250, 251, 251, 1),
            Color.fromRGBO(131, 197, 190, 1),
          ]),
        ),
        centerTitle: true,
       
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary.withOpacity(0.1), theme.colorScheme.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista A:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnimatedList(listA, Colors.indigoAccent),
            const SizedBox(height: 24),
            const Text(
              'Lista B:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildGridList(listB, Colors.deepOrangeAccent)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedList(List<String> items, Color color) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                )
              ],
            ),
            child: Center(
              child: Text(
                items[index],
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridList(List<String> items, Color color) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          color: color.withOpacity(0.85),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              items[index],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}
