import 'package:flutter/material.dart';
import '../services/calculations.dart';
import '../models/emission_result.dart';
import '../utils/helpers.dart';

class EmissionCalculatorPage extends StatefulWidget {
  @override
  _EmissionCalculatorPageState createState() => _EmissionCalculatorPageState();
}

class _EmissionCalculatorPageState extends State<EmissionCalculatorPage> {
  final TextEditingController coalQuantityController =
  TextEditingController(text: "1096363");
  final TextEditingController fuelOilQuantityController =
  TextEditingController(text: "70945");
  final TextEditingController gasQuantityController =
  TextEditingController(text: "84762");

  Map<String, EmissionResult>? results;

  void _calculateEmissions() {
    final double coalQuantity =
        double.tryParse(coalQuantityController.text) ?? 0.0;
    final double fuelOilQuantity =
        double.tryParse(fuelOilQuantityController.text) ?? 0.0;
    final double gasQuantity =
        double.tryParse(gasQuantityController.text) ?? 0.0;

    setState(() {
      results = calculateEmissions(coalQuantity, fuelOilQuantity, gasQuantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор викидів шкідливих речовин'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Введіть обсяг палива:"),
            SizedBox(height: 8),
            TextField(
              controller: coalQuantityController,
              decoration: InputDecoration(labelText: "Вугілля (т)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            TextField(
              controller: fuelOilQuantityController,
              decoration: InputDecoration(labelText: "Мазут (т)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            TextField(
              controller: gasQuantityController,
              decoration:
              InputDecoration(labelText: "Природний газ (тис. м³)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateEmissions,
              child: Text("Розрахувати"),
            ),
            SizedBox(height: 16),
            if (results != null)
              ...results!.entries.map((entry) {
                final fuelType = entry.key;
                final emissionResult = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Викиди твердих частинок $fuelType: ${emissionResult.solidParticleEmissions.roundTo(2)} г/ГДж"),
                    Text("Валовий викид $fuelType: ${emissionResult.grossEmissions.roundTo(2)} т"),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
