import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),  // Color violeta claro para borde
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2),  // Color violeta al enfocar
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),  // Color violeta claro para borde
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2),  // Color violeta al enfocar
          ),
        ),
      ),
      themeMode: _themeMode,
      home: HomePage(toggleThemeMode: toggleThemeMode),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback toggleThemeMode;

  const HomePage({required this.toggleThemeMode});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    BaseConversionScreen(),
    CurrencyConverterScreen(),
    PrimeNumberCheckerScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text('EXAMEN 2do PARCIAL'),
        backgroundColor: brightness == Brightness.light ? Colors.blueGrey : Colors.black,
      ),
      body: Stack(
        children: [
          // Imagen de fondo desde la URL
          Positioned.fill(
            child: Image.network(
              'https://img.freepik.com/fotos-premium/fondo-azul-rosa-circulos_327903-2726.jpg?ga=GA1.1.1363326330.1710356592&semt=ais_hybrid',  
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          // Pantalla principal
          Positioned.fill(
            child: Column(
              children: [
                Expanded(child: _screens[_currentIndex]),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Bases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Moneda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Primos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.toggleThemeMode,
        child: Icon(Icons.brightness_6),
        backgroundColor: Colors.blueAccent,
        heroTag: null,
      ),
    );
  }
}

// Primera pantalla: Conversión de Bases
class BaseConversionScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Caja de texto personalizada
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Ingresa un número decimal',
              hintText: 'Ejemplo: 255',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.purple),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.purple, width: 2),
              ),
              prefixIcon: Icon(Icons.keyboard),
            ),
          ),
          SizedBox(height: 20),
          // Botón con animación de escala
          AnimatedButton(
            onPressed: () {
              int? number = int.tryParse(_controller.text);
              if (number != null) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Conversión'),
                    content: Text(
                      'Binario: ${number.toRadixString(2)}\n'
                      'Octal: ${number.toRadixString(8)}\n'
                      'Hexadecimal: ${number.toRadixString(16)}',
                    ),
                  ),
                );
              }
            },
            child: Text('Convertir'),
          ),
        ],
      ),
    );
  }
}

// Animación para el botón
class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AnimatedButton({required this.onPressed, required this.child});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.9;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: widget.onPressed,
      child: Transform.scale(
        scale: _scale,
        child: ElevatedButton(
          onPressed: null, // We handle onTap manually
          child: widget.child,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
    );
  }
}

// Segunda pantalla: Conversor de Moneda
class CurrencyConverterScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final double conversionRate = 6.91;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Caja de texto personalizada
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Ingresa un monto',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  double? amount = double.tryParse(_controller.text);
                  if (amount != null) {
                    double result = amount / conversionRate;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Conversión'),
                        content: Text('$amount BOB = ${result.toStringAsFixed(2)} USD'),
                      ),
                    );
                  }
                },
                child: Text('BOB a USD'),
              ),
              ElevatedButton(
                onPressed: () {
                  double? amount = double.tryParse(_controller.text);
                  if (amount != null) {
                    double result = amount * conversionRate;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Conversión'),
                        content: Text('$amount USD = ${result.toStringAsFixed(2)} BOB'),
                      ),
                    );
                  }
                },
                child: Text('USD a BOB'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Tercera pantalla: Verificación de Número Primo
class PrimeNumberCheckerScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  bool isPrime(int number) {
    if (number <= 1) return false;
    for (int i = 2; i <= number ~/ 2; i++) {
      if (number % i == 0) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Caja de texto personalizada
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Ingresa un número',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              prefixIcon: Icon(Icons.numbers),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              int? number = int.tryParse(_controller.text);
              if (number != null) {
                bool result = isPrime(number);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Resultado'),
                    content: Text(result ? '$number es primo' : '$number no es primo'),
                  ),
                );
              }
            },
            child: Text('Verificar'),
          ),
        ],
      ),
    );
  }
}

// Cuarta pantalla: Configuración
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final homePage = context.findAncestorWidgetOfExactType<HomePage>();
          homePage?.toggleThemeMode();
        },
        child: Text('Cambiar Modo Claro/Oscuro'),
      ),
    );
  }
}
