import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  var cards = <Card>[];

  void initState() {
    super.initState();
    // cards.add(_SOFState.createCard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //     body: Center(
        //         child: Column(children: <Widget>[
        //   const Text('Inventory List',
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //           color: Color.fromRGBO(0, 0, 0, 1),
        //           fontFamily: 'Inria Serif',
        //           fontSize: 40,
        //           letterSpacing: 0,
        //           fontWeight: FontWeight.normal,
        //           height: 1)),
        //   Flexible(
        //     child: new ListView.builder(
        //         itemCount: cards.length,
        //         itemBuilder: (_, index) => listDynamic[index]),
        //   ),
        //   ElevatedButton(
        //     child: Text('Add entries'),
        //     onPressed: () async {
        //       List<InventoryEntry> persons = await Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => SOF(),
        //         ),
        //       );
        //       if (persons != null) persons.forEach(print);
        //     },
        //   ),
        // ]))
        );
  }
}

// class DynamicWidget extends StatelessWidget {
//   // String name = '';
//   var counts = <int>[];
//   var nameFields = <TextEditingController>[];
//   Card newcard = Card();

//   DynamicWidget(Card newcard) {
//     this.newcard = newcard;
//   }

//   Card createCard() {
//     var nameController = TextEditingController();
//     int count = 0;
//     nameFields.add(nameController);
//     counts.add(count);
//     return Card(
//         child: SizedBox(
//             width: 300,
//             height: 100,
//             child: Row(children: <Widget>[
//               TextField(
//                 controller: nameController,
//               ),
//               IconButton(
//                   icon: const Icon(Icons.add_circle_outline),
//                   onPressed: () {
//                     count += 1;
//                   }),
//               Text('$count'),
//               IconButton(
//                   icon: const Icon(Icons.remove_circle_outline),
//                   onPressed: () {
//                     count -= 1;
//                   })
//             ])));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return createCard();
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     // appBar: AppBar(),
//   //     body: Column(
//   //       children: <Widget>[
//   //         Flexible(
//   //           child: new ListView.builder(
//   //             itemCount: cards.length,
//   //             itemBuilder: (BuildContext context, int index) {
//   //               return cards[index];
//   //             },
//   //           ),
//   //         ),
//   //         Padding(
//   //           padding: const EdgeInsets.all(16.0),
//   //           child: ElevatedButton(
//   //             child: Text('Add New'),
//   //             onPressed: () => setState(() => cards.add(createCard())),
//   //           ),
//   //         )
//   //       ],
//   //     ),
//   //     floatingActionButton:
//   //         FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
//   //   );
//   // }
// }

// class InventoryEntry {
//   final String name;
//   final int count;

//   InventoryEntry(this.name, this.count);
//   @override
//   String toString() {
//     return 'InventoryItem: name= $name, count= $count';
//   }
// }
