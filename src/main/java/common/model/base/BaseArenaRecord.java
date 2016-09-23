package common.model.base;

import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.IBean;

/**
 * Generated by JFinal, do not modify this file.
 */
@SuppressWarnings("serial")
public abstract class BaseArenaRecord<M extends BaseArenaRecord<M>> extends Model<M> implements IBean {

	public void setId(java.lang.Long id) {
		set("id", id);
	}

	public java.lang.Long getId() {
		return get("id");
	}

	public void setAccount(java.lang.String account) {
		set("account", account);
	}

	public java.lang.String getAccount() {
		return get("account");
	}

	public void setLevel(java.lang.Integer level) {
		set("level", level);
	}

	public java.lang.Integer getLevel() {
		return get("level");
	}

	public void setRivalAccount(java.lang.String rivalAccount) {
		set("rival_account", rivalAccount);
	}

	public java.lang.String getRivalAccount() {
		return get("rival_account");
	}

	public void setRivalLevel(java.lang.Integer rivalLevel) {
		set("rival_level", rivalLevel);
	}

	public java.lang.Integer getRivalLevel() {
		return get("rival_level");
	}

	public void setResult(java.lang.Integer result) {
		set("result", result);
	}

	public java.lang.Integer getResult() {
		return get("result");
	}

	public void setBattleInfo(java.lang.String battleInfo) {
		set("battle_info", battleInfo);
	}

	public java.lang.String getBattleInfo() {
		return get("battle_info");
	}

	public void setTimeStamp(java.util.Date timeStamp) {
		set("time_stamp", timeStamp);
	}

	public java.util.Date getTimeStamp() {
		return get("time_stamp");
	}

}
