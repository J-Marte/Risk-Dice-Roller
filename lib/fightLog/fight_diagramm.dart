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


class Diagramm extends StatelessWidget {
  const Diagramm({required this.data, this.color = Colors.red, Key? key }) : super(key: key);

  final Color? color;
  final List<double> data;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DiagrammPaint(
        color: color != null ? color! : Colors.red,
        data: data
      )
    );
  }
}

class DiagrammPaint extends CustomPainter{

  DiagrammPaint({required this.color, required this.data});

  Color color;
  List<double> data;

  @override
  void paint(Canvas canvas, Size size) {
    double scale = size.width / (data.length - 1);

    Paint p = Paint()
      ..color = color
      ..strokeWidth = 1;

    Path path = Path()
      ..moveTo(0, size.height);

    for (int i = 0; i < data.length; i++) {
      path.lineTo(i * scale, size.height - data[i] * size.height);
    } 

    path.lineTo((data.length - 1) * scale, size.height);

    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}