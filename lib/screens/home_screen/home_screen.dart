import 'package:api_integration/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/journal.dart';
import '../../services/journal_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();
  final JournalService _journalService = JournalService();
  int? userId;
  String? token;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
              onPressed: () {
                refresh();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: (userId != null && token != null) ? 
      ListView(
        controller: _listScrollController,
        children: generateListJournalCards(
          token: token!,
          userId: userId!,
          windowPage: windowPage,
          currentDay: currentDay,
          database: database,
          refreshFunction: refresh,
        ),
      ) : const Center(child: CircularProgressIndicator(),),
    );
  }

  void refresh() async {
    SharedPreferences.getInstance().then((prefs) {
      int? token = prefs.getInt("acessToken");
      String? email = prefs.getString("email");
      int? id = prefs.getInt("id");
       if (token != null && id != null && email != null) {
        _journalService.getAll(id: id.toString(), token: token).then((List<Journal> listJournal) {
          setState(() {
            token = token;
            userId = id;
            database = {};
            for (Journal journal in listJournal) {
              database[journal.id] = journal;
            }

            if (_listScrollController.hasClients) {
              final double position =
                  _listScrollController.position.maxScrollExtent;
              _listScrollController.jumpTo(position);
            }
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
    
  }
}
