import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';
import 'instructions_screen.dart';
import 'themes_screen.dart';

// Usamos un StatefulWidget porque necesitamos un "Controlador" para leer el texto del input
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  // Este controlador lee lo que el usuario escribe en el campo de texto
  final TextEditingController _nameController = TextEditingController();

  void _addPlayer(GameState gameState) {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      gameState.addPlayer(name);
      _nameController.clear(); // Limpiamos el input después de agregar
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Aquí nos conectamos al "Cerebro". Cada vez que gameState cambie, esta pantalla se redibuja.
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      // --- CÓDIGO NUEVO AÑADIDO AQUÍ ---
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Lo hace invisible para no romper tu diseño
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemesScreen()),
              );
            },
          ),
        ],
      ),      
      // SafeArea evita que la interfaz se solape con la cámara o el notch del celular
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Equivalente a p-6 / p-8
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'El Impostor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueAccent, // Equivalente a text-blue-400
                ),
              ),
              const SizedBox(height: 8), // Un espaciador (como margin-bottom)
              const Text(
                'Agrega de 3 a 10 jugadores para empezar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              
              // Fila para el input y el botón de "+"
              Row(
                children: [
                  // Expanded hace que el TextField ocupe todo el ancho disponible
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Nombre del jugador',
                        filled: true,
                        fillColor: Colors.grey[800], // bg-gray-700
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _addPlayer(gameState), // Agrega al presionar Enter en el teclado
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _addPlayer(gameState),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('+', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lista de jugadores dinámica
              Expanded(
                child: gameState.players.isEmpty
                    ? const Center(
                        child: Text(
                          'Aún no hay jugadores',
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      )
                    // ListView.builder es la forma óptima en móvil de renderizar listas
                    : ListView.builder(
                        itemCount: gameState.players.length,
                        itemBuilder: (context, index) {
                          final player = gameState.players[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue[100], // bg-blue-100
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  player,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900], // text-blue-800
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => gameState.removePlayer(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Botón de comenzar



              ElevatedButton(
                // Si la condición se cumple, se le asigna una función vacía por ahora. 
                // Si es nulo (null), Flutter deshabilita el botón automáticamente.
                onPressed: (gameState.players.length >= 3 && gameState.players.length <= 10)
                    ? () {
                        Navigator.push(
                        context,
                        // MaterialPageRoute genera la animación nativa (deslizar en iOS, fade/zoom en Android)
                        MaterialPageRoute(builder: (context) => const InstructionsScreen()),
                        );
                    }
                    : null,
 
 
 
 
 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600], // bg-green-600
                  disabledBackgroundColor: Colors.grey[700], // opacity-50 cursor-not-allowed
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Comenzar Juego',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),



            ],
          ),
        ),
      ),
    );





  }
}