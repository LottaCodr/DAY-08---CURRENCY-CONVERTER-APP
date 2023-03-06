import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() => runApp(const MaterialApp(
  home: CurrencyConverter(),
));



class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  double _inputValue = 0.0;
  final TextEditingController _amountController = TextEditingController();
  String _selectedFromCurrency = 'NGN';
  String _selectedToCurrency = 'EUR';
  double _convertedValue = 0.0;

  final currencies = [
    'USD', 'NGN','EUR','JPY','GBP','AUD','CAD','CHF','CNY','HKD','NZD',
    'SEK','KRW','SGD','NOK','MXN','INR','RUB','ZAR','TRY','BRL','TWD','DKK','PLN',
  ];

  Future<double> _convertCurrency() async {
    final url = 'https://api.exchangerate.host/convert?from=$_selectedFromCurrency&to=$_selectedToCurrency&amount=$_inputValue';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode ==200) {
      final jsonResponse = json.decode(response.body);
      final result = jsonResponse['result'];
      return result.toDouble();
    } else {
      throw Exception('failed to load page');
    }
 }

  void _onConvertPressed() async {
    final convertedValue = await _convertCurrency();
    setState(() {
      _convertedValue = convertedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WORLD CURRENCY CONVERTER'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),

      body: SingleChildScrollView(
        child: Column(
          children:  [
            const SizedBox(height: 20,),

            TextField(

              keyboardType: TextInputType.number ,
              decoration: const InputDecoration(
                hintText: "Enter amount in figures",
                border: OutlineInputBorder()
              ),
              onChanged: (value){
                setState(() {
                  _inputValue = double.tryParse(value)??0.0;
                });
              },
            ),

            const SizedBox(height: 20,),
            Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String> (
                  value: _selectedFromCurrency,
                onChanged: (newValue) {
                    setState(() {
                      _selectedFromCurrency = newValue!;
                    });
                },
                items: currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                      child: Text(currency));
                }).toList() ,
 ),
            const Icon(Icons.arrow_forward),


            DropdownButton<String>(
              value: _selectedToCurrency,
              onChanged: (newValue){
                setState(() {
                  _selectedToCurrency = newValue!;
                });
              },
              items: currencies.map((currency) {
                return DropdownMenuItem(
                    value: currency,
                    child: Text(currency));
              }).toList(), )],),

            const SizedBox(height: 20,),

            //display converted value

            Text(
              '$_inputValue $_selectedFromCurrency = $_convertedValue $_selectedToCurrency',
            style: const TextStyle(
              fontSize: 20,
            ),),
          const SizedBox(height: 24,),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        _amountController.clear();
                        setState(() {
                          _convertedValue = 0;

                        });
                      }, child: const Text('Clear')),

                  ElevatedButton(
                      onPressed: _onConvertPressed,
                      child: const Text('Convert'))
                ],
              ),
            )


          ],
        ),
      ),
    );
  }
}
