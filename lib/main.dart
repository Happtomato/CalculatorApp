/*******************************************************
PROGRAM NAME - Calculator

PROGRAMMER - Dominik Dierberger

DATE - Started 26.01.2022
*******************************************************/

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

//starter Method
void main(){
  runApp(Calculator());
}

//set homepage and theme for the calculator
class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.orange, scaffoldBackgroundColor: Colors.black),
      home: SimpleCalculator(),
    );
  }
}

//this page will display the old equations and their results
class OldEquations extends StatelessWidget {
  const OldEquations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Old Equations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for(var item in oldEquations ) Text(item,style: TextStyle(fontSize: 20,color: Colors.white),)
          ],
        ),
      ),
    );
  }
}

//this page will display an error if the user decides
// to view the old equations page without any old equations Existing
class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(

        child: Text("There are no old Equations",style: TextStyle(fontSize: 30,color: Colors.white),),
      ),
    );
  }
}

//this class will update the Simple calculator page
class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

//this list holds all the old equations
List<String> oldEquations = [];

//this class will display the calculator page and control the button mechanic
class _SimpleCalculatorState extends State<SimpleCalculator> {

  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;
  Color fontColor = Colors.white;

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
      else if(buttonText == "←"){
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
        else if(oldEquations.isNotEmpty){
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
              side: const BorderSide(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid
              )
          ),
          padding: const EdgeInsets.all(16.0),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
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
      appBar: AppBar(title: const Text('Simple Calculator')),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(result,
              style: TextStyle(fontSize: resultFontSize,color: Colors.white),),
          ),

          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(equation, style: TextStyle(fontSize: equationFontSize,color: Colors.white),),
          ),

          const Expanded(
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
                          buildButton("C", 1, Colors.orange),
                          buildButton("*", 1, Colors.black),
                          buildButton("/", 1, Colors.black),

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
                            buildButton("old", 1, Colors.orange),
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
                          buildButton("←", 1, Colors.orange),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("-", 1, Colors.black),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("+", 1, Colors.black),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("=", 2, Colors.orange),
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