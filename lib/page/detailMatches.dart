import 'package:flutter/material.dart';
import '../base_network.dart';
import '../model/detail_matches_model.dart';

class DetailMatches extends StatelessWidget {
  final String id;
  const DetailMatches({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Match ID: $id')
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
            future: BaseNetwork.get('matches/$id'),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return Center(child: Text("There's no data"));
              } else {
                DetailMatchesModel detailMatches =
                DetailMatchesModel.fromJson(snapshot.data);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTeamDetails(context, detailMatches),
                      SizedBox(height: 10),
                      Text('Stadium: ${detailMatches.venue!}'),
                      SizedBox(height: 10),
                      Text('Location: ${detailMatches.location!}'),
                      SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Statistics',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  _detailStatistics(
                                    title: 'Ball Possession',
                                    left: '${detailMatches.homeTeam!.statistics!.ballPossession!}',
                                    right: '${detailMatches.awayTeam!.statistics!.ballPossession!}',
                                  ),
                                  _detailStatistics(
                                    title: 'Shot',
                                    left: '${detailMatches.homeTeam!.statistics!.attemptsOnGoal}',
                                    right: '${detailMatches.awayTeam!.statistics!.attemptsOnGoal}',
                                  ),
                                  _detailStatistics(
                                    title: 'Shot On Goal',
                                    left: '${detailMatches.homeTeam!.statistics!.kicksOnTarget}',
                                    right: '${detailMatches.awayTeam!.statistics!.kicksOnTarget}',
                                  ),
                                  _detailStatistics(
                                    title: 'Corners',
                                    left: '${detailMatches.homeTeam!.statistics!.corners}',
                                    right: '${detailMatches.awayTeam!.statistics!.corners}',
                                  ),
                                  _detailStatistics(
                                    title: 'Offside',
                                    left: '${detailMatches.homeTeam!.statistics!.offsides}',
                                    right: '${detailMatches.awayTeam!.statistics!.offsides}',
                                  ),
                                  _detailStatistics(
                                    title: 'Fouls',
                                    left: '${detailMatches.homeTeam!.statistics!.foulsReceived}',
                                    right: '${detailMatches.awayTeam!.statistics!.foulsReceived}',
                                  ),
                                  _detailStatistics(
                                    title: 'Pass Accuracy',
                                    left: _average(
                                      detailMatches.homeTeam!.statistics!.passesCompleted!,
                                      detailMatches.homeTeam!.statistics!.passes!,
                                    ),
                                    right: _average(
                                      detailMatches.awayTeam!.statistics!.passesCompleted!,
                                      detailMatches.awayTeam!.statistics!.passes!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Referees:',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      _buildRefereeList(context, detailMatches),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTeamDetails(BuildContext context, DetailMatchesModel detailMatches) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Image.network(
                'https://flagcdn.com/256x192/${detailMatches.homeTeam!.country!.substring(0, 2).toLowerCase()}.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
              ),
            ),
            Text('${detailMatches.homeTeam?.name!}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
            ),
          ],
        ),
        Row(
          children: [
            Text('${detailMatches.homeTeam?.goals!}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
            const SizedBox(width: 5),
            const Text(" - ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
            const SizedBox(width: 5),
            Text('${detailMatches.awayTeam?.goals!}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
          ],
        ),
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Image.network(
                'https://flagcdn.com/256x192/${detailMatches.awayTeam!.country!.substring(0, 2).toLowerCase()}.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
              ),
            ),
            Text('${detailMatches.awayTeam?.name!}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRefereeList(BuildContext context, DetailMatchesModel detailMatches) {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < detailMatches.officials!.length; i++)
            Container(
              width: MediaQuery.of(context).size.width / 4,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Table(
                children: [
                  TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              child: Image.asset('assets/fifalogo.png'),
                            ),
                            Text(
                              detailMatches.officials![i].name!,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              detailMatches.officials![i].role!,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _detailStatistics({title, left, right}) {
    return Column(
      children: [
        SizedBox(height: 5),
        Text('$title'),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('$left'),
            Text(" - "),
            Text('$right'),
          ],
        ),
      ],
    );
  }
}
String _average(int complete, int total) {
  int result = ((complete / total) * 100).ceil();
  return '${result.toString()}%';
}