import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class VerificationCodeInput extends HookWidget {
  const VerificationCodeInput({
    super.key,
    required this.controller,
    this.length = 6,
    this.onCompleted,
  });

  final TextEditingController controller;
  final int length;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final text = useValueListenable(controller).text;
    
    // Almacena el tiempo en el que se escribió cada índice para ocultarlo después de 5s.
    final timestamps = useRef<Map<int, DateTime>>({});
    // Fuerza la reconstrucción para el efecto del timer.
    useStream(Stream.periodic(const Duration(milliseconds: 500)));

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Detectar cambios y actualizar timestamps
    useEffect(() {
      void listener() {
        final currentText = controller.text;
        final now = DateTime.now();
        
        // Limpiar timestamps para índices que ya no existen
        timestamps.value.removeWhere((key, value) => key >= currentText.length);

        // Añadir timestamps para nuevos caracteres
        for (int i = 0; i < currentText.length; i++) {
          if (!timestamps.value.containsKey(i)) {
            timestamps.value[i] = now;
          }
        }

        if (currentText.length == length) {
          onCompleted?.call(currentText);
        }
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller, length, onCompleted]);

    bool isObscured(int index) {
      if (index >= text.length) return false;
      final timestamp = timestamps.value[index];
      if (timestamp == null) return false;
      
      final diff = DateTime.now().difference(timestamp);
      // Ocultar si pasaron 5 segundos, o si el foco se perdió y ya no se está escribiendo en el campo adyacente.
      // Simplificaremos: se oculta estrictamente después de 5 segundos de haberse escrito,
      // o si el usuario saltó a escribir 2 posiciones más adelante.
      if (diff.inSeconds >= 5) return true;
      if (text.length > index + 1) return true; // Se oculta inmediatamente cuando pasas al siguiente
      return false;
    }

    Widget buildBox(int index) {
      final isFilled = index < text.length;
      final isCurrent = index == text.length;
      final obscured = isObscured(index);
      
      String charToDisplay = '';
      if (isFilled) {
        charToDisplay = obscured ? '•' : text[index];
      }

      final borderColor = isCurrent 
          ? colorScheme.primary 
          : isFilled 
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outline;
              
      final backgroundColor = isFilled 
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : Colors.transparent;

      return GestureDetector(
        onTap: () => focusNode.requestFocus(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 64,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: isCurrent ? 2 : 1),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            charToDisplay,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: isFilled ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        // TextField invisible para manejar el teclado nativo y el portapapeles.
        Opacity(
          opacity: 0,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            maxLength: length,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(counterText: ''),
            onChanged: (val) {
              // Si pegan el código completo, quitar el foco.
              if (val.length == length) {
                focusNode.unfocus();
              }
            },
          ),
        ),
        // UI Visible
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(length, buildBox),
        ),
      ],
    );
  }
}
