import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_trade/customer.dart';
import 'package:skill_trade/presentation/screens/login_page.dart';
import 'package:skill_trade/presentation/screens/signup_page.dart';
import 'package:skill_trade/presentation/widgets/my_button.dart';
import 'package:skill_trade/presentation/widgets/services_card.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final List servicesCards = const [
    ServicesCard(
        imageUrl: 'assets/plumbing.jpg',
        title: "Plumbing Services",
        description:
            "Our expert plumbers are ready to tackle any plumbing issue in your home. From leaks to pipe installations, we ensure quality workmanship."),
    ServicesCard(
        imageUrl: 'assets/electrician.jpeg',
        title: "Electrical Work",
        description:
            "Need electrical repairs or installations? Our skilled electricians are trained to handle a wide range of electrical services, ensuring your home's safety."),
    ServicesCard(
        imageUrl: 'assets/hvac.jpg',
        title: "HVAC Maintainance",
        description:
            "Keep your home comfortable year-round with our HVAC maintenance services. Our technicians will keep your heating and cooling systems in top condition."),
    ServicesCard(
        imageUrl: 'assets/technician.jpg',
        title: "Satelite Dish Work",
        description:
            "Is your desh-technician acting up? Our technicians specialize in dish repair, ensuring your household devices work efficiently."),
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body:Center(
        child:SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icon(Icons.handyman_outlined, size: 75,),
                    Container(
                      height: 100,
                      child: Image.asset('assets/logo.jpg'),
                    ),
                    Text(
                      "SkillTrade Hub",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow.shade900),
                    ),
                    const Text("Welcome to the hub of skills!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("We Connect!",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyButton(
                            text: "login",
                            onPressed: () {
                              context.push("/login");
                            }),
                        const SizedBox(
                          width: 15,
                        ),
                        MyButton(
                            text: "signup",
                            onPressed: () {
                                  context.push("/signup");
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Find Skilled Technicians for Your Home Services",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(
                height: 7,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Efficiently connect with experts in plumbing, electrical work, HVAC, and more.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
              ),
              const SizedBox(
                height: 10,
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Our Services",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 500,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                  itemCount: servicesCards.length,
                  itemBuilder: (context, index) {
                    return servicesCards[index];
                  },
                ),
              ),

              Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey.shade300,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Copyright "),
                      Icon(Icons.copyright_rounded),
                      Text("all rights reserved.")
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
