package common.service;

import java.util.Map;

public interface RealtimeService {
	public Map<String, String> queryBeforeData();
	
	public Map<String, String> queryRealtimeData();
}
