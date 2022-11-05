import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FoodResult extends StatefulWidget {
  const FoodResult({super.key});

  @override
  State<FoodResult> createState() => _FoodResultState();
}

class _FoodResultState extends State<FoodResult> {
  late Future<Prediction> futurePrediction;

  @override
  void initState() {
    super.initState();
    futurePrediction = fetchPrediction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Food Log App'),
        ),
        body: FutureBuilder<Prediction>(
            future: futurePrediction,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: Center(child: Text(snapshot.data!.details)),
                  ),
                ));
              } else if (snapshot.hasError) {
                return Center(
                    child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: Center(child: Text('${snapshot.error}')),
                  ),
                ));
              }

              // By default, show a loading spinner.
              return Center(child: const CircularProgressIndicator());
            }));
  }
}

Future<Prediction> fetchPrediction() async {
  final response =
      await http.get(Uri.parse('http://18.223.74.63:8000/api/predict'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Prediction.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Server Failed To Respond');
  }
}

class Prediction {
  final String predictedLabel;
  final String details;

  const Prediction({
    required this.predictedLabel,
    required this.details,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      predictedLabel: json['predictedLabel'],
      details: json['details'],
    );
  }
}
