import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController();
  int selectId = 0;
  int activePage = 0;

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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
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
                    child: const Row(
                      children: [
                        SizedBox(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                            ),
                          ),
                        ),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  ? Colors.green
                                  : Colors.black.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                          if (selectId == i)
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.green,
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

  Widget mainPlantsCard(int index) {
    return GestureDetector(
      onTap: () {
        // Handle tap on the card
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(color: Colors.green, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                border: Border.all(color: Colors.green, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Image.asset('assets/images/OIP.jpg'),
               // Replace with the desired Icon
            ),
            Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(backgroundColor: Colors.green,
              radius: 15,
              child: const Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:Text("descriptions") ,
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final String name;

  Category(this.name);
}

List<Category> categories = [
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

