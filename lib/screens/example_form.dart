import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class ExampleForm extends StatefulWidget {
  static const routeName = '/example-form';
  @override
  _ExampleFormState createState() => _ExampleFormState();
}

class _ExampleFormState extends State<ExampleForm> {
  final _exampleForm = GlobalKey<FormState>();

  int counter = 1;
  // @override
  // void initState() {
  //   print('[Init state before] $counter');
  //   counter++;
  //   print('[Init state after] $counter');

  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    print(counter);
    setState(() {
      print('[Counter before setState()] $counter');
      counter++;
      print('[Counter after setState()] $counter');
    });
    counter++;
    print('[change the counter] $counter');
    print('\n');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Form'),
      ),
      drawer: AppDrawer(),
      body: Builder(
        builder: (context) => Container(
          child: Form(
            key: _exampleForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: RaisedButton(
                    onPressed: () {
                      if (_exampleForm.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
