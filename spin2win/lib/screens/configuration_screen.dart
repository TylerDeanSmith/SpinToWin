import 'package:flutter/material.dart';
import '../models/wheel_configuration.dart';
import '../models/wheel_option.dart';
import '../services/configuration_service.dart';

class ConfigurationScreen extends StatefulWidget {
  final List<WheelConfiguration> configurations;

  const ConfigurationScreen({
    super.key,
    required this.configurations,
  });

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  late List<WheelConfiguration> _configurations;

  @override
  void initState() {
    super.initState();
    _configurations = List.from(widget.configurations);
  }

  void _addConfiguration() {
    final newConfig = WheelConfiguration(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Wheel',
      options: [
        WheelOption(
          id: '1',
          label: 'Option 1',
          color: 'FF5722',
        ),
        WheelOption(
          id: '2',
          label: 'Option 2',
          color: '2196F3',
        ),
      ],
    );

    setState(() {
      _configurations.add(newConfig);
    });
    _editConfiguration(_configurations.length - 1);
  }

  void _editConfiguration(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfigurationEditScreen(
          configuration: _configurations[index],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _configurations[index] = result;
      });
    }
  }

  void _deleteConfiguration(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Configuration'),
        content: Text('Are you sure you want to delete "${_configurations[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _configurations.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _saveConfigurations() async {
    // Update next indices for proper flow
    for (int i = 0; i < _configurations.length; i++) {
      _configurations[i] = _configurations[i].copyWith(
        nextIndex: i + 1,
      );
    }

    await ConfigurationService.saveConfigurations(_configurations);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configurations saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wheel Configurations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveConfigurations,
          ),
        ],
      ),
      body: _configurations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.casino,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No configurations yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addConfiguration,
                    child: const Text('Create First Configuration'),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _configurations.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = _configurations.removeAt(oldIndex);
                  _configurations.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final config = _configurations[index];
                return Card(
                  key: ValueKey(config.id),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.drag_handle, size: 16),
                      ],
                    ),
                    title: Text(
                      config.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('${config.options.length} options'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editConfiguration(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteConfiguration(index),
                        ),
                      ],
                    ),
                    onTap: () => _editConfiguration(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addConfiguration,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ConfigurationEditScreen extends StatefulWidget {
  final WheelConfiguration configuration;

  const ConfigurationEditScreen({
    super.key,
    required this.configuration,
  });

  @override
  State<ConfigurationEditScreen> createState() => _ConfigurationEditScreenState();
}

class _ConfigurationEditScreenState extends State<ConfigurationEditScreen> {
  late TextEditingController _nameController;
  late List<WheelOption> _options;

  final List<String> _colors = [
    'FF5722', '2196F3', '4CAF50', 'FFC107', '9C27B0',
    'FF9800', 'E91E63', '3F51B5', '795548', '607D8B',
    'F44336', '8BC34A', '009688', 'FFEB3B', '673AB7',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.configuration.name);
    _options = List.from(widget.configuration.options);
  }

  void _addOption() {
    setState(() {
      _options.add(WheelOption(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: 'New Option',
        color: _colors[_options.length % _colors.length],
      ));
    });
  }

  void _removeOption(int index) {
    if (_options.length > 2) {
      setState(() {
        _options.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A wheel must have at least 2 options'),
        ),
      );
    }
  }

  void _saveConfiguration() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    final updatedConfig = widget.configuration.copyWith(
      name: _nameController.text.trim(),
      options: _options,
    );

    Navigator.pop(context, updatedConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Configuration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveConfiguration,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Wheel Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Options:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final option = _options[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Color(int.parse('FF${option.color}', radix: 16)),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: option.label)
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(offset: option.label.length),
                                ),
                              onChanged: (value) {
                                _options[index] = option.copyWith(label: value);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Option label',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeOption(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOption,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}