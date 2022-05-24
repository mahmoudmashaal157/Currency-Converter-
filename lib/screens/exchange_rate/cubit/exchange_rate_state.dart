part of 'exchange_rate_cubit.dart';

@immutable
abstract class ExchangeRateState {}

class ExchangeRateInitial extends ExchangeRateState {}

class ChangeFromCurrency extends ExchangeRateState{}

class ChangeToCurrency extends ExchangeRateState{}

class ConvertCurrencyLoadingState extends ExchangeRateState{}

class ConvertCurrencySuccessfullyState extends ExchangeRateState{}

class ConvertCurrencyErrorState extends ExchangeRateState{}

class GetSymbolsLoadingState extends ExchangeRateState{}

class GetSymbolsSuccessfullyState extends ExchangeRateState{}

class GetSymbolsErrorState extends ExchangeRateState{}

class GetTimeSeriesLoadingState extends ExchangeRateState{}

class GetTimeSeriesSuccessfullyState extends ExchangeRateState{}

class GetTimeSeriesErrorState extends ExchangeRateState{}



