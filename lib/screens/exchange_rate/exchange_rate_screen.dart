import 'package:currency_converter/models/timeseries_model.dart';
import 'package:currency_converter/screens/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:currency_converter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExchangeRateScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272541),
      body: BlocProvider(
        create: (context) => ExchangeRateCubit()
          ..getSymbols()
          ..convertCurrency(from: "USD", to: "EGP"),
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<ExchangeRateCubit, ExchangeRateState>(
                builder: (context, state) {
                  ExchangeRateCubit cubit = ExchangeRateCubit.get(context);
                  if (symbols.isEmpty) {
                    return const Center(child: CircularProgressIndicator(),);
                  } 
                  else {
                    return Expanded(
                      child: Column(
                      children: [
                        TheTwoListsOfCurrencies(fromCurrency: cubit.fromCurrency, toCurrency: cubit.toCurrency),
                        const SizedBox(height: 10,),
                        state is ConvertCurrencyLoadingState || state is GetSymbolsLoadingState?
                        const Center(child: CircularProgressIndicator()):
                        CurrencyConversionText(
                            fromCurrency: cubit.fromCurrency,
                            toCurrency: cubit.toCurrency,
                            rate: cubit.rate
                        ),
                           Expanded(
                             child: ChartOfTimeSeries(
                                 timeSeries: cubit.timeSeries
                             ),
                           ),
                      ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TheTwoListsOfCurrencies extends StatelessWidget {

  late String fromCurrency;
  late String toCurrency;

  TheTwoListsOfCurrencies({required this.fromCurrency, required this.toCurrency});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CountriesDropDownList(
          selectedCurrency: fromCurrency,
          toCurrency: toCurrency,
          fromCurrency: fromCurrency,
          fromORtoFlag: 1,
        ),
        Icon(Icons.arrow_right_alt_rounded, size: 90,color: Colors.white,),
        CountriesDropDownList(
          selectedCurrency: toCurrency,
          toCurrency: toCurrency,
          fromCurrency: fromCurrency,
          fromORtoFlag: 2,
        ),
      ],
    );
  }
}

class CurrencyConversionText extends StatelessWidget {

  late String fromCurrency;
  late String toCurrency;
  late String rate;

  CurrencyConversionText({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("1 ${fromCurrency}",
          style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        const Text("=",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        Flexible(
          child: Text("${rate} ${toCurrency}",
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ),
      ],
    );
  }
}

class CountriesDropDownList extends StatelessWidget {

  late String selectedCurrency;
  late String fromCurrency;
  late String toCurrency;
  late int fromORtoFlag;

  CountriesDropDownList({required this.selectedCurrency,
    required this.toCurrency,required this.fromCurrency,
    required this.fromORtoFlag
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      child: DropdownButton(
        dropdownColor: Color(0xff221e34),
      iconEnabledColor: Colors.white,
      isExpanded: true,
          underline: Container(
        height: 2,
        color: Color(0xff22bf84),
      ),
      value: selectedCurrency,
      items: symbols.map((String value) {
        return DropdownMenuItem(
            value: value,
            child: Row(
              children: [
                Text(
                  value,
                  style:const TextStyle(
                    fontSize: 30,
                      color: Colors.white
                  ),
                ),
                const Spacer(),
                Image.asset(
                  "assets/flags/$value.png", width: 40,
                )
              ],
            ));
      }).toList(),
      onChanged: (String? newValue) {
        if(fromORtoFlag==1)
          ExchangeRateCubit.get(context).changeFromCurrency(newValue!);
        else
          ExchangeRateCubit.get(context).changeToCurrency(newValue!);

        ExchangeRateCubit.get(context).convertCurrency(from: ExchangeRateCubit.get(context).fromCurrency, to: ExchangeRateCubit.get(context).toCurrency);
      }),
    );
  }
}

class ChartOfTimeSeries extends StatelessWidget {

  late List<TimeSeriesModel>timeSeries;

  ChartOfTimeSeries({required this.timeSeries});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:SfCartesianChart(
        plotAreaBorderColor: Colors.white,
        backgroundColor: Color(0xff221e34),
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<TimeSeriesModel, String>>[
          LineSeries(
            dataSource: timeSeries,
            xValueMapper: (TimeSeriesModel date,_)=>date.date,
            yValueMapper: (TimeSeriesModel currencyPrice, context) => currencyPrice.currencyPrice,
            color: Color(0xff11ff98),
          )


        ],
        trackballBehavior: TrackballBehavior(
            shouldAlwaysShow: false,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
            enable: true,
            lineColor: Colors.white,
            tooltipSettings: const InteractiveTooltip(
                format: 'point.x \n point.y',
                enable: true,
                color: Color(0xff198890),
              textStyle: TextStyle(
                 color: Colors.white,
              )
            )
        ),
      ) ,
    );
  }
}



