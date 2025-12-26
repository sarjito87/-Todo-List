import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/shopping_model.dart';
import '../../services/storage_service.dart';
import 'widgets/summary_card.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> _items = [];
  final List<String> _categories = ['Makanan', 'Minuman', 'Elektronik', 'Pakaian', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await StorageService.loadShopping();
    setState(() => _items = data);
  }

  void _saveData() => StorageService.saveShopping(_items);

  // --- FUNGSI HELPER UNTUK ICON (YANG TADI ERROR) ---
  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Makanan': return Icons.fastfood_rounded;
      case 'Minuman': return Icons.local_drink_rounded;
      case 'Elektronik': return Icons.devices_rounded;
      case 'Pakaian': return Icons.checkroom_rounded;
      default: return Icons.shopping_basket_rounded;
    }
  }

  void _showForm([ShoppingItem? item]) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final qtyController = TextEditingController(text: item?.quantity.toString() ?? '1');
    String selectedCategory = item?.category ?? _categories[0];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(item == null ? "Tambah Barang" : "Edit Barang"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nama Barang",
                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: qtyController,
                decoration: InputDecoration(
                  labelText: "Jumlah",
                  prefixIcon: const Icon(Icons.production_quantity_limits),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => selectedCategory = v!,
                decoration: InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          if (item != null)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
              onPressed: () {
                setState(() => _items.removeWhere((i) => i.id == item.id));
                _saveData();
                Navigator.pop(context);
              },
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (nameController.text.isEmpty) return;
              setState(() {
                if (item == null) {
                  _items.add(ShoppingItem(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    quantity: int.tryParse(qtyController.text) ?? 1,
                    category: selectedCategory,
                  ));
                } else {
                  item.name = nameController.text;
                  item.quantity = int.tryParse(qtyController.text) ?? 1;
                  item.category = selectedCategory;
                }
              });
              _saveData();
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int boughtCount = _items.where((i) => i.isBought).length;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Daftar Belanja", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SummaryCard(total: _items.length, bought: boughtCount),
          Expanded(
            child: _items.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_shopping_cart_rounded, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  const Text("Belum ada daftar belanja", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ListTile(
                    onTap: () => _showForm(item),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: item.isBought ? TextDecoration.lineThrough : null,
                        color: item.isBought ? Colors.grey : Colors.black87,
                      ),
                    ),
                    subtitle: Text("${item.category} • Qty: ${item.quantity}"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade50,
                      child: Icon(_getIconForCategory(item.category), color: Colors.indigo, size: 20),
                    ),
                    trailing: Checkbox(
                      activeColor: Colors.indigo,
                      shape: const CircleBorder(),
                      value: item.isBought,
                      onChanged: (val) {
                        setState(() => item.isBought = val!);
                        _saveData();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        label: const Text("Belanja"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}