import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';
import 'discussion_screen.dart';

class TurnScreen extends StatefulWidget {
  const TurnScreen({super.key});

  @override
  State<TurnScreen> createState() => _TurnScreenState();
}

class _TurnScreenState extends State<TurnScreen> {
  bool _isReadyToReveal = false; // Controla si mostramos "Pásale el teléfono" o "Mantén presionado"
  bool _isHolding = false;       // Controla si el dedo está físicamente tocando la pantalla
  bool _hasSeenRole = false;     // Controla si ya vio el rol y debe pasar el turno

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    
    // Obtenemos los datos del jugador actual
    final currentPlayerName = gameState.players[gameState.currentPlayerIndex];
    final isImpostor = gameState.currentPlayerIndex == gameState.impostorIndex;

    return Scaffold(
      body: SafeArea(
        // Cambiamos la interfaz dependiendo de en qué parte del turno estamos
        child: !_isReadyToReveal
            ? _buildPassPhoneState(currentPlayerName)
            : _buildRevealState(currentPlayerName, isImpostor, gameState.currentTheme, gameState),
      ),
    );
  }

  // INTERFAZ 1: Pásale el teléfono
  Widget _buildPassPhoneState(String playerName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone_android, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 24),
            const Text('Pásale el teléfono a:', style: TextStyle(fontSize: 20, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              playerName,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isReadyToReveal = true; // Avanzamos a la parte de revelar
                  _hasSeenRole = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              ),
              child: Text('Soy $playerName', style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // INTERFAZ 2: Mantener presionado para revelar
  Widget _buildRevealState(String playerName, bool isImpostor, String theme, GameState gameState) {
    return GestureDetector(
      // Cuando el dedo TOCA la pantalla
      onTapDown: (_) {
        if (!_hasSeenRole) setState(() => _isHolding = true);
      },
      // Cuando el dedo SE LEVANTA de la pantalla
      onTapUp: (_) {
        if (_isHolding) setState(() { _isHolding = false; _hasSeenRole = true; });
      },
      // Si desliza el dedo fuera y se cancela el toque
      onTapCancel: () {
        if (_isHolding) setState(() { _isHolding = false; _hasSeenRole = true; });
      },
      
      // Envolvemos todo en un Container transparente que ocupa toda la pantalla
      // para que el GestureDetector detecte toques en cualquier lado
      child: Container(
        color: Colors.transparent, 
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CASO A: Aún no presiona
            if (!_isHolding && !_hasSeenRole) ...[
              const Icon(Icons.fingerprint, size: 100, color: Colors.grey),
              const SizedBox(height: 24),
              const Text('Mantén presionado para ver tu rol', style: TextStyle(fontSize: 20, color: Colors.white)),
              const Text('(Se ocultará al soltar)', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ] 
            // CASO B: Está presionando (Viendo el rol)
            else if (_isHolding) ...[
              Text(
                isImpostor ? 'ERES EL IMPOSTOR' : 'EL TEMA ES:',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isImpostor ? Colors.redAccent : Colors.amber,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isImpostor ? '¡Que no te descubran!' : theme,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ] 
            // CASO C: Ya soltó el dedo (Listo para pasar al siguiente)
            else if (_hasSeenRole) ...[
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text('Rol oculto de forma segura', style: TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Verificamos si aún faltan jugadores
                  if (gameState.currentPlayerIndex < gameState.players.length - 1) {
                    gameState.nextTurn(); // El "cerebro" avanza el turno
                    setState(() {
                      _isReadyToReveal = false; // Reiniciamos la vista para el siguiente jugador
                    });
                  } else {
                    // Si ya pasaron todos, navegaremos a la Discusión (Lección 5)
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DiscussionScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                ),
                child: const Text('Siguiente', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}