package common.model;

import com.jfinal.plugin.activerecord.ActiveRecordPlugin;

/**
 * Generated by JFinal, do not modify this file.
 * <pre>
 * Example:
 * public void configPlugin(Plugins me) {
 *     ActiveRecordPlugin arp = new ActiveRecordPlugin(...);
 *     _MappingKit.mapping(arp);
 *     me.add(arp);
 * }
 * </pre>
 */
public class _MappingKit {

	public static void mapping(ActiveRecordPlugin arp) {
		arp.addMapping("active_user", "id", ActiveUser.class);
		arp.addMapping("client_view_hero_mp4", "id", ClientViewHeroMp4.class);
		arp.addMapping("create_role", "account", CreateRole.class);
		// Composite Primary Key order: openudid,os
		arp.addMapping("device_info", "openudid,os", DeviceInfo.class);
		arp.addMapping("gm_record", "id", GmRecord.class);
		arp.addMapping("level_up", "id", LevelUp.class);
		arp.addMapping("log_charge", "id", LogCharge.class);
		arp.addMapping("login", "id", Login.class);
		arp.addMapping("logout", "id", Logout.class);
		arp.addMapping("loss_user", "id", LossUser.class);
		arp.addMapping("payment_detail", "id", PaymentDetail.class);
		arp.addMapping("retain_equipment", "id", RetainEquipment.class);
		arp.addMapping("retain_user", "id", RetainUser.class);
		arp.addMapping("return_user", "id", ReturnUser.class);
		arp.addMapping("sec_role", "role_id", SecRole.class);
		arp.addMapping("sec_user", "user_id", SecUser.class);
		arp.addMapping("sec_user_role", "id", SecUserRole.class);
		arp.addMapping("user_feedback", "id", UserFeedback.class);
	}
}

