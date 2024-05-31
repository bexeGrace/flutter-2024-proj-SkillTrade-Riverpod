import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/auth_state.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authState = ref.watch(authNotifierProvider);
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Image.asset(
                "assets/logo.jpg",
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(color: Colors.grey[800]),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  title: Text(
                    "About",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.feedback,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Feedback",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.rule,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Rules and Regulations",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextButton(
                    child: const ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      // await unlog(context);
                      ref.read(authNotifierProvider.notifier).unlog();
                      GoRouter.of(context).go('/');
                    }),
              ),
              Consumer(builder: (context, ref, child) {
                if (authState is LoggedIn) {
                  if (authState.role != "admin") {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 25.0),
                      child: TextButton(
                          child: const ListTile(
                            leading: Icon(
                              Icons.delete_rounded,
                              color: Colors.red,
                            ),
                            title: Text(
                              "Delete Account",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          onPressed: () async {
                            ref.read(authNotifierProvider.notifier).deleteAccount();
                            GoRouter.of(context).go('/');
                          }),
                    );
                  } else {
                    return const SizedBox(
                      height: 15,
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 15,
                  );
                }
              }),
            ],
          ),

          
        ],
      ),
    );
  }

}