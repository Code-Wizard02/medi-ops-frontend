import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/full_name.dart';
import '../../domain/value_objects/password.dart';
import '../cubits/register_cubit.dart';
import '../cubits/register_state.dart';
import 'auth_text_field.dart';
import 'privacy_notice_dialog.dart';

class RegisterFormWidget extends HookWidget {
  const RegisterFormWidget({super.key, this.tabSelector});

  final Widget? tabSelector;

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    void submit() {
      if (!formKey.currentState!.validate()) return;
      context.read<RegisterCubit>().submit(
            fullName: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
            privacyVersion: '2026.1',
          );
    }

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSucceeded) {
          final registeredEmail = emailController.text.trim();
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          context.go('/verify-email', extra: registeredEmail);
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        final errorMessage = state is RegisterFailed ? state.message : null;

        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.signUpTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.signUpSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (tabSelector != null) ...[
                const SizedBox(height: 24),
                tabSelector!,
              ],
              const SizedBox(height: 24),
              AuthTextField(
                controller: nameController,
                label: l10n.fullNameLabel,
                hintText: l10n.fullNameHint,
                prefixIcon: Icons.person_outline,
                validator: (value) => FullName(value ?? '').validate(),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormField<bool>(
                    initialValue: false,
                    validator: (value) => value == true ? null : l10n.privacyNoticeRequired,
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: state.value,
                                onChanged: (value) => state.didChange(value),
                                isError: state.hasError,
                              ),
                              GestureDetector(
                                onTap: () => PrivacyNoticeDialog.show(context),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${l10n.privacyNoticeCheckbox} ',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      TextSpan(
                                        text: l10n.privacyNoticeLink,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                              child: Text(
                                state.errorText!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
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
                      child: Text(l10n.signUpButton),
                    ),
            ],
          ),
        );
      },
    );
  }
}