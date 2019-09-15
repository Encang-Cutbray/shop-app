import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class ExampleForm extends StatefulWidget {
  static const routeName = '/example-form';
  @override
  _ExampleFormState createState() => _ExampleFormState();
}

class _ExampleFormState extends State<ExampleForm> {
  final _exampleForm = GlobalKey<FormState>();

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
