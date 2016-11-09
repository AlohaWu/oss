package common.service.impl;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import common.model.SecRole;
import common.model.SecUser;
import common.model.SecUserRole;
import common.service.AdminService;
import common.utils.EncryptUtils;
import common.utils.RandomUtil;
import common.utils.StringUtils;

import org.apache.log4j.Logger;

import com.jfinal.plugin.activerecord.Db;

public class AdminServiceImpl implements AdminService {
	private static Logger logger = Logger.getLogger(AdminServiceImpl.class);
	//查看user是否存在
	public SecUser getUser(String username) {
		String sql = "select password, salt from sec_user where user_name = ?";
		SecUser secUser = SecUser.dao.findFirst(sql, username);
		return secUser;
	}
	
	//根据username查询 用户角色
	public List<String> queryRoleByUsername(String username) {
		String sql = "select role_name from sec_role A join sec_user_role B on A.role_id = B.role_id join sec_user C on B.user_id = C.user_id where C.user_name = ?";
		List<SecRole> secRole = SecRole.dao.find(sql, username);
		
		List<String> roles = new ArrayList<String>();
		for(SecRole sr : secRole){
			String role = sr.getStr("role_name");
			roles.add(role);
		}
		return roles;
	}
	//判断角色是否具有该角色权限,如果该用户的role列表中存在一个role比当前Interceptor权重大则为true
	//例如Interceptor为DataGuest,而用户的具有admin的role权限,则为true
	public boolean validateRolePermission(List<String> roles, String queryRole) {
		boolean permission = false;
		int queryRoleWeight = getRoleWeight(queryRole);
		for(String r : roles){
			if(getRoleWeight(r) >= queryRoleWeight){
				permission = true;
				break;
			}
		}
		return permission;
	}
	//注册新账户
	public boolean signupUser(String username, String password, String role) {
		boolean succeed = false;
		String salt = RandomUtil.getRandomString(6);
		//密码原文 + salt
		password += salt;
		//md5处理密码后存数据库 password 字段
		try {
			password = EncryptUtils.EncoderByMd5(password);
		} catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
			e.printStackTrace();
			logger.debug("<AdminServiceImpl> Exception:", e);
		}
		SecUser secUser = new SecUser().set("user_name", username).set("password", password).set("salt", salt).set("created_time", new Date());
		succeed = secUser.save();
		int roleId = getRoleIdByRoleName(role);
		succeed = new SecUserRole().set("user_id", secUser.get("user_id")).set("role_id", roleId).save();
		return succeed;
	}
	
	//用户名是否已经存在
	public boolean existUser(String username) {
		boolean exist = false;
		String sql = "select * from sec_user where user_name = ?";
		SecUser secUser = SecUser.dao.findFirst(sql, username);
		if(secUser!=null){
			exist=true;
		}
		return exist;
	}
	
	//查询所有用户的权限
	public List<List<String>> queryAllUsers() {
		String sql = "select A.user_name,A.created_time,C.role_name from sec_user A join sec_user_role B on A.user_id = B.user_id join sec_role C on B.role_id = C.role_id;";
		List<SecUser> secUsers = SecUser.dao.find(sql);
		//Map<username,Map<role/createTime,String>>
		Map<String, Map<String, String>> sort = new HashMap<String, Map<String, String>>();
		for(SecUser su : secUsers){
			String username = su.getStr("user_name");
			String rolename = su.getStr("role_name");
			Date createTime = su.getDate("created_time");
			String roleStr = "";
			Map<String, String> subMap = null;
			if(sort.containsKey(username)){
				subMap = sort.get(username);
				roleStr = subMap.get("roleName");
				roleStr += ","+rolename;
				subMap.put("roleName", roleStr);
			}else{
				subMap = new LinkedHashMap<String, String>();
				subMap.put("roleName", rolename);
				subMap.put("createTime", createTime.toString());
			}
			sort.put(username, subMap);
		}
		List<List<String>> data = new ArrayList<List<String>>();
		for(Map.Entry<String, Map<String, String>> entry : sort.entrySet()){
			List<String> subList = new ArrayList<String>();
			subList.add(entry.getKey());
			subList.add(entry.getKey());
			for(Map.Entry<String, String> subEntry : entry.getValue().entrySet()){
				switch(subEntry.getKey()){
				case "roleName":
					subList.add(2, subEntry.getValue());
					break;
				case "createTime":
					subList.add(3, subEntry.getValue());
					break;
				}
			}
			subList.add(entry.getKey());
			data.add(subList);
		}
		logger.debug("<AdminServiceImpl> queryAllUsers:" + data);
		return data;
	}
	
	//根据用户名删除用户 返回值大于0为删除成功
	public int deleteByUserName(String users) {
		int deleted = 0;
		String qSql = "select user_id from sec_user where user_name in (" + users + ") ";
		List<SecUser> secUser = SecUser.dao.find(qSql);
		List<String> userIds = new ArrayList<String>();
		for(SecUser su : secUser){
			userIds.add(String.valueOf(su.getLong("user_id")));
		}
		String queryUserIds = StringUtils.arrayToQueryString(userIds.toArray(new String[userIds.size()]));
		String duSql = "delete from sec_user where user_id in (" + queryUserIds + ")";
		String duRSql = "delete from sec_user_role where user_id in (" + queryUserIds + ")";
		
		deleted = Db.update(duSql);
		deleted = Db.update(duRSql);
		logger.debug("<AdminServiceImpl> deleted:" + deleted);
		return deleted;
	}
	
	//先根据用户名查询现有的角色,比对 新要求角色 得到需要删除的角色列表,需要新增的角色列表,不变的角色列表,更改用户的角色
	public void changeRoles(String username, String[] queryRole) {
		List<Integer> roles = new ArrayList<Integer>();
		for(String s : queryRole){
			roles.add(getRoleIdByRoleName(s));
		}
		System.out.println(roles);
		String rSql = "select B.user_id,B.role_id from sec_user A join sec_user_role B on A.user_id = B.user_id where A.user_name = ?";
		List<SecUser> secUser = SecUser.dao.find(rSql, username);
		//Map<RoleId,value>   value 为0则需要删除,为1不变,为2新增
		Map<Integer,Integer> sort = new HashMap<Integer, Integer>();
		int userId = 0;
		//初始化保存数据库中的角色列表
		for(SecUser su : secUser){
			int role = su.getLong("role_id").intValue();
			userId = su.getLong("user_id").intValue();
			sort.put(role, 0);
		}
		//根据新的roleId整理
		for(int r : roles){
			if(sort.containsKey(r)){
				sort.put(r, 1);
			}else{
				sort.put(r, 2);
			}
		}
		List<String> deleteRole = new ArrayList<String>();
		List<Integer> addRole = new ArrayList<Integer>();
		for(Map.Entry<Integer, Integer> entry : sort.entrySet()){
			switch(entry.getValue()){
			case 0:
				deleteRole.add(String.valueOf(entry.getKey()));
				break;
			case 2:
				addRole.add(entry.getKey());
				break;
			}
		}
		//删除不需要的role
		String deleteStr = StringUtils.arrayToQueryString(deleteRole.toArray(new String[deleteRole.size()]));
		String dSql = "delete from sec_user_role where user_id = ? and role_id in (" + deleteStr + ")";
		Db.update(dSql, userId);
		
		//添加新增的role
		for(int a : addRole){
			new SecUserRole().set("user_id", userId).set("role_id", a).save();
		}
	}
	
	private int getRoleWeight(String role){
		int weight = 0;
		switch(role){
		case "root":
			weight = 4;
			break;
		case "admin":
			weight = 3;
			break;
		case "vip":
			weight = 2;
			break;
		case "data_guest":
			weight = 1;
			break;
		case "gm":
			weight = 1;
			break;
		}
		return weight;
	}
	
	private int getRoleIdByRoleName(String role){
		int roleId = 0;
		switch(role){
		case "root":
			roleId = 1;
			break;
		case "admin":
			roleId = 2;
			break;
		case "vip":
			roleId = 3;
			break;
		case "data_guest":
			roleId = 4;
			break;
		case "gm":
			roleId = 5;
			break;
		}
		return roleId;
	}
}
