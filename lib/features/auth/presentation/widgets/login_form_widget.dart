import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import 'auth_text_field.dart';

class LoginFormWidget extends HookWidget {
  const LoginFormWidget({super.key, this.tabSelector});

  final Widget? tabSelector;

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    void submit() {
      if (!formKey.currentState!.validate()) return;
      context.read<AuthCubit>().signIn(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
    }

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/home');
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final errorMessage = state is AuthFailureState ? state.message : null;

        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.signInTab,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.signInSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (tabSelector != null) ...[
                const SizedBox(height: 24),
                tabSelector!,
              ],
              const SizedBox(height: 32),
              AuthTextField(
                controller: emailController,
                label: l10n.emailLabel,
                hintText: l10n.emailHint,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Email(value ?? '').validate(),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: passwordController,
                label: l10n.passwordLabel,
                hintText: l10n.passwordHint,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                validator: (value) => Password(value ?? '').validate(),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: TextStyle(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: submit,
                      child: Text(l10n.continueButton),
                    ),
            ],
          ),
        );
      },
    );
  }
}