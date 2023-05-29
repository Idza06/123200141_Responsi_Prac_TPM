import 'package:flutter/material.dart';
import 'package:responsi_tpm/page/detailMatches.dart';
import '../base_network.dart';
import '../model/matches_model.dart';

class ApiService {
  Future<List<MatchesModel>> getMatches() async {
    final response = await BaseNetwork.getList('matches');
    return response.map((json) => MatchesModel.fromJson(json)).toList();
  }
}

class listMatches extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Cup 2022'),
      ),
      body: FutureBuilder(
        future: apiService.getMatches(),
        builder: (context, AsyncSnapshot<List<MatchesModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("There's no data"),
            );
          } else {
            List<MatchesModel> matches = snapshot.data!;
            return ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                MatchesModel match = matches[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMatches(id: match.id!),
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Image.network(
                                  'https://flagcdn.com/256x192/${match.homeTeam!.country!.substring(0, 2).toLowerCase()}.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                                ),
                              ),
                              Text('${match.homeTeam?.name!}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('${match.homeTeam?.goals!}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                              const SizedBox(width: 5),
                              const Text(" - ",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                              const SizedBox(width: 5),
                              Text('${match.awayTeam?.goals!}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Image.network(
                                  'https://flagcdn.com/256x192/${match.awayTeam!.country!.substring(0, 2).toLowerCase()}.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                                ),
                              ),
                              Text('${match.awayTeam?.name!}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}