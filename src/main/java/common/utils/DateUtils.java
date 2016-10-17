package common.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

public class DateUtils {

	private static Logger logger = Logger.getLogger(DateUtils.class);
	public static Date strToDate(String dateString){
		Date date = null;
		SimpleDateFormat sdf;
		try {  
		    sdf = new SimpleDateFormat("yyyy-MM-dd");  
		    date = sdf.parse(dateString);  
		}catch (ParseException e){  
			logger.debug("throwable exception",e);
			logger.debug(e.getStackTrace());
		}
		return date;
	}
	
	public static Date strToMonth(String dateString){
		Date date = null;
		SimpleDateFormat sdf;
		try {  
		    sdf = new SimpleDateFormat("yyyy-MM");  
		    date = sdf.parse(dateString);  
		}catch (ParseException e){  
			logger.debug("throwable exception",e);
			logger.debug(e.getStackTrace());
		}
		return date;
	}
	
	public static String dateToStr(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
		return sdf.format(date);
	}
	
	public static String monthToStr(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM"); 
		return sdf.format(date);
	}
	
	public static List<String> getDateList(String startDate, String endDate){
		Date start = strToDate(startDate); 
		Date end = strToDate(endDate);
		
		Calendar cal = Calendar.getInstance();
		List<String> dateList = new ArrayList<String>();
		try {
			for(Date date=start;date.before(end)||date.equals(end);){
				dateList.add(dateToStr(date));
				cal.setTime(date);
				cal.add(Calendar.DATE, 1);
				date = cal.getTime();
			}
		}catch(Exception e){
			e.printStackTrace();
			logger.debug(e.getStackTrace());
			logger.debug("data transform failed");
		}
		return dateList;
	}
	
	public static List<String> getMonthList(String startMonth, String endMonth){
		Date start = strToMonth(startMonth); 
		Date end = strToMonth(endMonth);
		
		Calendar cal = Calendar.getInstance();
		List<String> monthList = new ArrayList<String>();
		try {
			for(Date date=start;date.before(end)||date.equals(end);){
				monthList.add(monthToStr(date));
				cal.setTime(date);
				cal.add(Calendar.MONTH, 1);
				date = cal.getTime();
			}
		}catch(Exception e){
			e.printStackTrace();
			logger.debug(e.getStackTrace());
			logger.debug("data transform failed");
		}
		return monthList;
	}
	
	public static String convertDate(String d){
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("今日", 0);
		map.put("昨日", -1);
		map.put("7日前", -7);
		map.put("30日前", -30);
		Date date=new Date();
		for(Map.Entry<String, Integer> entry:map.entrySet()){
			cal.setTime(date);
			cal.add(Calendar.DATE, entry.getValue());
			String dateString = formatter.format(cal.getTime());
			if(d.equals(dateString)){
				return entry.getKey();
			}
		}		
		return d;
	}
	//将时间段划分成周
	public static Map<String, String> divideDateToWeek(String startDate, String endDate){
		Date start = DateUtils.strToDate(startDate);
		Date end = DateUtils.strToDate(endDate);
		Map<String, String> week = new LinkedHashMap<String, String>();
		Calendar cal = Calendar.getInstance();
		for(Date date=start;date.before(end)||date.equals(end);){
			String startString = DateUtils.dateToStr(date);
			cal.setTime(date);
			cal.add(Calendar.DATE, 6);
			date=cal.getTime();
			String endString = DateUtils.dateToStr(date);
			week.put(startString, endString);
			cal.setTime(date);
			cal.add(Calendar.DATE, 1);
			date=cal.getTime();
		}
		return week;
	}
	
	public static String getTimeFromSecond(long s){
		final long DAY = 60*60*24;
		final long HOUR = 60*60;
		final long MINUTE = 60;
		long day = s/DAY;
		long hour = (s%DAY)/HOUR;
		long minute = ((s%DAY)%HOUR)/MINUTE;
		long second = ((s%DAY)%HOUR)%MINUTE;
		String str = "";
		if(day!=0) {
			str += String.valueOf(day) + "天";
		}
		if(hour!=0) {
			str += String.valueOf(hour) + "小时";
		}
		if(minute!=0) {
			str += String.valueOf(minute) + "分钟";
		}
		if(second!=0) {
			str += String.valueOf(second) + "秒";
		}
		return str;
	}
	public static void main(String args[]){
//		System.out.println(getDateList("2016-08-01", "2016-08-10"));
//		System.out.println(convertDate("2016-08-23"));
//		System.out.println(divideDateToWeek("2016-09-13","2016-09-14"));
//		System.out.println(getMonthList("2016-08","2016-11"));
//		System.out.println(monthToStr(DateUtils.strToDate("2016-09-13")));
		System.out.println(getTimeFromSecond(200000));
	}
	
}
