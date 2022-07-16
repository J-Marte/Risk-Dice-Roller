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

import 'package:flutter/material.dart';
import 'package:risiko_wuerfler/main.dart';
import 'package:risiko_wuerfler/statistic/stat_view.dart';
import 'fight_details.dart';

class FightLogView extends StatefulWidget {
  const FightLogView({ Key? key }) : super(key: key);

  @override
  State<FightLogView> createState() => _FightLogViewState();
}

class _FightLogViewState extends State<FightLogView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fight-Log"),  
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const StatView()));
            },
            icon: const Icon(Icons.note)
          )
        ],
      ),
      body: ListView(
        children: [
          for (var i = 0; i < MyApp.fights.length; i++)
            FightOverview(
              name: MyApp.fights[i].name,
              leftPlayerBegin: MyApp.fights[i].attackerBegin,
              leftPlayerEnd:MyApp.fights[i].attackerEnd,
              rightPlayerBegin: MyApp.fights[i].defenderBegin,
              rightPlayerEnd: MyApp.fights[i].defenderEnd,
              onClick: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => FightDetailView(fight: MyApp.fights[i],)));
              },
            ),
        ],
      ),
    );
  }
}

class FightOverview extends StatelessWidget {
  const FightOverview({ Key? key, this.name = "Fight", this.onClick, this.leftPlayerBegin = 10, this.leftPlayerEnd = 5, this.rightPlayerBegin = 4, this.rightPlayerEnd = 0 }) : super(key: key);

  final String name;

  final int leftPlayerBegin;
  final int leftPlayerEnd;

  final int rightPlayerBegin;
  final int rightPlayerEnd;

  final Function? onClick;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(onClick != null){
          onClick!();
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5), 
              child: Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ProgressBar(progress: leftPlayerEnd/leftPlayerBegin.toDouble(),),
                ],
              )
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                children: [
                  ProgressBar(progress: rightPlayerEnd/rightPlayerBegin.toDouble(),),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}