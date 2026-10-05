import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../task.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({
    super.key,
    this.task,
    this.taskKey,
  });

  final Task? task;
  final dynamic taskKey;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _priorityController;
  late final TextEditingController _locationController;
  late final TextEditingController _assignedToController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.task?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.task?.category ?? '',
    );
    _priorityController = TextEditingController(
      text: widget.task?.priority ?? '',
    );
    _locationController = TextEditingController(
      text: widget.task?.location ?? '',
    );
    _assignedToController = TextEditingController(
      text: widget.task?.assignedTo ?? '',
    );
    _notesController = TextEditingController(
      text: widget.task?.notes ?? '',
    );

    _selectedDate = widget.task?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priorityController.dispose();
    _locationController.dispose();
    _assignedToController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName.';
    }
    return null;
  }

  String? _titleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a task title.';
    }

    if (value.trim().length < 3) {
      return 'Task title must be at least 3 characters.';
    }

    return null;
  }

  String? _descriptionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a description.';
    }

    if (value.trim().length < 5) {
      return 'Description must be at least 5 characters.';
    }

    return null;
  }

  String? _priorityValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a priority.';
    }

    final priority = value.trim().toLowerCase();

    if (priority != 'low' &&
        priority != 'medium' &&
        priority != 'high') {
      return 'Use Low, Medium, or High.';
    }

    return null;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final box = Hive.box<Task>('taskBox');

    final newTask = Task(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      priority: _priorityController.text.trim(),
      location: _locationController.text.trim(),
      assignedTo: _assignedToController.text.trim(),
      notes: _notesController.text.trim(),
      date: _selectedDate,
    );

    if (_isEditing) {
      await box.put(widget.taskKey, newTask);
    } else {
      await box.add(newTask);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Task' : 'Add Task',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter task title',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  validator: _titleValidator,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.next,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description',
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: _descriptionValidator,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _categoryController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'e.g. School, Work, Personal',
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _requiredValidator(value, 'a category'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _priorityController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    hintText: 'Low, Medium, or High',
                    prefixIcon: Icon(Icons.flag_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: _priorityValidator,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _locationController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'Enter task location',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _requiredValidator(value, 'a location'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _assignedToController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Assigned To',
                    hintText: 'Enter person or team',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _requiredValidator(value, 'who the task is assigned to'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _notesController,
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Enter additional notes',
                    prefixIcon: Icon(Icons.notes_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _requiredValidator(value, 'notes'),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Task Date',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(_formatDate(_selectedDate)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveTask,
                    icon: Icon(
                      _isEditing ? Icons.save : Icons.add,
                    ),
                    label: Text(
                      _isEditing ? 'Save Changes' : 'Add Task',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
