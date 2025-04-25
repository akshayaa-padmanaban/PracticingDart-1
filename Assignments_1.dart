// my first assignment
import 'dart:io';

import 'AppData.dart';
void main()
{
    print('Enter a search value:');
    String? input = stdin.readLineSync();

    if (input == null || input.isEmpty)
    {
        print('Exit');
        return;
    }

    if(input.startsWith('>')||input.startsWith('<'))
    {
      String condition=input[0];
      double loanAmount = double.tryParse(input.substring(1).trim())??0;
      if(loanAmount==0)
      {
        print('Invalid');
        return;
      }
      List<Map<String, dynamic>> match = filterBySearchQuery(condition, loanAmount);
      if(match.isEmpty)
      {
        print("Invalid");
        return;
      }
      else
      {
       print(match);
      }
    }

    if(input == 'last week' || input == 'last month' || input == 'last quarter')
    {
      List<Map<String, dynamic>> match = filterByDate(input);
      print(match);
      return;
    }

    else
    {
      bool isfound = false;
      for (var data in mobCustData)
      {
        for (var value in data.values)
        {
            if(value.toString().toLowerCase().contains(input.toLowerCase()))
            {
                print(data);
                isfound = true;
                return;
            }
        }
        if (isfound) 
        return;
      }
      if(!isfound)
      {
        print("enter the correct value");
        return;
      }
    }
  }

List<Map<String, dynamic>> filterBySearchQuery(condition, double loanAmount) {
  List<Map<String,dynamic>> match = mobCustData.where((data)
  {
    double loanAmt = double.tryParse(data['lcdLoanAmt'].toString())??0;
    if(condition == '>' && loanAmt>loanAmount) return true;
    else if(condition == '<' && loanAmt<loanAmount) return true;
    return false;
  }).toList();
  return match;
}

List<Map<String, dynamic>> filterByDate(String dates) {
  DateTime now = DateTime.now();
  Duration range;

  switch(dates)
  {
    case 'last week':
    range = Duration(days:7);
    break;

    case 'last month':
    range = Duration(days:30);
    break;

    case 'last quarter':
    range = Duration(days:90);
    break;

    default:
    return[];
  }

  DateTime fromDate = now.subtract(range);

  return mobCustData.where((data) 
  {
    String create = data['lcdcreatedon'].toString();
    DateTime? date = DateTime.tryParse(create);
    return date != null && date.isAfter(fromDate);
  }).toList();

  }
