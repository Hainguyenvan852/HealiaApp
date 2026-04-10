class DateTimeHelper {
  static String transformTime24To12(int hour, int minute) {
    if (minute > 9) {
      switch (hour) {
        case 1:
          return '1:$minute AM';
        case 2:
          return '2:$minute AM';
        case 3:
          return '3:$minute AM';
        case 4:
          return '4:$minute AM';
        case 5:
          return '5:$minute AM';
        case 6:
          return '6:$minute AM';
        case 7:
          return '7:$minute AM';
        case 8:
          return '8:$minute AM';
        case 9:
          return '9:$minute AM';
        case 10:
          return '10:$minute AM';
        case 11:
          return '11:$minute AM';
        case 12:
          return '12:$minute PM';
        case 13:
          return '1:$minute PM';
        case 14:
          return '2:$minute PM';
        case 15:
          return '3:$minute PM';
        case 16:
          return '4:$minute PM';
        case 17:
          return '5:$minute PM';
        case 18:
          return '6:$minute PM';
        case 19:
          return '7:$minute PM';
        case 20:
          return '8:$minute PM';
        case 21:
          return '9:$minute PM';
        case 22:
          return '10:$minute PM';
        case 23:
          return '11:$minute PM';
        case 0:
          return '12:$minute AM';
        default:
          return 'Error transform time';
      }
    } else {
      switch (hour) {
        case 1:
          return '1:0$minute AM';
        case 2:
          return '2:0$minute AM';
        case 3:
          return '3:0$minute AM';
        case 4:
          return '4:0$minute AM';
        case 5:
          return '5:0$minute AM';
        case 6:
          return '6:0$minute AM';
        case 7:
          return '7:0$minute AM';
        case 8:
          return '8:0$minute AM';
        case 9:
          return '9:0$minute AM';
        case 10:
          return '10:0$minute AM';
        case 11:
          return '11:0$minute AM';
        case 12:
          return '12:0$minute PM';
        case 13:
          return '1:0$minute PM';
        case 14:
          return '2:0$minute PM';
        case 15:
          return '3:0$minute PM';
        case 16:
          return '4:0$minute PM';
        case 17:
          return '5:0$minute PM';
        case 18:
          return '6:0$minute PM';
        case 19:
          return '7:0$minute PM';
        case 20:
          return '8:0$minute PM';
        case 21:
          return '9:0$minute PM';
        case 22:
          return '10:0$minute PM';
        case 23:
          return '11:0$minute PM';
        case 0:
          return '12:0$minute AM';
        default:
          return 'Error transform time';
      }
    }
  }

  static String intToDayOfWeek(int day) {
    switch (day) {
      case 2:
        return 'Monday';
      case 3:
        return 'Tuesday';
      case 4:
        return 'Wednesday';
      case 5:
        return 'Thursday';
      case 6:
        return 'Friday';
      case 7:
        return 'Saturday';
      case 8:
        return 'Sunday';
      default:
        return 'Invalid day';
    }
  }

  static String minuteToHourAndMinute(int minuteValue){
    int hour = (minuteValue/60).floorToDouble().toInt();
    int minute = minuteValue % 60;

    if(hour > 0){
      if(minute > 0){
        return '$hour hr, $minute min';
      } else{
        return '$hour hr';
      }
    } else{
      return '$minute min';
    }
  }
}
