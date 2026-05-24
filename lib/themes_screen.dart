import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  final TextEditingController _themeController = TextEditingController();

  void _addTheme(GameState gameState) {
    final theme = _themeController.text.trim();
    if (theme.isNotEmpty) {
      gameState.addTheme(theme);
      _themeController.clear();
    }
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Input para nuevos temas
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _themeController,
                    decoration: InputDecoration(
                      hintText: 'Nuevo tema (Ej. Marcas de Zapatos)',
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _addTheme(gameState),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _addTheme(gameState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Lista de temas existentes
            Expanded(
              child: ListView.builder(
                itemCount: gameState.themes.length,
                itemBuilder: (context, index) {
                  final theme = gameState.themes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber[100], 
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          theme,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber[900]),
                        ),
                        // Botón de eliminar (deshabilitado si solo queda 1 tema)
                        IconButton(
                          icon: Icon(
                            Icons.delete, 
                            color: gameState.themes.length > 1 ? Colors.red : Colors.grey
                          ),
                          onPressed: gameState.themes.length > 1 
                              ? () => gameState.removeTheme(index) 
                              : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}