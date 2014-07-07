package common.system.utils
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class DateUtils
	{
		private static const MONTH_OFFSET:Array = [
			//    Jan Feb Mar Apr May  Jun  Jul  Aug  Sep  Oct  Nov  Dec  Total
			[0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365], [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366]];
		
		public static const MSEC_PER_DAY:int = 86400000;
		public static const MSEC_PER_HOUR:int = 86400000;
		public static const MSEC_PER_SECOND:int = 86400000;
		public static const MSEC_PER_MINUTE:int = 86400000;
		
		public static const SECONDS_PER_MINUTE:int = 60;
		public static const MINUTES_PER_HOUR:int = 60;
		public static const HOURS_PER_DAY:int = 24;
		public static const MILLISEC_PER_SECOND:int = 1000;
		
		public function DateUtils()
		{
		
		}
		
		public static function getDay(time:Number):Number
		{
			return Math.floor(time / MSEC_PER_DAY);
		}
		
		public static function getDayFromYear(year:Number):Number
		{
			return (365 * (year - 1970) + Math.floor((year - 1969) / 4) - Math.floor((year - 1901) / 100) + Math.floor((year - 1601) / 400));
		}
		
		public static function getTimeFromYear(year:int):Number
		{
			return MSEC_PER_DAY * getDayFromYear(year);
		}
		
		public static function getDaysInYear(year:int):int
		{
			if (year % 4)
			{
				return 365;
			}
			if (year % 100)
			{
				return 366;
			}
			if (year % 400)
			{
				return 365;
			}
			return 366;
		}
		
		public static function getTimeWithinDay(t:Number):Number
		{
			var result:Number = t % MSEC_PER_DAY;
			if (result < 0)
			{
				result += MSEC_PER_DAY;
			}
			
			return result;
		}
		
		public static function getYearFromTime(t:Number):int
		{
			var day:Number = getDay(t);
			var lo:int, hi:int;
			lo = Math.floor((t < 0) ? (day / 365) : (day / 366)) + 1970;
			hi = Math.ceil((t < 0) ? (day / 366) : (day / 365)) + 1970;
			while (lo < hi)
			{
				var pivot:int = (lo + hi) / 2;
				var pivotTime:Number = getTimeFromYear(pivot);
				if (pivotTime <= t)
				{
					if (getTimeFromYear(pivot + 1) > t)
					{
						return pivot;
					}
					else
					{
						lo = pivot + 1;
					}
				}
				else if (pivotTime > t)
				{
					hi = pivot - 1;
				}
			}
			
			return lo;
		}
		
		public static function isLeapYear(year:int):Boolean
		{
			return getDaysInYear(year) == 366;
		}
		
		public static function isTimeInLeapYear(t:Number):Boolean
		{
			return isLeapYear(getYearFromTime(t));
		}
		
		public static function getDayWithinYear(t:Number):int
		{
			return getDay(t) - getDayFromYear(getYearFromTime(t));
		}
		
		public static function getMonthFromTime(t:Number):int
		{
			var day:int = getDayWithinYear(t);
			var leap:int = int(isTimeInLeapYear(t));
			var i:int;
			
			for (i = 0; i < 11; i++)
			{
				if (day < MONTH_OFFSET[leap][i + 1])
				{
					break;
				}
			}
			
			return i;
		}
		
		public static function getDateFromTime(t:Number):int
		{
			var month:int = getMonthFromTime(t);
			return getDayWithinYear(t) - MONTH_OFFSET[int(isTimeInLeapYear(t))][month] + 1;
		}
		
		public static function getWeekDay(t:Number):int
		{
			var result:int = (getDay(t) + 4) % 7;
			if (result < 0)
			{
				result = 7 + result;
			}
			
			return result;
		}
		
		public static function getHourFromTime(t:Number):int
		{
			var result:int = (Math.floor((t + 0.5) / MSEC_PER_HOUR)) % HOURS_PER_DAY;
			if (result < 0)
			{
				result += HOURS_PER_DAY;
			}
			
			return result;
		}
		
		public static function getDayFromMonth(year:Number, month:Number):Number
		{
			var iMonth:int = month;
			if (iMonth < 0 || iMonth >= 12)
			{
				return NaN;
			}
			
			return getDayFromYear(int(year)) + MONTH_OFFSET[int(isLeapYear(int(year)))][iMonth];
		}
		
		public static function getMinFromTime(time:Number):int
		{
			var result:int = (Math.floor(time / MSEC_PER_MINUTE)) % MINUTES_PER_HOUR;
			if (result < 0)
			{
				result += MINUTES_PER_HOUR;
			}
			
			return result;
		}
		
		public static function getSecFromTime(time:Number):int
		{
			var result:int = (Math.floor(time / MSEC_PER_SECOND)) % SECONDS_PER_MINUTE;
			if (result < 0)
			{
				result += SECONDS_PER_MINUTE;
			}
			
			return result;
		}
		
		public static function getMsecFromTime(time:Number):int
		{
			var result:int = time % MSEC_PER_SECOND;
			if (result < 0)
			{
				result += MILLISEC_PER_SECOND;
			}
			return result;
		}
		
		public static function makeDate(day:Number, time:Number):Number
		{
			if (!isFinite(day) || !isFinite(time) || day != day || time != time)
			{
				return NaN;
			}
			day = int(day);
			time = int(time);
			
			return day * MSEC_PER_DAY + time;
		}
		
		public static function makeTime(hour:Number, min:Number, sec:Number, ms:Number):Number
		{
			if (!isFinite(hour) || !isFinite(min) || !isFinite(sec) || !isFinite(ms) || hour != hour || min != min || sec != sec || ms != ms)
			{
				return NaN;
			}
			
			hour = int(hour);
			min = int(min);
			sec = int(sec);
			ms = int(ms);
			
			return hour * MSEC_PER_HOUR + min * MSEC_PER_MINUTE + sec * MSEC_PER_SECOND + ms;
		}
		
		public static function makeDay(year:Number, month:Number, date:Number):Number
		{
			if (!isFinite(year) || !isFinite(month) || !isFinite(date) || year != year || month != month || date != date)
			{
				return NaN;
			}
			
			year = int(year);
			month = int(month);
			date = int(date);
			
			year += Math.floor(month / 12);
			month = month % 12;
			if (month < 0)
			{
				month += 12;
			}
			
			return getDayFromMonth(year, month) + (date - 1);
		}
	}
}