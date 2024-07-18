import 'package:aqua_terra_manager/constants.dart';
import 'package:aqua_terra_manager/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _State();
}

class _State extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    const imageHeight = 400.0;
    const overlap = 50.0;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/bearded-dragon.jpg',
                height: imageHeight,
                fit: BoxFit.cover,
              ),
              // Use Transform and SizedBox to overlap and fill remaining space
              Container(
                decoration: _buildBoxDecoration(context),
                margin: const EdgeInsets.only(top: imageHeight - overlap),
                child: Padding(
                  padding: EdgeInsets.all(SizeConstants.s600),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: SizeConstants.s700),
                        child: Column(children: [
                          Icon(
                            Icons.manage_accounts_rounded,
                            size: SizeConstants.s600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            'Aqua-Terra\nManager'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                      ),
                      const SignInForm()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(30),
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 25,
          offset: const Offset(0, -25),
        ),
      ],
    );
  }
}
