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
import 'package:risiko_wuerfler/fightLog/fight_diagramm.dart';
import 'package:risiko_wuerfler/statistic/statistic_diagramm.dart';


class Fight {
  
  Fight({this.name = "Fight", required this.rounds,  this.attackerBegin = 0, this.attackerEnd = 0, this.defenderBegin = 0, this.defenderEnd = 0,});
  
  final String name;
  List<RiskRound> rounds;
  int attackerBegin = 0;
  int attackerEnd = 0;
  int defenderBegin = 0;
  int defenderEnd = 0;

  
  Map<int, int> diceDistribution(){
    Map<int, int> erg = {};

    for(int i = 0; i < 6; i++) {
      erg[i] = 0;
    }

    for (int i = 0; i < rounds.length; i++){
      RiskRound round = rounds[i];
      List dices = [...round.defenderDices, ...round.attackerDices];

      for(int j = 0; j < dices.length; j++){
        erg[dices[j]] = erg[dices[j]]! + 1;
      }
    }
    
    return erg;
  }
  
  Map<int, int> sumDistribution(){
    Map<int, int> erg = {};

    for(int i = 0; i < 5*6; i++) {
      erg[i] = 0;
    }

    for (int i = 0; i < rounds.length; i++){
      RiskRound round = rounds[i];
      List<int> dices = [...round.defenderDices, ...round.attackerDices];
      int sum = 0;
      for(int j = 0; j < dices.length; j++){
        sum += dices[j];
      }

      erg[sum] = erg[sum]! + 1;
    }
    
    return erg;
  }
}

class RiskRound {

  RiskRound({required this.attackerDices, required this.defenderDices, required this.attackerNow, required this.defenderNow});

  List<int> attackerDices;
  List<int> defenderDices;

  int attackerNow;
  int defenderNow;
}

class FightDetailView extends StatefulWidget {
  const FightDetailView({required this.fight, Key? key }) : super(key: key);

  final Fight fight; 

  @override
  State<FightDetailView> createState() => _FightDetailViewState();
}

class _FightDetailViewState extends State<FightDetailView> {


  List<double> calcDiagramAttacker(){
    List<double> fightData = [];

    fightData.add(1);
    for(int i = 0; i < widget.fight.rounds.length; i++){
      fightData.add(widget.fight.rounds[i].attackerNow / widget.fight.attackerBegin);
    }

    return fightData;
  }

  List<double> calcDiagramDefender(){
    List<double> fightData = [];

    fightData.add(1);
    for(int i = 0; i < widget.fight.rounds.length; i++){
      fightData.add(widget.fight.rounds[i].defenderNow / widget.fight.defenderBegin);
    }

    return fightData;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.fight.name} Detail"),
        
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(child: Column(
                children: [
                  const Text("Attacker", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: Diagramm(
                      data: calcDiagramAttacker(),
                      color: Colors.red[400],
                    ),
                  )
                ]
              )),
              const VerticalDivider(thickness: 1,),
              Expanded(child: Column(children: [
                const Text("Defender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: Diagramm(
                      data: calcDiagramDefender(),
                      color: Colors.blue[400],
                    ),
                  )
              ])),
            ],
          ),
          const Divider(), 
          Row(
            children: [
              Expanded(child: Column(
                children: [
                  const Text("by numbers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: StatDiagramm(
                      data: widget.fight.diceDistribution()
                    )
                  )
                ]
              )),
              const VerticalDivider(thickness: 1,),
              Expanded(child: Column(
                children: [
                  const Text("sum of throw", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: StatDiagramm(
                      data: widget.fight.sumDistribution()
                    )
                  )
                ]
              )),
            ]
          ),
          const Divider(), 
          Column(
            children: [
              for (var i = 0; i < widget.fight.rounds.length; i++)
                Row(
                  children: [
                    Expanded(child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (var j = 0; j < widget.fight.rounds[i].attackerDices.length; j++)
                          Padding(padding: const EdgeInsets.all(5), child: Text((widget.fight.rounds[i].attackerDices[j] + 1).toString(), style: const TextStyle(fontSize: 16),),),
                      ],
                    ),),
                    const VerticalDivider(thickness: 1,),
                    Expanded(child: Row(
                      children: [
                        for (var j = 0; j < widget.fight.rounds[i].defenderDices.length; j++)
                          Padding(padding: const EdgeInsets.all(5), child: Text((widget.fight.rounds[i].defenderDices[j] + 1).toString(), style: const TextStyle(fontSize: 16),),)
                      ],
                    )),
                  ],
                ),
            ],
          ),
        ]
      ),
    );
  }
}