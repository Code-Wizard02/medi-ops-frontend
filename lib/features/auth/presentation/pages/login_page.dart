import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/register_cubit.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/auth_hero_panel.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/login_form_widget.dart';
import '../widgets/register_form_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthCubit>()..initialize()),
        BlocProvider(create: (_) => serviceLocator<RegisterCubit>()),
      ],
      child: const _AuthView(),
    );
  }
}

class _AuthView extends HookWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) {
    final selectedTabIndex = useState(0);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    void googleSignIn() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign In coming soon')),
      );
    }

    // ── Tab Selector ──
    Widget buildTabSelector() {
      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => selectedTabIndex.value = 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedTabIndex.value == 0
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.signInTab,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: selectedTabIndex.value == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selectedTabIndex.value == 0
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => selectedTabIndex.value = 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedTabIndex.value == 1
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.signUpTab,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: selectedTabIndex.value == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selectedTabIndex.value == 1
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── Social Footer ──
    Widget buildSocialFooter() {
      return Column(
        children: [
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outline)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.orContinueWith,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colorScheme.outline)),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [GoogleSignInButton(onPressed: googleSignIn)],
          ),
        ],
      );
    }

    final formContent = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AuthHeaderWidget(),
          const SizedBox(height: 32),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubicEmphasized,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child: selectedTabIndex.value == 0
                  ? KeyedSubtree(
                      key: const ValueKey('login'),
                      child: LoginFormWidget(tabSelector: buildTabSelector()),
                    )
                  : KeyedSubtree(
                      key: const ValueKey('register'),
                      child:
                          RegisterFormWidget(tabSelector: buildTabSelector()),
                    ),
            ),
          ),
          buildSocialFooter(),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          if (isDesktop) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                  maxHeight: 700,
                ),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: formContent),
                      const Expanded(flex: 6, child: AuthHeroPanel()),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: formContent,
            ),
          );
        },
      ),
    );
  }
}