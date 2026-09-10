import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../cubits/verify_email_cubit.dart';
import '../cubits/verify_email_state.dart';
import '../widgets/verification_code_input.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<VerifyEmailCubit>(),
      child: _VerifyEmailView(email: email),
    );
  }
}

class _VerifyEmailView extends HookWidget {
  const _VerifyEmailView({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final codeController = useTextEditingController();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    void submit() {
      context.read<VerifyEmailCubit>().submit(
            email: email,
            code: codeController.text.trim(),
          );
    }

    void resendCode() {
      context.read<VerifyEmailCubit>().resendCode(email: email);
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text('Verificar Correo')),
      body: BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
        listener: (context, state) {
          if (state is VerifyEmailSucceeded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Correo verificado exitosamente. Ya puedes iniciar sesión.'),
              ),
            );
            context.go('/');
          } else if (state is VerifyEmailFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is CodeResentSucceeded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Se ha reenviado el código de verificación a tu correo.'),
              ),
            );
          } else if (state is CodeResentFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is VerifyEmailLoading;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'Hemos enviado un código de 6 dígitos a $email.',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  VerificationCodeInput(
                    controller: codeController,
                    length: 6,
                    onCompleted: (val) => submit(),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Verificar Cuenta'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: isLoading ? null : resendCode,
                    child: const Text('Reenviar código'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
