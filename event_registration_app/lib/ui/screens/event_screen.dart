import 'package:flutter/material.dart';
import '../../controller/event_controller.dart';
import '../../models/event_item.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final EventController _controller = EventController();
  late Future<List<EventRegistrationItem>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _refreshEventList();
  }

  // Recarrega a lista de eventos do repositório
  void _refreshEventList() {
    setState(() {
      _eventsFuture = _controller.fetchAllEvents();
    });
  }

  // Exibe o diálogo para adicionar ou editar um evento
  void _showEventDialog({EventRegistrationItem? event}) {
    final _formKey = GlobalKey<FormState>();
    final bool isEditing = event != null;

    // Controladores para os campos de texto
    final _nameController = TextEditingController(text: event?.eventName ?? '');
    final _descriptionController = TextEditingController(text: event?.eventDescription ?? '');
    final _dateController = TextEditingController(text: event?.date ?? '');
    final _timeController = TextEditingController(text: event?.time ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Evento' : 'Adicionar Evento'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Evento',
                      icon: Icon(Icons.event),
                    ),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      icon: Icon(Icons.description),
                    ),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      icon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                      }
                    },
                    validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Hora',
                      icon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        _timeController.text = pickedTime.format(context);
                      }
                    },
                    validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (isEditing) {
                    // Lógica de atualização
                    final updatedEvent = event.copyWith(
                      eventName: _nameController.text,
                      eventDescription: _descriptionController.text,
                      date: _dateController.text,
                      time: _timeController.text,
                    );
                    _controller.updateEvent(event.id, updatedEvent.eventName, updatedEvent.eventDescription, updatedEvent.date, updatedEvent.time).then((_) => _refreshEventList());
                  } else {
                    // Lógica de adição
                    final newEvent = EventRegistrationItem(
                      eventName: _nameController.text,
                      eventDescription: _descriptionController.text,
                      date: _dateController.text,
                      time: _timeController.text,
                    );
                    _controller.addEvent(newEvent).then((_) => _refreshEventList());
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Exibe confirmação antes de deletar
  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Você tem certeza que deseja excluir este evento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              _controller.removeEvent(id).then((_) => _refreshEventList());
              Navigator.of(context).pop();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Eventos'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: FutureBuilder<List<EventRegistrationItem>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar eventos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum evento cadastrado.\nClique no botão "+" para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final events = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      event.eventName.isNotEmpty ? event.eventName[0].toUpperCase() : '?',
                      style: TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                  title: Text(event.eventName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${event.date} às ${event.time}\n${event.eventDescription}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _showEventDialog(event: event),
                        tooltip: 'Editar',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _showDeleteConfirmation(event.id),
                        tooltip: 'Excluir',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventDialog(),
        tooltip: 'Adicionar Evento',
        child: const Icon(Icons.add),
      ),
    );
  }
}