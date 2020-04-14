import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'contact.dart';


class get_report extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return new MaterialApp(
    title: 'Report Motor Accident',
    theme: new ThemeData(
      primarySwatch: Colors.teal,
    ),
    home: new BodyLayout(title: 'Report Motor Accident'),
  );
}
}
  class BodyLayout extends StatefulWidget {
  BodyLayout({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BodyLayoutState createState() => new _BodyLayoutState();
  }

  class _BodyLayoutState extends State<BodyLayout> {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    List<String> _options = <String>[
      '', 'Yes', 'No'];
    String _option = '';
    Contact newContact = new Contact();
    final TextEditingController _controller = new TextEditingController();

    Future<Null> _chooseDate(
        BuildContext context, String initialDateString) async {
      var now = new DateTime.now();
      var initialDate = convertToDate(initialDateString) ?? now;
      initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
          ? initialDate
          : now);

      var result = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: new DateTime(1900),
          lastDate: new DateTime.now());

      if (result == null) return;

      setState(() {
        _controller.text = new DateFormat.yMd().format(result);
      });
    }

    bool isValidDob(String dob) {
      if (dob.isEmpty) return true;
      var d = convertToDate(dob);
      return d != null && d.isBefore(new DateTime.now());
    }

    DateTime convertToDate(String input) {
      try {
        var d = new DateFormat.yMd().parseStrict(input);
        return d;
      } catch (e) {
        return null;
      }
    }

    bool isValidPhoneNumber(String input) {
      final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
      return regex.hasMatch(input);
    }


    void showMessage(String message, [MaterialColor color = Colors.red]) {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(backgroundColor: color, content: new Text(message)));
    }

    void _submitForm() {
      final FormState form = _formKey.currentState;

      if (!form.validate()) {
        showMessage('Form is not valid!  Please review and correct.');
      } else {
        form.save(); //This invokes each onSaved event


      }
    }

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new SafeArea(
            top: false,
            bottom: false,
            child: new Form(
                key: _formKey,
                autovalidate: true,
                child: new ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    new TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.directions_car),
                        labelText: 'Vehicle Reg No',

                      ),
            inputFormatters: [new LengthLimitingTextInputFormatter(80)],
            validator: (val) => val.isEmpty ? 'Vehicle Reg No is required' : null,

                      onSaved: (val) => newContact.vehiclereg = val,
                    ),
                    new TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.transfer_within_a_station),
                        //hintText: 'Accident Street/ Road Name',
                        labelText: 'Accident Street/ Road Name',
                      ),
                      inputFormatters: [new LengthLimitingTextInputFormatter(80)],
                      validator: (val) => val.isEmpty ? 'Accident Street/ Road Name is required' : null,
                      onSaved: (val) => newContact.streetname = val,
                    ),
                    new TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.account_balance),
                        labelText: 'Accident Area Name',

                      ),
                      inputFormatters: [new LengthLimitingTextInputFormatter(80)],
                      validator: (val) => val.isEmpty ? 'Accident Area Name is required': null,
                      onSaved: (val) => newContact.areaname = val,
                    ),
                    new Row(children: <Widget>[
                      new Expanded(
                          child: new TextFormField(
                            decoration: new InputDecoration(
                              icon: const Icon(Icons.calendar_today),
                              //hintText: 'Enter date of the Accident',
                              labelText: 'Enter date of the Accident',
                            ),
                            controller: _controller,
                            keyboardType: TextInputType.datetime,
                            validator: (val) =>
                            isValidDob(val) ? null : 'Not a valid date',
                            onSaved: (val) => newContact.accidentdate = convertToDate(val),
                          )),
                      new IconButton(
                        icon: new Icon(Icons.more_horiz),
                        tooltip: 'Choose date',
                        onPressed: (() {
                          _chooseDate(context, _controller.text);
                        }),
                      )
                    ]),
                    new TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.phone),
                        //hintText: 'Enter a phone number',
                        labelText: 'Enter a phone number',
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        new WhitelistingTextInputFormatter(
                            new RegExp(r'^[()\d -]{1,15}$')),
                      ],
                      validator: (value) => isValidPhoneNumber(value)
                          ? null
                          : 'Phone number must be entered as (###)###-####',
                      onSaved: (val) => newContact.phone = val,
                    ),

                    new FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.local_car_wash),
                            labelText: 'Other Vehicles Involved?',
                            errorText: state.hasError ? state.errorText : null,
                          ),
                          isEmpty: _option == '',
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              value: _option,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  newContact.favoriteColor = newValue;
                                  _option = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _options.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                      validator: (val) {
                        return val != '' ? null : 'Please select one';
                      },
                    ),
                    new Container(
                        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                        child: new RaisedButton(
                          child: const Text('Submit'),
                          onPressed: _submitForm,
                        )),
                  ],
                ))),
      );
    }
   }