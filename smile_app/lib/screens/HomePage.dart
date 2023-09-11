import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController();

  @override
  void initState() {
    controller = PageController(viewportFraction: 0.6, initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(color: Colors.green),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    
                    ),
                  const SizedBox(width: 10),
                  Container(
                    height: 45,
                    width: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.green),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.adjust,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < categories.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectId = i;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            categories[i].name,
                            style: TextStyle(
                              color: selectId == i
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.black.withOpacity(0.7),
                              fontSize: 24,
                            ),
                          ),
                          if (selectId == i)
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                            )
                        ],
                      ),
                    )
                ],
              ),
            ),
            SizedBox(
              height: 320,
              child: PageView.builder(
                itemCount: plants.length,
                physics: BouncingScrollPhysics(),
                padEnds: false,
                pageSnapping: true,
                onPageChanged: (value) => setState(() => activePage = value),
                itemBuilder: (context, index) {
                  bool active = index == activePage;
                  return slider(active, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer slider(bool active, int index) {
    double margin = active ? 20 : 30;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInCubic,
      margin: EdgeInsets.all(margin),
      child: mainPlantsCard(index),
    );
  }

  GestureDetector mainPlantsCard(int index) {
    return GestureDetector(
      onTap: () {
        // Handle tap on the card
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.green),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 0),
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        // ... (other card content)
      ),
    );
  }

  int selectId = 0;
  int activePage = 0;
}

class Category {
  final String name;

  Category(this.name);
}

List<Category> categories = [
  Category('ALL'),
  Category('Category 1'),
  Category('Category 2'),
  Category('Category 3'),
   Category('ALL'),
  Category('Category 1'),
  Category('Category 2'),
  Category('Category 3'),
  // ... add more categories
];

List<Plant> plants = [
  Plant('Plant 1'),
  Plant('Plant 2'),
  Plant('Plant 3'),
  // ... add more plants
];

class Plant {
  final String name;

  Plant(this.name);
}
