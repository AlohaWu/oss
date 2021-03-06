package common.model.base;

import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.IBean;

/**
 * Generated by JFinal, do not modify this file.
 */
@SuppressWarnings("serial")
public abstract class BaseSecUser<M extends BaseSecUser<M>> extends Model<M> implements IBean {

	public void setUserId(java.lang.Long userId) {
		set("user_id", userId);
	}

	public java.lang.Long getUserId() {
		return get("user_id");
	}

	public void setUserName(java.lang.String userName) {
		set("user_name", userName);
	}

	public java.lang.String getUserName() {
		return get("user_name");
	}

	public void setPassword(java.lang.String password) {
		set("password", password);
	}

	public java.lang.String getPassword() {
		return get("password");
	}

	public void setSalt(java.lang.String salt) {
		set("salt", salt);
	}

	public java.lang.String getSalt() {
		return get("salt");
	}

	public void setCreatedTime(java.util.Date createdTime) {
		set("created_time", createdTime);
	}

	public java.util.Date getCreatedTime() {
		return get("created_time");
	}

	public void setUpdateTime(java.util.Date updateTime) {
		set("update_time", updateTime);
	}

	public java.util.Date getUpdateTime() {
		return get("update_time");
	}

	public void setRealtime(java.lang.String realtime) {
		set("realtime", realtime);
	}

	public java.lang.String getRealtime() {
		return get("realtime");
	}

	public void setForm(java.lang.String form) {
		set("form", form);
	}

	public java.lang.String getForm() {
		return get("form");
	}

	public void setPlayerAnalyse(java.lang.String playerAnalyse) {
		set("player_analyse", playerAnalyse);
	}

	public java.lang.String getPlayerAnalyse() {
		return get("player_analyse");
	}

	public void setPaidAnalyse(java.lang.String paidAnalyse) {
		set("paid_analyse", paidAnalyse);
	}

	public java.lang.String getPaidAnalyse() {
		return get("paid_analyse");
	}

	public void setLoss(java.lang.String loss) {
		set("loss", loss);
	}

	public java.lang.String getLoss() {
		return get("loss");
	}

	public void setOnlineAnalyse(java.lang.String onlineAnalyse) {
		set("online_analyse", onlineAnalyse);
	}

	public java.lang.String getOnlineAnalyse() {
		return get("online_analyse");
	}

	public void setChannelAnalyse(java.lang.String channelAnalyse) {
		set("channel_analyse", channelAnalyse);
	}

	public java.lang.String getChannelAnalyse() {
		return get("channel_analyse");
	}

	public void setSystemAnalyse(java.lang.String systemAnalyse) {
		set("system_analyse", systemAnalyse);
	}

	public java.lang.String getSystemAnalyse() {
		return get("system_analyse");
	}

	public void setVersionAnalyse(java.lang.String versionAnalyse) {
		set("version_analyse", versionAnalyse);
	}

	public java.lang.String getVersionAnalyse() {
		return get("version_analyse");
	}

	public void setCustomEvent(java.lang.String customEvent) {
		set("custom_event", customEvent);
	}

	public java.lang.String getCustomEvent() {
		return get("custom_event");
	}

	public void setOpSupport(java.lang.String opSupport) {
		set("op_support", opSupport);
	}

	public java.lang.String getOpSupport() {
		return get("op_support");
	}

	public void setDataDig(java.lang.String dataDig) {
		set("data_dig", dataDig);
	}

	public java.lang.String getDataDig() {
		return get("data_dig");
	}

	public void setMarketAnalyse(java.lang.String marketAnalyse) {
		set("market_analyse", marketAnalyse);
	}

	public java.lang.String getMarketAnalyse() {
		return get("market_analyse");
	}

	public void setTechSupport(java.lang.String techSupport) {
		set("tech_support", techSupport);
	}

	public java.lang.String getTechSupport() {
		return get("tech_support");
	}

	public void setManagementCenter(java.lang.String managementCenter) {
		set("management_center", managementCenter);
	}

	public java.lang.String getManagementCenter() {
		return get("management_center");
	}

	public void setServer(java.lang.String server) {
		set("server", server);
	}

	public java.lang.String getServer() {
		return get("server");
	}

}
