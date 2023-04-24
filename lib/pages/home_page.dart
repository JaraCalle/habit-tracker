import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista de habitos
  List todaysHabitList = [
    // [habitName, habitCompleted]
  ];

  // Combrobación para el checkbox
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todaysHabitList[index][1] = value;
    });
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
      todaysHabitList.add([_newHabitNameController.text, false]);
    });
    // Limpiar el textfield
    _newHabitNameController.clear();
    // Eliminar dialog box
    Navigator.of(context).pop();
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
          hintText: todaysHabitList[index][0],
          onSave: () => guardarExistingHabit(index),
          onCancel: cancelarDialogBox,
        );
    },);
  }

  // Cambiar el nombre de un habito ya existente
  void guardarExistingHabit(int index) {
    setState(() {
      todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  void borrarHabito(int index) {
    setState(() {
      todaysHabitList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView.builder(
        itemCount: todaysHabitList.length,
        itemBuilder: (context, index) {
          return HabitTile(
            habitName: todaysHabitList[index][0],
            habitCompleted: todaysHabitList[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            settingsTapped: (context) => openHabitsSettings(index),
            deleteTapped: (context) => borrarHabito(index),
          );
        }
      ),
    );
  }
}