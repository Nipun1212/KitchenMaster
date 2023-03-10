import 'package:flutter/material.dart';
import 'profile.dart';

class AlertsPage extends StatefulWidget {
  AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}
class AlertWidget extends StatefulWidget {
  String name = '';
  String duration = 'None';
  TextEditingController _nameController = TextEditingController();

  AlertWidget(TextEditingController n, String d) {
    this._nameController = n;
    this.name = n.text;
    this.duration = d;
  }

  @override
  State<AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  String name = '';
  String duration = 'None';
  TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xbbff6961),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          color: Colors.black,
          ),
        ) ,
        child: Center(
            child: SizedBox(
                width: 400,
                height: 60,
                child: Row(children: <Widget>[
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                    ),
                  ),
                  SizedBox(width: 10,),
                  VerticalDivider(width: 2,color: Colors.black), //Check why it doesn't show up
                  SizedBox(width: 10,),
                  DropdownButton<String>(
                    value: duration,

                    items: <String>['None', '1 Week', '2 Weeks', '3 Weeks', '1 Month']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),

                    onChanged: (String? newValue) {
                      setState(() {
                        duration = newValue!;
                      });
                    },
                  ),
                  SizedBox(width: 10,),
                ]))));
  }
}
class _AlertsPageState extends State<AlertsPage> {
  List<AlertWidget> listCards = [];
  List<TextEditingController> controllers = [];
  TextEditingController _nameController = new TextEditingController();
  String duration = 'None';

  addAlert(TextEditingController n, String d) {
    controllers.add(n);
    listCards.add(new AlertWidget(n, d));
    setState(() {});
  }

    @override
  Widget build(BuildContext context) {
      return MaterialApp(
          home: Scaffold(
              backgroundColor: Color(0xffe5e5e5),
              body: Column(children: <Widget>[
                SizedBox(height: 25),
                const Text('Alerts',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inria Serif',
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                        height: 1)),

                Container(
                    width: 400,
                    height: 610,
                    child:Flexible(

                  child: new ListView.builder(
                      itemCount: listCards.length,
                      itemBuilder: (_, index) {
                        final item = listCards[index];
                         return Dismissible(
                            key: Key(index.toString() ),
                            onDismissed: (direction) {
                                setState(() {
                                  listCards.removeAt(index);
                              });

                              // Then show a snackbar.
                              ScaffoldMessenger.of(context)
                        .       showSnackBar(SnackBar(content: Text('$item dismissed')));
                              },
                           background: Container(color: Colors.red, alignment: AlignmentDirectional.centerEnd, child: Icon(Icons.delete_sweep, size: 40,),),
                          child: item,
                );}
              ))),
            SizedBox(height: 30,),
            Row(children: [
              Spacer(),
              ElevatedButton(
                    onPressed: (){
                      TextEditingController _nameController = new TextEditingController();
                      addAlert(_nameController, 'None');
                    },

                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(width: 1.5, color: Color(0xffff6961))
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(Color(0xffff6961)),),
                    child: Row(
                      children: <Widget>[
                        Text("Add New Alert", selectionColor: Color(0xffff6961), style: TextStyle(fontSize: 15, fontFamily: 'IM FELL English SC'),),
                        SizedBox(width: 5,),
                        Icon(Icons.add_alert_outlined, color: Color(0xffff6961),),
                      ],)),
              Spacer(),
            ])
              ]),
              // floatingActionButton: ElevatedButton(
              //   child: Text('Add New Alert'),
              //
              //   onPressed: () {
              //     TextEditingController _nameController =
              //     new TextEditingController();
              //     addAlert(_nameController, 'None');
              //   },
              // )

          ));


  }
}