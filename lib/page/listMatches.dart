import 'package:flutter/material.dart';
import 'package:responsi_tpm/page/detailMatches.dart';
import '../base_network.dart';
import '../model/matches_model.dart';

class ApiService {
  Future<List<MatchesModel>> getMatches() async {
    final response = await BaseNetwork.getList('matches');
    return response.map((json) => MatchesModel.fromJson(json)).toList();
  }

  Future<MatchesModel?> getMatchDetail(String matchId) async {
    final response = await BaseNetwork.get('matches/$matchId');
    return response.isNotEmpty ? MatchesModel.fromJson(response) : null;
  }
}

class listMatches extends StatefulWidget {
  const listMatches({Key? key}) : super(key: key);

  @override
  _listMatchesState createState() => _listMatchesState();
}

class _listMatchesState extends State<listMatches> {
  List<MatchesModel> matches = [];

  @override
  void initState() {
    super.initState();
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
    ApiService apiService = ApiService();
    List<MatchesModel> fetchedMatches = await apiService.getMatches();
    //List<MatchesModel> fetchedMatches = await apiService.getMatchesDetail();

    setState(() {
      matches = fetchedMatches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches List'),
      ),
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          MatchesModel match = matches[index];
          return ListTile(
            title: Text('${match.homeTeam?.name}' ' vs ' '${match.awayTeam?.name}'),
            subtitle: Text('${match.homeTeam?.goals}' ' - ' '${match.awayTeam?.goals}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMatches(match: match),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
