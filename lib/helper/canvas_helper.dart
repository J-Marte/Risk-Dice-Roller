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



extension CanvasHelper on Canvas{
  drawArrow(Offset begin, Offset end, Paint paint, [double side = 5]){
    Offset dif = end - begin;
    double angle = atan2(dif.dx, dif.dy);


    drawLine(begin, end, paint);   

    Offset arrSide = Offset(sin(angle + pi / 4) * side, cos(angle + pi / 4) * side);
    drawLine(end, end - arrSide, paint);
    arrSide = Offset(sin(angle - pi / 4) * side, cos(angle - pi / 4) * side);
    drawLine(end, end - arrSide, paint);
  }
}