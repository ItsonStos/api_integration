import 'package:api_integration/models/journal.dart';
import 'package:api_integration/services/journal_service.dart';
import 'package:flutter/material.dart';
import '../../helpers/weekday.dart'; 


class AddJournalScreen extends StatefulWidget {
  final Journal journal;
  final bool isEditing;
  const AddJournalScreen({Key? key, required this.journal, required this.isEditing}) : super(key: key);

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final TextEditingController _contentController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    _contentController.text = widget.journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(            WeekDay(widget.journal.createdAt).toString()),
        actions: [
          IconButton(
            onPressed: () {
              registerJournal(context);
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) async {
    JournalService journalService = JournalService();
    widget.journal.content = _contentController.text;
    if (widget.isEditing){
    journalService.register(widget.journal).then((value) {
      if (value) {
        Navigator.pop(context, DisposeStatus.success);
      } else {
        Navigator.pop(context, DisposeStatus.error);
      }
    });

    } else {
      journalService.register(widget.journal).then((value){
        if(value){
        Navigator.pop(context, DisposeStatus.success);          
        } else {
          Navigator.pop(context, DisposeStatus.error);
        }
      });
    }
  }
}
enum DisposeStatus { exit, error, success }
