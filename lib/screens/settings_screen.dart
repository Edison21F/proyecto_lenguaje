import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _selectedLanguage = 'Español';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'Español';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('sound_enabled', _soundEnabled);
    await prefs.setBool('vibration_enabled', _vibrationEnabled);
    await prefs.setString('language', _selectedLanguage);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración guardada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Apariencia'),
          _buildSwitchTile(
            title: 'Modo oscuro',
            subtitle: 'Cambiar entre tema claro y oscuro',
            value: _isDarkMode,
            icon: Icons.dark_mode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),
          const Divider(),
          _buildSectionTitle('Notificaciones'),
          _buildSwitchTile(
            title: 'Notificaciones',
            subtitle: 'Recibir recordatorios diarios',
            value: _notificationsEnabled,
            icon: Icons.notifications,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          const Divider(),
          _buildSectionTitle('Sonido y vibración'),
          _buildSwitchTile(
            title: 'Sonido',
            subtitle: 'Reproducir sonidos en la aplicación',
            value: _soundEnabled,
            icon: Icons.volume_up,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            title: 'Vibración',
            subtitle: 'Vibrar al interactuar con la aplicación',
            value: _vibrationEnabled,
            icon: Icons.vibration,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
          ),
          const Divider(),
          _buildSectionTitle('Idioma'),
          _buildLanguageDropdown(),
          const Divider(),
          _buildSectionTitle('Datos'),
          _buildActionTile(
            title: 'Borrar datos guardados',
            subtitle: 'Eliminar todo el progreso y configuración',
            icon: Icons.delete,
            iconColor: Colors.red,
            onTap: _showDeleteConfirmationDialog,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Guardar configuración',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Señas Contigo v1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.language,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: const Text('Idioma'),
      subtitle: const Text('Selecciona el idioma de la aplicación'),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedLanguage = newValue;
            });
          }
        },
        items: <String>['Español', 'English', 'Português']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Borrar datos'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que deseas borrar todos tus datos?'),
                SizedBox(height: 10),
                Text(
                  'Esta acción no se puede deshacer y perderás todo tu progreso.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Borrar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // Aquí iría la lógica para borrar los datos
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todos los datos han sido borrados'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
