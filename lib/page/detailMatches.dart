import 'package:flutter/material.dart';
import 'package:responsi_tpm/model/matches_model.dart';

class DetailMatches extends StatelessWidget {
  final MatchesModel match;

  const DetailMatches({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match ID: ${match.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${match.homeTeam?.name}' ' vs ' '${match.awayTeam?.name}',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            Text(
              'Stadium: ${match.venue}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            Text(
              'Location: ${match.location}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            const Text(
              'Statistics:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (match.homeTeam != null && match.awayTeam != null)
              Column(
                children: [
                  const Text(
                    'Shot:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${match.homeTeam!.name}: ${match.homeTeam!.goals ?? 0}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${match.awayTeam!.name}: ${match.awayTeam!.goals ?? 0}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Shot on Goals:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${match.homeTeam!.name}: ${match.homeTeam!.penalties ?? 0}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${match.awayTeam!.name}: ${match.awayTeam!.penalties ?? 0}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Referees:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (match.officials != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (Officials official in match.officials!)
                            Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(official.name ?? ''),
                                    Text(official.role ?? ''),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}