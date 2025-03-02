import '../models/emission_result.dart';
import '../utils/constants.dart';

// Розрахуємо показник емісії твердих частинок при спалюванні палива
double calculateSolidParticleEmissions(
    double lowerHeatingValue,
    double ash,
    double lightAsh,
    double componentPercentageG,
    double particulateCaptureEfficiency,
    ) {
  return (1e6 / lowerHeatingValue) *
      ash *
      (lightAsh / (100 - componentPercentageG)) *
      (1 - particulateCaptureEfficiency);
}

// Отримуємо показник емісії та валовий викид твердих частинок для вугілля
EmissionResult calculateCoalEmission(double fuelQuantity) {
  double solidParticleEmissions = calculateSolidParticleEmissions(
    COAL_LOWER_HEATING_VALUE,
    COAL_LIGHT_ASH_CONTENT,
    COAL_ASH_MASS_CONTENT,
    COAL_COMBUSTIBLE_MASS_CONTENT,
    COAL_CLEANING_EFFICIENCY,
  );

  double grossEmissions = calculateGrossEmissions(
    solidParticleEmissions,
    COAL_LOWER_HEATING_VALUE,
    fuelQuantity,
  );

  return EmissionResult(solidParticleEmissions, grossEmissions);
}

// Отримуємо показник емісії та валовий викид твердих частинок для мазуту
EmissionResult calculateFuelOilEmission(double fuelQuantity) {
  double solidParticleEmissions = calculateSolidParticleEmissions(
    FUEL_OIL_LOWER_HEATING_VALUE,
    FUEL_OIL_LIGHT_ASH_CONTENT,
    FUEL_ASH_MASS_CONTENT,
    FUEL_OIL_COMPONENT_PERCENTAGE_G,
    FUEL_OIL_CLEANING_EFFICIENCY,
  );

  double grossEmission = calculateGrossEmissions(
    solidParticleEmissions,
    FUEL_OIL_LOWER_HEATING_VALUE,
    fuelQuantity,
  );

  return EmissionResult(solidParticleEmissions, grossEmission);
}

// Отримуємо показник емісії та валовий викид твердих частинок для природнього газу
EmissionResult calculateGasEmission(double fuelQuantity) {
  return EmissionResult(0.0, 0.0);
}

// Розраховуємо валовий викид твердих частинок при спалюванні палива
double calculateGrossEmissions(
    double solidParticleEmissions,
    double lowerHeatingValue,
    double fuelQuantity,
    ) {
  return 1e-6 * solidParticleEmissions * lowerHeatingValue * fuelQuantity;
}

// Розраховуємо викиди для кожного типу палива
Map<String, EmissionResult> calculateEmissions(
    double coalQuantity,
    double fuelOilQuantity,
    double gasQuantity,
    ) {
  final fuelCalculations = {
    "вугілля": () => calculateCoalEmission(coalQuantity),
    "мазута": () => calculateFuelOilEmission(fuelOilQuantity),
    "газу": () => calculateGasEmission(gasQuantity),
  };

  return fuelCalculations.map((fuelType, calculation) =>
      MapEntry(fuelType, calculation()));
}
