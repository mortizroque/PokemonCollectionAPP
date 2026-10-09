import 'package:flutter/material.dart';
import 'usuario.dart'; // Importa la clase Usuario

class UsuarioProvider extends ChangeNotifier {
  Usuario? _usuario; // Usuario actualmente autenticado

  // Método para establecer el usuario autenticado
  void setUsuario(Usuario usuario) {
    _usuario = usuario;
    notifyListeners(); // Notificar a los oyentes que el estado ha cambiado
  }

  // Método para obtener el usuario autenticado
  Usuario? get usuario => _usuario;

  // Método para verificar si hay un usuario autenticado
  bool estaAutenticado() => _usuario != null;

  // Método para cerrar sesión
  void logout() {
    _usuario = null; // Establece el usuario como null
    notifyListeners(); // Notificar a los oyentes que el estado ha cambiado
  }
}
