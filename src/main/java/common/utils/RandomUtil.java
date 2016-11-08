package common.utils;

import java.util.Random;

public class RandomUtil {
	public static final String ALLCHAR = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	//generate a random String contains number,upper case and lower case letters.
	public static String getRandomString(int length) {

		Random random = new Random();

		StringBuffer sb = new StringBuffer();

		for (int i = 0; i < length; i++) {

			int number = random.nextInt(62);

			sb.append(ALLCHAR.charAt(number));
		}
		return sb.toString();
	}

	public static void main(String[] args) {
		System.out.println(getRandomString(8));
	}
}