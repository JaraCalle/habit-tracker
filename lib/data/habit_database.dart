import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Referenciar a la box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];

  // Crear los datos default
  void createDefaultData() {
    todaysHabitList = [
      ["Adelantar la tarea de seminario", false],
      ["Programar 1hr", false]
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }
  // Cargar los datos por si existen
  void loadData() {
    // Comprobar si es un nuevo día para traer los datos
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      for (int i = 0; i < todaysHabitList.length; i++){
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }
  // Actualizar la base de datos
  void updateDatabase() {
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);
  }
}