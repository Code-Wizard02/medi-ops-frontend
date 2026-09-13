import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class PrivacyNoticeDialog extends StatelessWidget {
  const PrivacyNoticeDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const PrivacyNoticeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(l10n.privacyNoticeTitle),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: colorScheme.onErrorContainer),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'ESTO ES UN TEMPLATE DE PRUEBA',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onErrorContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.privacyNoticeTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Este documento es un marcador de posición (placeholder) para el futuro Aviso de Privacidad de MediOps. '
                      'El contenido legal y las normativas aplicables se insertarán aquí antes del lanzamiento a producción.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'En este espacio se detallarán aspectos como:',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const _BulletPoint('Identidad y domicilio del responsable.'),
                    const _BulletPoint(
                        'Datos personales que serán sometidos a tratamiento.'),
                    const _BulletPoint('Finalidades del tratamiento de datos.'),
                    const _BulletPoint(
                        'Opciones y medios para limitar el uso o divulgación de los datos.'),
                    const _BulletPoint(
                        'Medios para ejercer los derechos ARCO (Acceso, Rectificación, Cancelación y Oposición).'),
                    const _BulletPoint('Transferencias de datos.'),
                    const _BulletPoint('Cambios al Aviso de Privacidad.'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18, height: 1.2)),
          Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
