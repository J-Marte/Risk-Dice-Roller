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
import 'package:risiko_wuerfler/statistic/statistic_diagramm.dart';

class StatView extends StatefulWidget {
  const StatView({Key? key}) : super(key: key);

  @override
  State<StatView> createState() => _StatViewState();
}

class _StatViewState extends State<StatView> {

  Map<int, int> getDiceData(){
    Map<int, int> sum = {};

    for (int i = 0; i < 6; i++){
      sum[i] = 0;
    }

    for (int i = 0; i < MyApp.fights.length; i++){
      Map<int, int> temp = MyApp.fights[i].diceDistribution();

      for (int key in temp.keys){
        sum[key] = sum[key]! + temp[key]!;
      }
    }

    return sum;
  }

  Map<int, int> getSumData(){
    Map<int, int> sum = {};

    for (int i = 0; i < 6 * 5; i++){
      sum[i] = 0;
    }

    for (int i = 0; i < MyApp.fights.length; i++){
      Map<int, int> temp = MyApp.fights[i].sumDistribution();

      for (int key in temp.keys){
        sum[key] = sum[key]! + temp[key]!;
      }
    }

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.9,
              child: StatDiagramm(
                data: getDiceData()
              ),
            ),
            const Divider(),
            SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.9,
              child: StatDiagramm(
                data: getSumData()
              ),
            ),
          ],
        )
      ),
    );
  }
}