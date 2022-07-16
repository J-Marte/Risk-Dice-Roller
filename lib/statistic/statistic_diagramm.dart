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
import 'package:risiko_wuerfler/helper/canvas_helper.dart';

class StatDiagramm extends StatelessWidget {
  const StatDiagramm({Key? key, required this.data}) : super(key: key);

  final Map<int, int> data;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StatDiagrammPainter(data: data),
    );
  }
}

class StatDiagrammPainter extends CustomPainter {

  StatDiagrammPainter({required this.data});

  final Map<int, int> data;

  static const double axisSpacing = 5;

  @override
  void paint(Canvas canvas, Size size) {
    Offset origin = Offset(axisSpacing, size.height - axisSpacing);
    double width = (size.width - axisSpacing) / data.entries.length;
    int max = 0;
    for (int i = 0; i < data.values.length; i++){
      if (max < data.values.elementAt(i)){
        max = data.values.elementAt(i);
      }
    }
    double scale = (size.height - axisSpacing * 2) / max; 

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    Paint graph = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.keys.length; i++){
      double height = scale * data[data.keys.elementAt(i)]!;
      canvas.drawRect(Rect.fromLTWH(origin.dx + width * i, origin.dy - height, width, height), graph);
    }

    canvas.drawArrow(Offset(axisSpacing, size.height), const Offset(axisSpacing, 0), paint);
    canvas.drawArrow(Offset(0, size.height - axisSpacing), Offset(size.width, size.height - axisSpacing), paint);
  }

  @override
  bool shouldRepaint(covariant StatDiagrammPainter oldDelegate) {
    return oldDelegate.data != data;
  }

}