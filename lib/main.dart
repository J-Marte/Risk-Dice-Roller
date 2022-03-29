/*
* Copyright 2022 Johannes Marte
*
* Lizenziert unter der EUPL, Version 1.1 oder - sobald
diese von der Europäischen Kommission genehmigt wurden -
Folgeversionen der EUPL ("Lizenz");
* Sie dürfen dieses Werk ausschließlich gemäß
dieser Lizenz nutzen.
* Eine Kopie der Lizenz finden Sie hier:
*
* https://joinup.ec.europa.eu/software/page/eupl
*
* Sofern nicht durch anwendbare Rechtsvorschriften
gefordert oder in schriftlicher Form vereinbart, wird
die unter der Lizenz verbreitete Software "so wie sie
ist", OHNE JEGLICHE GEWÄHRLEISTUNG ODER BEDINGUNGEN -
ausdrücklich oder stillschweigend - verbreitet.
* Die sprachspezifischen Genehmigungen und Beschränkungen
unter der Lizenz sind dem Lizenztext zu entnehmen.
*/

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:risiko_wuerfler/presentation/risk_dice_roller_icons.dart';
import 'package:risiko_wuerfler/true_random.dart';


void main() {
  runApp(const MyApp());
  TrueRandomDice.getQuota();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risk Dice Roller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Risk Dice Roller'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  int leftPlayerMax = 0;
  int rightPlayerMax = 0;
  
  int leftPlayer = 0;
  int rightPlayer = 0;
 
  int leftThreshold = 0;
  int rightThreshold = 0;

  TextEditingController leftController = TextEditingController();
  TextEditingController rightController = TextEditingController();

  String? errorStringLeft; 
  String? errorStringLeftThreshold; 
  String? errorStringRight;
  String? errorStringRightThreshold; 

  bool leftThresholdEnable = false;
  bool rightThresholdEnable = false;

  FocusNode leftNode = FocusNode();
  FocusNode leftThresholdNode = FocusNode();
  FocusNode rightNode = FocusNode();
  FocusNode rightThresholdNode = FocusNode();

  bool playing = false;
  bool lastRollFailed = false;
  DateTime lastTimeRollFailed = DateTime(2000);

  // handel the generation of the dice values 
  Future<List<int>> getDice(int amount) async {
    List<int> erg = [];
    if(lastRollFailed && DateTime.now().difference(lastTimeRollFailed).compareTo(const Duration(seconds: 10)) < 0){
      for(int i = 0; i < amount; i++){
        erg.add(Random().nextInt(5) + 1);
      }
    }else{
      try {
        erg = await TrueRandomDice.getDice(amount);
        lastRollFailed = false;
      } catch (e) {
        lastTimeRollFailed = DateTime.now();

        if(!lastRollFailed){
          setState(() {
            playing = false;
          });
          Fluttertoast.showToast(
            msg: "can't get true random from random.org switching to pseudo random",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
          );
          lastRollFailed = true;
        }else{
          for(int i = 0; i < amount; i++){
            erg.add(Random().nextInt(5) + 1);
          }
        }
      }
    }
    return erg;
  }


  void play() async {
    if(playing){
      setState(() {
        playing = false;
      });
      return;
    }
    playing = true;

    while(leftPlayer > 0){
      if((leftPlayer <= leftThreshold && leftThresholdEnable) || (rightPlayer <= rightThreshold && rightThresholdEnable)){
        setState(() {
          playing = false;
        });
        return;
      }

      if(leftPlayer > 2 && rightPlayer > 1){
        int dicesLeft = min(leftPlayer - 1, 3);
        List<int> dices = await getDice(dicesLeft + 2);    
        if(dices.length != dicesLeft + 2) return;
        List<int> left = dices.sublist(0,dicesLeft);
        List<int> right = dices.sublist(dicesLeft, dicesLeft + 2);
        left.sort((x,y) => y.compareTo(x));
        right.sort((x,y) => y.compareTo(x));

        setState(() {  
          if(left[0] > right[0] && left[1] > right[1]){
            rightPlayer -= 2;
          }else if((left[0] > right[0] && left[1] <= right[1]) || (left[0] <= right[0] && left[1] > right[1])){
            rightPlayer -= 1;
            leftPlayer -= 1;
          }else{
            leftPlayer -= 2;
          }
          leftController.text = leftPlayer.toString();
          rightController.text = rightPlayer.toString();
        });
      }else if (leftPlayer > 1 && rightPlayer == 1){
        int dicesLeft = min(leftPlayer - 1, 3);
        List<int> dices = await getDice(dicesLeft + 1);    
        if(dices.length != dicesLeft + 1) return;
        List<int> left = dices.sublist(0,dicesLeft);
        List<int> right = dices.sublist(dicesLeft, dicesLeft + 1);
        left.sort((x,y) => y.compareTo(x));

        setState(() {  
          if(left[0] > right[0]) {
            rightPlayer -= 1;
          }else{
            leftPlayer -= 1;
          }
          leftController.text = leftPlayer.toString();
          rightController.text = rightPlayer.toString();
        });
      }else{
        setState(() {
          playing = false;
        });
        return;
      }

      await Future.delayed(const Duration(milliseconds: 100));

      if(!playing) {
        return;
      }
    }
    setState(() {
      playing = false;
    });
  }

  void leftOnChange(value){
    if(value == "") {
      errorStringLeft = null;
      return;
    }

    setState(() {
      try{
        leftPlayer = leftPlayerMax = int.parse(value);
        if(leftPlayerMax <= 0) {
          errorStringLeft = "must be a positive integer";
        }else {
          errorStringLeft = null;
        }
      }catch(_){
        errorStringLeft = "must be a positive integer";
      }
    });
  }
  
  void rightOnChange(value){
    if(value == "") {
      errorStringRight = null;
      return;
    }

    setState(() {
      try{
        rightPlayer = rightPlayerMax = int.parse(value);
        if(rightPlayerMax <= 0) {
          errorStringRight = "must be a positive integer";
        }else {
          errorStringRight = null;
        }
      }catch(_){
        errorStringRight = "must be a positive integer";
      }
    });
  }

  void leftThresholdOnChange(value){
    if(value == "") {
      errorStringLeftThreshold = null;
      return;
    }

    setState(() {
      try{
        leftThreshold = int.parse(value);
        if(leftThreshold <= 0) {
          errorStringLeftThreshold = "must be a positive integer";
        }else {
          errorStringLeftThreshold = null;
        }
      }catch(_){
        errorStringLeftThreshold = "must be a positive integer";
      }
    });
  }
  
  void rightThresholdOnChange(value){
    if(value == "") {
      errorStringRightThreshold = null;
      return;
    }

    setState(() {
      try{
        rightThreshold = int.parse(value);
        if(rightThreshold <= 0) {
          errorStringRightThreshold = "must be a positive integer";
        }else {
          errorStringRightThreshold = null;
        }
      }catch(_){
        errorStringRightThreshold = "must be a positive integer";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Tooltip(
            message: lastRollFailed ? "pseudo-random" : "true Random form random.org\n(Quota:${TrueRandomDice.quota})",
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(lastRollFailed ? RiskDiceRoller.dicesRandomNot : RiskDiceRoller.dicesRandom),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10), 
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Attacker:", style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ProgressBar(progress: (leftPlayerMax == 0 ? 1 : leftPlayer/leftPlayerMax),),
                      ),
                      TextField(
                        enabled: !playing,
                        controller: leftController,
                        decoration: InputDecoration(
                          isDense: true,
                          label: const Text("Strength:"),
                          contentPadding: const EdgeInsets.all(0),
                          errorText: errorStringLeft
                        ),
                        style: const TextStyle(fontSize: 24),
                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                        onChanged: leftOnChange,
                        focusNode: leftNode,
                        onSubmitted: (value){
                          leftOnChange(value);
                          FocusScope.of(context).requestFocus(leftThresholdEnable ? leftThresholdNode : rightNode);
                        },
                      ),
                      const Divider(),
                      Row(children: [
                        Switch(value: leftThresholdEnable, onChanged: (b) {setState(() { leftThresholdEnable = b; });}),
                        const Text("enable limit", style: TextStyle(fontSize: 18),)
                      ]),
                      TextField(
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                          label: Text("Limit to:"),
                        ),
                        enabled: leftThresholdEnable,
                        focusNode: leftThresholdNode,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 24),
                        onChanged: leftThresholdOnChange,
                        onSubmitted: (value){
                          leftThresholdOnChange(value);
                          FocusScope.of(context).requestFocus(rightNode);
                        },
                      )
                    ],
                  ),
                )
              ),
              const VerticalDivider(thickness: 1,),
              Expanded(
                child: Padding(padding: const EdgeInsets.only(right: 10), child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("Defender:", style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ProgressBar(progress: (rightPlayerMax == 0 ? 1 : rightPlayer/rightPlayerMax),),
                    ),
                    TextField(
                      enabled: !playing,
                      controller: rightController,
                      decoration: InputDecoration(
                        isDense: true,
                        label: const Text("Strength:"),
                        contentPadding: const EdgeInsets.all(0),
                        errorText: errorStringRight
                      ),
                      style: const TextStyle(fontSize: 24),
                      keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                      onChanged: rightOnChange,
                      focusNode: rightNode,
                      onSubmitted: (value){
                        rightOnChange(value);
                        if(rightThresholdEnable){
                          FocusScope.of(context).requestFocus(rightThresholdNode);
                        }
                      },
                    ),
                    const Divider(),
                    Row(children: [
                      Switch(value: rightThresholdEnable, onChanged: (b) {setState(() { rightThresholdEnable = b; });}),
                      const Text("enable limit", style: TextStyle(fontSize: 18),)
                    ]),
                    TextField(
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(0),
                        label: Text("Limit to:"),
                        errorStyle: TextStyle(color: Colors.grey)
                      ),
                      keyboardType: TextInputType.number,
                      enabled: rightThresholdEnable,
                      focusNode: rightThresholdNode,
                      style: const TextStyle(fontSize: 24),
                      onChanged: rightThresholdOnChange,
                      onSubmitted: rightThresholdOnChange
                    )
                  ],
                ),
              )),
            ]
          )),
          ElevatedButton(onPressed: play, child: Text((playing ? "stop" : "play")))
        ]
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  ProgressBar({this.progress = 0.5,  Key? key }) : super(key: key);

  final double progress;

  final GlobalKey sliderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    
    return Container(
      key: sliderKey,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        color: Theme.of(context).primaryColor.withOpacity(0.3)
      ),
      height: 6,
      child: FractionallySizedBox(
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            color: Theme.of(context).primaryColor
          ),
        ),
      ),
    );
  }
}