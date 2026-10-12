import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingApp());
}

class Item {
  Item(this.name);

  final String name;
  bool bought = false;
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'Shopping List'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> items = [Item('Milk'), Item('Bread'), Item('Rice')];
  final TextEditingController controller = TextEditingController();

  void addItem() {
    final text = controller.text.trim();
    if (text.isEmpty) {
      showMessage('Type an item first');
      return;
    }
    if (items.any((item) => item.name == text)) {
      showMessage('$text is already on the list');
      return;
    }
    setState(() {
      items.add(Item(text));
    });
    controller.clear();
  }

  void removeItem(int index) {
    final name = items[index].name;
    setState(() {
      items.removeAt(index);
    });
    showMessage('$name removed');
  }

  void clearBought() {
    setState(() {
      items.removeWhere((item) => item.bought);
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = items.where((item) => !item.bought).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} ($left left)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            tooltip: 'Remove bought items',
            onPressed: clearBought,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type an item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => addItem(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Your list is empty'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: Icon(
                          item.bought
                              ? Icons.check_circle
                              : Icons.shopping_basket,
                        ),
                        title: Text(
                          item.name,
                          style: TextStyle(
                            decoration: item.bought
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => removeItem(index),
                        ),
                        onTap: () {
                          setState(() {
                            item.bought = !item.bought;
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
