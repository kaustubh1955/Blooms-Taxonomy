import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class SubscriberSeries {
  final String percentageText;
  final int percent;
  final charts.Color barColor;

  SubscriberSeries(
      {@required this.percent,
      this.percentageText,
      // @required this.subscribers,
      @required this.barColor});
}