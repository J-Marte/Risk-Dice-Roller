import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class TrueRandomDice {

  static const int bufferedRolledDices = 300;
  static const int rolledDicesThreshold = 100;

  static final List<int> _rolledDices = []; 
  static const double _diceFactor = 3;
  static bool _fetching = false;
  static int _quota = 0;
  static int get quota{
    return _quota;
  }

  // from https://www.random.org/clients/http/#quota
  static Future<int> getQuota() async {
    http.Response resp = await http.get(Uri.parse('https://www.random.org/quota/?format=plain'));
    try {
      _quota = int.parse(resp.body.split('\n')[0]);
      print(_quota);
      return _quota;
    } catch (e) {
      return 0;
    } 
    
  }

  static void _cachedFetch() async {
    try {
      await _fetchDiceRolls();
    } catch (_) {} 
  }

  static Future<List<int>> getDice(int amount) async {
    if(_rolledDices.length < rolledDicesThreshold && amount <= _rolledDices.length) _cachedFetch(); 
     
    
    if(amount <= _rolledDices.length) {
      List<int> temp = _rolledDices.sublist(0, amount);
      _rolledDices.removeRange(0, amount);
      return temp;
    }

    try{
      await _fetchDiceRolls();
    }catch(e){ rethrow;}
    List<int> temp = _rolledDices.sublist(0, amount);
    _rolledDices.removeRange(0, amount);
    return temp;
  }

  // from https://www.random.org/clients/http/#integers
  static Future<void> _fetchDiceRolls() async {
    if (_fetching) return;
    _fetching = true;

    int bytes = (bufferedRolledDices / _diceFactor).ceil();
    if(_quota < bytes * 8){
      _fetching = false;
      throw Exception("Quota is to low");
    }

    // request random bytes
    _quota -= bytes * 8;
    Uri uri = Uri.parse('https://www.random.org/integers/?num=$bytes&min=0&max=255&col=1&base=16&format=plain&rnd=new');
    http.Response resp;
    try{
      resp = await http.get(uri);
    }catch (_) {
      _fetching = false;
      throw Exception("Can't connect to random.org");
    }

    // convert response body to int array
    List<String> raw = resp.body.replaceAll(' ', '').split('\n');
    List<int> data = [];
    for (var i = 0; i < raw.length; i++) {
      String temp = "";
      for (var j = 0; j < raw.length - i && j < 7; j++) {
        temp += raw[i + j];
      }
      i += 6;
      data.add(int.parse(temp, radix: 16));
    }  

    // convert int to values form 0-5
    for (var integer in data) {
      do {
        _rolledDices.add(integer % 6);
        integer = integer ~/ 6;
      } while (integer != 0);
    }
    
    _fetching = false;
  }
}

