package common.model.base;

import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.IBean;

/**
 * Generated by JFinal, do not modify this file.
 */
@SuppressWarnings("serial")
public abstract class BaseDeviceInfo<M extends BaseDeviceInfo<M>> extends Model<M> implements IBean {

	public void setOpenudid(java.lang.String openudid) {
		set("openudid", openudid);
	}

	public java.lang.String getOpenudid() {
		return get("openudid");
	}

	public void setImei(java.lang.String imei) {
		set("imei", imei);
	}

	public java.lang.String getImei() {
		return get("imei");
	}

	public void setModel(java.lang.String model) {
		set("model", model);
	}

	public java.lang.String getModel() {
		return get("model");
	}

	public void setOs(java.lang.String os) {
		set("os", os);
	}

	public java.lang.String getOs() {
		return get("os");
	}

	public void setOsVersion(java.lang.String osVersion) {
		set("os_version", osVersion);
	}

	public java.lang.String getOsVersion() {
		return get("os_version");
	}

	public void setResolution(java.lang.String resolution) {
		set("resolution", resolution);
	}

	public java.lang.String getResolution() {
		return get("resolution");
	}

	public void setChId(java.lang.String chId) {
		set("ch_id", chId);
	}

	public java.lang.String getChId() {
		return get("ch_id");
	}

	public void setLocation(java.lang.String location) {
		set("location", location);
	}

	public java.lang.String getLocation() {
		return get("location");
	}

	public void setRealIp(java.lang.String realIp) {
		set("real_ip", realIp);
	}

	public java.lang.String getRealIp() {
		return get("real_ip");
	}

	public void setCountry(java.lang.String country) {
		set("country", country);
	}

	public java.lang.String getCountry() {
		return get("country");
	}

	public void setProvince(java.lang.String province) {
		set("province", province);
	}

	public java.lang.String getProvince() {
		return get("province");
	}

	public void setCity(java.lang.String city) {
		set("city", city);
	}

	public java.lang.String getCity() {
		return get("city");
	}

	public void setCarrier(java.lang.String carrier) {
		set("carrier", carrier);
	}

	public java.lang.String getCarrier() {
		return get("carrier");
	}

	public void setNet(java.lang.String net) {
		set("net", net);
	}

	public java.lang.String getNet() {
		return get("net");
	}

	public void setNetConnected(java.lang.String netConnected) {
		set("net_connected", netConnected);
	}

	public java.lang.String getNetConnected() {
		return get("net_connected");
	}

	public void setPakVersion(java.lang.String pakVersion) {
		set("pak_version", pakVersion);
	}

	public java.lang.String getPakVersion() {
		return get("pak_version");
	}

	public void setPackageName(java.lang.String packageName) {
		set("package_name", packageName);
	}

	public java.lang.String getPackageName() {
		return get("package_name");
	}

	public void setScriptVersion(java.lang.String scriptVersion) {
		set("script_version", scriptVersion);
	}

	public java.lang.String getScriptVersion() {
		return get("script_version");
	}

	public void setCreateTime(java.util.Date createTime) {
		set("create_time", createTime);
	}

	public java.util.Date getCreateTime() {
		return get("create_time");
	}

}
