import 'package:bloc/bloc.dart';
import 'package:currency_converter/models/timeseries_model.dart';
import 'package:currency_converter/shared/constants.dart';
import 'package:currency_converter/shared/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import '../../../shared/cache_helper.dart';
part 'exchange_rate_state.dart';

class ExchangeRateCubit extends Cubit<ExchangeRateState> {
  ExchangeRateCubit() : super(ExchangeRateInitial());

  List<String>allCurrencies=[];
  List<TimeSeriesModel>timeSeries=[];

   late String fromCurrency = "USD";
   late String toCurrency = "EGP";
   String rate = "0";


  static ExchangeRateCubit get (BuildContext context) => BlocProvider.of(context);

   changeFromCurrency (String newCurrency){
      fromCurrency = newCurrency;
    emit(ChangeFromCurrency());
  }

   changeToCurrency (String newCurrency){
      toCurrency = newCurrency;
    emit(ChangeToCurrency());
  }

   convertCurrency ({
    required String from,
    required String to
  }){

    emit(ConvertCurrencyLoadingState());
    DioHelper.get(url: "https://api.apilayer.com/exchangerates_data/convert?to=$to&from=$from&amount=1",
    ).then((value) {
      rate = value.data['info']['rate'].toString();

      _getTimeSeries(from: from, to: to);

      emit(ConvertCurrencySuccessfullyState());
    }).catchError((Error){
      print(Error);
      emit(ConvertCurrencyErrorState());
    });
  }
  
  void getSymbols()async{
    symbols =  Cache_Helper.getListFromCache(key: "symbols")?? [];

    if(symbols.isEmpty){
      emit(GetSymbolsLoadingState());

        DioHelper.get(url: "https://api.apilayer.com/fixer/symbols").then((value)async {
        value.data['symbols'].keys.forEach((key){
          allCurrencies.add(key);
        });

        Cache_Helper.saveListInCache("symbols", allCurrencies);
        symbols=allCurrencies;

        emit(GetSymbolsSuccessfullyState());

      }).catchError((error){
        print(error);
        emit(GetSymbolsErrorState());
      });
    }
  }

  void _getTimeSeries({required String from, required String to}){

    timeSeries=[];
    String startDate = _getTheFirstDayInTheCurrentYear();
    String endDate = _formattedDateOfToday();

    DioHelper.get(url: "https://api.apilayer.com/fixer/timeseries?start_date=$startDate&end_date=$endDate&base=$from&symbols=$to",
    ).then((value) {

      value.data['rates'].keys.forEach((key){
        timeSeries.add(TimeSeriesModel(date: key, currencyPrice: double.parse(value.data['rates'][key][to].toString())));
      });

      emit(GetTimeSeriesSuccessfullyState());

    }).catchError((error){
      emit(GetTimeSeriesErrorState());
      print(error);
    });
  }

  String _formattedDateOfToday(){
     final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
     String formatted = formatter.format(now);
     return formatted;
  }

  String _getTheFirstDayInTheCurrentYear (){
    DateTime date = DateTime(DateTime.now().year,1,1);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(date).toString();
    return formatted;
  }


}
