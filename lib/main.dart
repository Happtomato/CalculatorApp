import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main(){
  runApp(Calculator());
}
  
class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: SimpleCalculator(),
    );
  }
}

class OldEquations extends StatelessWidget {
  const OldEquations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Old Equations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for(var item in oldEquations ) Text(item)
          ],
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Old Equations'),
      ),
      body: Center(

        child: Text("There are no old Equations"),
      ),
    );
  }
}


class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

List<String> oldEquations = [];

class _SimpleCalculatorState extends State<SimpleCalculator> {

  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  //function to update the number if a button is pressed
  buttonPressed(String buttonText){
    setState(() {
      //clear
      if(buttonText == "C"){
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      }
      //backspace
      else if(buttonText == "back"){
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if(equation == ""){
          equation = "0";
        }
      }

      else if(buttonText == "="){
        equationFontSize = 38.0;
        resultFontSize = 48.0;
        //parse through the equation and solve it
        try{
          Parser p = Parser();
          Expression exp = p.parse(equation);

          //set the result to the result of the equation
          ContextModel cm = ContextModel();

          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          String oldEquation = equation + " = " + result;
          bool exists = false;
          for(int i = 0; i < oldEquations.length; i++){
            if(oldEquations[i] == oldEquation){
              exists = true;
            }
          }
          if(!exists){
            oldEquations.add(oldEquation);
          }


        }catch(e){
          result = "Error";
        }
      }
      //go to the old equations and their results
      else if(buttonText == "old"){
        if(oldEquations.isEmpty){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ErrorPage()),
          );
        }
        else if(oldEquations.length >= 1){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OldEquations()),
          );
        }
      }
      //add the numbers to each other
      else{
        equationFontSize = 48.0;
        resultFontSize = 28.0;
        if(equation == "0"){
          equation = buttonText;
        }else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor){
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid
              )
          ),
          padding: EdgeInsets.all(16.0),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                color: Colors.white
            ),
          )
      ),
    );
  }

//bring the calculator to the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Calculator')),
      body: Column(
        children: <Widget>[

          Container(
            alignment: Alignment.topLeft,
            child: buildButton("old", 1, Colors.redAccent),
          ),

          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(result, style: TextStyle(fontSize: resultFontSize),),
          ),

          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(equation, style: TextStyle(fontSize: equationFontSize),),
          ),

          Expanded(
            child: Divider(),
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          buildButton("C", 1, Colors.redAccent),
                          buildButton("back", 1, Colors.blue),
                          buildButton("/", 1, Colors.blue),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("7", 1, Colors.black54),
                          buildButton("8", 1, Colors.black54),
                          buildButton("9", 1, Colors.black54),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("4", 1, Colors.black54),
                          buildButton("5", 1, Colors.black54),
                          buildButton("6", 1, Colors.black54),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("1", 1, Colors.black54),
                          buildButton("2", 1, Colors.black54),
                          buildButton("3", 1, Colors.black54),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton(".", 1, Colors.black54),
                          buildButton("0", 1, Colors.black54),
                          buildButton("00", 1, Colors.black54),
                        ]
                    ),
                  ],
                ),
              ),


              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          buildButton("*", 1, Colors.blue),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("-", 1, Colors.blue),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("+", 1, Colors.blue),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("=", 2, Colors.redAccent),
                        ]
                    ),
                  ],
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}