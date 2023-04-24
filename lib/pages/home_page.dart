import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista de habitos
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {

    // si no hay ningún habito, es la primera vez que se abre la app
    // cargar los datos default
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }

    // actualizar la base de datos
    db.updateDatabase();

    super.initState();
  }

  // Combrobación para el checkbox
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  // Crear nuevo habito
  final _newHabitNameController = TextEditingController();
  void createNewHabit(){
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: "Ingresa el hábito...",
          onCancel: cancelarDialogBox,
          onSave: GuardarNuevoHabito,
        );
      },
    );
  }

  // Guardar nuevo habito
  void GuardarNuevoHabito() {
    // Agregar nuevo habito a la lista
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    // Limpiar el textfield
    _newHabitNameController.clear();
    // Eliminar dialog box
    Navigator.of(context).pop();
    db.updateDatabase();

  }

  // Cancelar nuevo habito
  void cancelarDialogBox(){
    // Limpiar el textfield
    _newHabitNameController.clear();
    // Eliminar dialog box
    Navigator.of(context).pop();
  }

  // Abrir la opción para editar los habitos
  void openHabitsSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: db.todaysHabitList[index][0],
          onSave: () => guardarExistingHabit(index),
          onCancel: cancelarDialogBox,
        );
    },);
  }

  // Cambiar el nombre de un habito ya existente
  void guardarExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();

  }

  void borrarHabito(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView.builder(
        itemCount: db.todaysHabitList.length,
        itemBuilder: (context, index) {
          return HabitTile(
            habitName: db.todaysHabitList[index][0],
            habitCompleted: db.todaysHabitList[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            settingsTapped: (context) => openHabitsSettings(index),
            deleteTapped: (context) => borrarHabito(index),
          );
        }
      ),
    );
  }
}