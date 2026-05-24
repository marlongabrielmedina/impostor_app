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
  bool _isForDrawing = true; // Estado local para el checkbox de la nueva categoría

  void _addTheme(GameState gameState) {
    final theme = _themeController.text.trim();
    if (theme.isNotEmpty) {
      gameState.addTheme(theme, _isForDrawing);
      _themeController.clear();
      setState(() {
        _isForDrawing = true; // Reiniciamos el checkbox a true
      });
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
            // Fila de Texto de entrada
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _themeController,
                    decoration: InputDecoration(
                      hintText: 'Nuevo tema...',
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
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // --- NUEVO: Checkbox para marcar si es apto para dibujo ---
            CheckboxListTile(
              title: const Text('¿Este tema es apto para la modalidad de dibujo?', style: TextStyle(fontSize: 14)),
              value: _isForDrawing,
              dense: true,
              activeColor: Colors.blueAccent,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) {
                setState(() {
                  _isForDrawing = val ?? true;
                });
              },
            ),
            const SizedBox(height: 16),
            
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
                        // Nombre del tema + Indicador visual si es de dibujo
                        Row(
                          children: [
                            if (theme.isForDrawing)
                              Icon(Icons.palette, size: 18, color: Colors.amber[900])
                            else
                              Icon(Icons.record_voice_over, size: 18, color: Colors.blue[900]),
                            const SizedBox(width: 8),
                            Text(
                              theme.name,
                              style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold, 
                                color: theme.isForDrawing ? Colors.amber[900] : Colors.blue[900]
                              ),
                            ),
                          ],
                        ),
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