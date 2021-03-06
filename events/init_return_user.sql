DELIMITER |
DROP EVENT IF EXISTS egg_log.event_init_return_user |
CREATE EVENT IF NOT EXISTS egg_log.event_init_return_user
ON SCHEDULE EVERY 1 DAY 
ON COMPLETION PRESERVE
DO
-- 对return_user表进行历史数据恢复
BEGIN
    -- 声明活跃 及用于遍历的变量
    declare active_user_ios int(11);
    declare active_user_android int(11);
    declare active_user_windows int(11);
    declare v_active_user_ios int(11);
    declare v_active_user_android int(11);
    declare v_active_user_windows int(11);
    -- 声明付费 及用于遍历的变量
    declare paid_user_ios int(11);
    declare paid_user_android int(11);
    declare paid_user_windows int(11);
    declare v_paid_user_ios int(11);
    declare v_paid_user_android int(11);
    declare v_paid_user_windows int(11);
    -- 声明非付费 及用于遍历的变量
    declare nonpaid_user_ios int(11);
    declare nonpaid_user_android int(11);
    declare nonpaid_user_windows int(11);
    declare v_nonpaid_user_ios int(11);
    declare v_nonpaid_user_android int(11);
    declare v_nonpaid_user_windows int(11);
	-- 单独声明三十天
    declare thirty_ago_date date;
    declare thirty_active_return_ios int(11);
    declare thirty_active_return_android int(11);
    declare thirty_active_return_windows int(11);
	declare thirty_paid_return_ios int(11);
    declare thirty_paid_return_android int(11);
    declare thirty_paid_return_windows int(11);
    declare thirty_nonpaid_return_ios int(11);
    declare thirty_nonpaid_return_android int(11);
    declare thirty_nonpaid_return_windows int(11);
    
    declare i integer;
    declare j integer;
    declare count_day date;
    declare count_pre_day date;
    declare current_day date;
    declare current_next_day date;
    
    set j = 20;
	WHILE j > 0 DO
    BEGIN
		-- 定义统计日和统计日前一天
		set count_day = date_sub(curdate(), interval j day);
        set count_pre_day = date_sub(count_day, interval 1 day);
        -- 初始化统计日的数据
        set active_user_ios = 0;
		set active_user_android = 0;
		set active_user_windows = 0;
		set paid_user_ios = 0;
		set paid_user_android = 0;
		set paid_user_windows = 0;
		set nonpaid_user_ios = 0;
		set nonpaid_user_android = 0;
		set nonpaid_user_windows = 0;
		-- 统计日活跃玩家 
		select count(distinct A.account) into active_user_ios from login A join device_info B on A.openudid = B.openudid where A.date = count_day and B.os = "iOS";
		select count(distinct A.account) into active_user_android from login A join device_info B on A.openudid = B.openudid where A.date = count_day and B.os = "android";
		select count(distinct A.account) into active_user_windows from login A join device_info B on A.openudid = B.openudid where A.date = count_day and B.os = "windows";
		-- 统计日付费玩家
		select count(distinct A.account) into paid_user_ios from log_charge A join create_role B on A.account = B.account join device_info C on B.openudid = C.openudid  where A.is_product = 1 and DATE_FORMAT(A.timestamp,'%Y-%m-%d') = count_day and C.os = "iOS";
		select count(distinct A.account) into paid_user_android from log_charge A join create_role B on A.account = B.account join device_info C on B.openudid = C.openudid  where A.is_product = 1 and DATE_FORMAT(A.timestamp,'%Y-%m-%d') = count_day and C.os = "android";
		select count(distinct A.account) into paid_user_windows from log_charge A join create_role B on A.account = B.account join device_info C on B.openudid = C.openudid  where A.is_product = 1 and DATE_FORMAT(A.timestamp,'%Y-%m-%d') = count_day and C.os = "windows";
		-- 统计日非付费玩家
		select count(*) into nonpaid_user_ios from (select distinct account from login where date = count_day) A left join (select distinct account from log_charge where is_product = 1 and DATE_FORMAT(timestamp,'%Y-%m-%d') = count_day) B on A.account = B.account join create_role C on A.account = C.account join device_info D on C.openudid = D.openudid where B.account is null and D.os = "iOS";
		select count(*) into nonpaid_user_android from (select distinct account from login where date = count_day) A left join (select distinct account from log_charge where is_product = 1 and DATE_FORMAT(timestamp,'%Y-%m-%d') = count_day) B on A.account = B.account join create_role C on A.account = C.account join device_info D on C.openudid = D.openudid where B.account is null and D.os = "android";
		select count(*) into nonpaid_user_windows from (select distinct account from login where date = count_day) A left join (select distinct account from log_charge where is_product = 1 and DATE_FORMAT(timestamp,'%Y-%m-%d') = count_day) B on A.account = B.account join create_role C on A.account = C.account join device_info D on C.openudid = D.openudid where B.account is null and D.os = "windows";
		-- 插入统计日 活跃/付费/非付费  用户
		insert into return_user(num,date,type,os) values (active_user_ios,count_day,"active","iOS");
		insert into return_user(num,date,type,os) values (active_user_android,count_day,"active","android");
		insert into return_user(num,date,type,os) values (active_user_windows,count_day,"active","windows");
		insert into return_user(num,date,type,os) values (paid_user_ios,count_day,"paid","iOS");
		insert into return_user(num,date,type,os) values (paid_user_android,count_day,"paid","android");
		insert into return_user(num,date,type,os) values (paid_user_windows,count_day,"paid","windows");
		insert into return_user(num,date,type,os) values (nonpaid_user_ios,count_day,"nonpaid","iOS");
		insert into return_user(num,date,type,os) values (nonpaid_user_android,count_day,"nonpaid","android");
		insert into return_user(num,date,type,os) values (nonpaid_user_windows,count_day,"nonpaid","windows");
     
		set i = 2;
		WHILE i < 16 DO
		BEGIN
			set current_day = date_sub(count_day,interval i day);
			set current_next_day = date_add(current_day,interval 1 day);
			set v_active_user_ios = 0;
			set v_active_user_android = 0;
			set v_active_user_windows = 0;
			set v_paid_user_ios = 0;
			set v_paid_user_android = 0;
			set v_paid_user_windows = 0;
			set v_nonpaid_user_ios = 0;
			set v_nonpaid_user_android = 0;
			set v_nonpaid_user_windows = 0;
            
            select count(*) into v_active_user_ios from (select distinct account from login A join device_info B on A.openudid = B.openudid where A.date = current_day and B.os = "iOS") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between current_next_day and count_pre_day and B.os = "iOS") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null; 
			select count(*) into v_active_user_android from (select distinct account from login A join device_info B on A.openudid = B.openudid where A.date = current_day and B.os = "android") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between current_next_day and count_pre_day and B.os = "android") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
			select count(*) into v_active_user_windows from (select distinct account from login A join device_info B on A.openudid = B.openudid where A.date = current_day and B.os = "windows") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between current_next_day and count_pre_day and B.os = "windows") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
			
			select count(*) into v_paid_user_ios from (select distinct A.account from log_charge A join create_role B on A.account = B.account join device_info C on B.openudid = C.openudid  where A.is_product = 1 and DATE_FORMAT(A.timestamp,'%Y-%m-%d') = current_day and C.os = "iOS") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between current_next_day and count_pre_day and B.os = "iOS") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
			select count(*) into v_paid_user_android from (select distinct A.account from log_charge A join create_role B on A.account = B.account join device_info C on B.openudid = C.openudid  where A.is_product = 1 and DATE_FORMAT(A.timestamp,'%Y-%m-%d') = current_day and C.os = "android") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between current_next_day and count_pre_day and B.os = "android") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
			select count(*) into v_paid_user_windows from (select distinct A.account from log_charge A join create_role B on A.account = B.account join device_info C on B.openudid = C.openudid  where A.is_product = 1 and DATE_FORMAT(A.timestamp,'%Y-%m-%d') = current_day and C.os = "windows") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between current_next_day and count_pre_day and B.os = "windows") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
			
			select count(*) into v_nonpaid_user_ios from (select A.account from (select distinct account from login where date = current_day) A left join (select distinct account from log_charge where is_product = 1 and DATE_FORMAT(timestamp,'%Y-%m-%d') = current_day) B on A.account = B.account join create_role C on A.account = C.account join device_info D on C.openudid = D.openudid where B.account is null and D.os = "iOS") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between current_next_day and count_pre_day and B.os = "iOS") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
			select count(*) into v_nonpaid_user_android from (select A.account from (select distinct account from login where date = current_day) A left join (select distinct account from log_charge where is_product = 1 and DATE_FORMAT(timestamp,'%Y-%m-%d') = current_day) B on A.account = B.account join create_role C on A.account = C.account join device_info D on C.openudid = D.openudid where B.account is null and D.os = "android") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between current_next_day and count_pre_day and B.os = "android") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
			select count(*) into v_nonpaid_user_windows from (select A.account from (select distinct account from login where date = current_day) A left join (select distinct account from log_charge where is_product = 1 and DATE_FORMAT(timestamp,'%Y-%m-%d') = current_day) B on A.account = B.account join create_role C on A.account = C.account join device_info D on C.openudid = D.openudid where B.account is null and D.os = "windows") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between current_next_day and count_pre_day and B.os = "windows") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
			
            case i
				when 2 then
					update return_user set first_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set first_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set first_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set first_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set first_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set first_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set first_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set first_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set first_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 3 then
					update return_user set second_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set second_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set second_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set second_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set second_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set second_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set second_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set second_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set second_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 4 then
					update return_user set third_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set third_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set third_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set third_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set third_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set third_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set third_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set third_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set third_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 5 then
					update return_user set forth_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set forth_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set forth_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set forth_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set forth_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set forth_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set forth_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set forth_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set forth_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 6 then
					update return_user set fifth_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set fifth_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set fifth_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set fifth_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set fifth_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set fifth_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set fifth_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set fifth_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set fifth_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 7 then
					update return_user set sixth_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set sixth_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set sixth_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set sixth_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set sixth_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set sixth_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set sixth_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set sixth_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set sixth_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 8 then
					update return_user set seven_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set seven_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set seven_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set seven_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set seven_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set seven_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set seven_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set seven_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set seven_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 9 then
					update return_user set eighth_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set eighth_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set eighth_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set eighth_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set eighth_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set eighth_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set eighth_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set eighth_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set eighth_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 10 then
					update return_user set ninth_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set ninth_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set ninth_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set ninth_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set ninth_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set ninth_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set ninth_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set ninth_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set ninth_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 11 then
					update return_user set tenth_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set tenth_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set tenth_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set tenth_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set tenth_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set tenth_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set tenth_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set tenth_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set tenth_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 12 then
					update return_user set eleventh_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set eleventh_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set eleventh_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set eleventh_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set eleventh_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set eleventh_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set eleventh_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set eleventh_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set eleventh_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 13 then
					update return_user set twelfth_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set twelfth_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set twelfth_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set twelfth_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set twelfth_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set twelfth_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set twelfth_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set twelfth_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set twelfth_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 14 then
					update return_user set thirty_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set thirty_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set thirty_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set thirty_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set thirty_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set thirty_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set thirty_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set thirty_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set thirty_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
				when 15 then
					update return_user set fourteenth_day=v_active_user_ios where date=current_day and type="active" and os="iOS";
					update return_user set fourteenth_day=v_active_user_android where date=current_day and type="active" and os="android";
					update return_user set fourteenth_day=v_active_user_windows where date=current_day and type="active" and os="windows";
					update return_user set fourteenth_day=v_paid_user_ios where date=current_day and type="paid" and os="iOS";
					update return_user set fourteenth_day=v_paid_user_android where date=current_day and type="paid" and os="android";
					update return_user set fourteenth_day=v_paid_user_windows where date=current_day and type="paid" and os="windows";
					update return_user set fourteenth_day=v_nonpaid_user_ios where date=current_day and type="nonpaid" and os="iOS";
					update return_user set fourteenth_day=v_nonpaid_user_android where date=current_day and type="nonpaid" and os="android";
					update return_user set fourteenth_day=v_nonpaid_user_windows where date=current_day and type="nonpaid" and os="windows";
			 end case;
        
			set i = i+1;
		END;
		END WHILE;
        
        set thirty_ago_date = date_sub(count_day, interval 30 day);
		-- 三十日前活跃玩家回流   9-27 三十日回流
		select count(*) into thirty_active_return_ios from (select distinct account from login A join device_info B on A.openudid = B.openudid where A.date = date_sub(thirty_ago_date, interval 1 day) and B.os = "iOS") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between thirty_ago_date and count_pre_day and B.os = "iOS") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null; 
		select count(*) into thirty_active_return_android from (select distinct account from login A join device_info B on A.openudid = B.openudid where A.date = date_sub(thirty_ago_date, interval 1 day) and B.os = "android") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between thirty_ago_date and count_pre_day and B.os = "android") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null; 
		select count(*) into thirty_active_return_windows from (select distinct account from login A join device_info B on A.openudid = B.openudid where A.date = date_sub(thirty_ago_date, interval 1 day) and B.os = "windows") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between thirty_ago_date and count_pre_day and B.os = "windows") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;   
		-- 三十日前付费玩家回流 
		select count(*) into thirty_paid_return_ios from (select distinct A.account from log_charge A join create_role B on A.account = B.account join device_info C on B.openudid = C.openudid  where A.is_product = 1 and DATE_FORMAT(A.timestamp,'%Y-%m-%d') = date_sub(thirty_ago_date, interval 1 day) and C.os = "iOS") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between thirty_ago_date and count_pre_day and B.os = "iOS") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
		select count(*) into thirty_paid_return_android from (select distinct A.account from log_charge A join create_role B on A.account = B.account join device_info C on B.openudid = C.openudid  where A.is_product = 1 and DATE_FORMAT(A.timestamp,'%Y-%m-%d') = date_sub(thirty_ago_date, interval 1 day) and C.os = "android") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between thirty_ago_date and count_pre_day and B.os = "android") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
		select count(*) into thirty_paid_return_windows from (select distinct A.account from log_charge A join create_role B on A.account = B.account join device_info C on B.openudid = C.openudid  where A.is_product = 1 and DATE_FORMAT(A.timestamp,'%Y-%m-%d') = date_sub(thirty_ago_date, interval 1 day) and C.os = "windows") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between thirty_ago_date and count_pre_day and B.os = "windows") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
		-- 三十日前非付费玩家回流
		select count(*) into thirty_nonpaid_return_ios from (select A.account from (select distinct account from login where date = date_sub(thirty_ago_date, interval 1 day)) A left join (select distinct account from log_charge where is_product = 1 and DATE_FORMAT(timestamp,'%Y-%m-%d') = date_sub(thirty_ago_date, interval 1 day)) B on A.account = B.account join create_role C on A.account = C.account join device_info D on C.openudid = D.openudid where B.account is null and D.os = "iOS") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between thirty_ago_date and count_pre_day and B.os = "iOS") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
		select count(*) into thirty_nonpaid_return_android from (select A.account from (select distinct account from login where date = date_sub(thirty_ago_date, interval 1 day)) A left join (select distinct account from log_charge where is_product = 1 and DATE_FORMAT(timestamp,'%Y-%m-%d') = date_sub(thirty_ago_date, interval 1 day)) B on A.account = B.account join create_role C on A.account = C.account join device_info D on C.openudid = D.openudid where B.account is null and D.os = "android") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between thirty_ago_date and count_pre_day and B.os = "android") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
		select count(*) into thirty_nonpaid_return_windows from (select A.account from (select distinct account from login where date = date_sub(thirty_ago_date, interval 1 day)) A left join (select distinct account from log_charge where is_product = 1 and DATE_FORMAT(timestamp,'%Y-%m-%d') = date_sub(thirty_ago_date, interval 1 day)) B on A.account = B.account join create_role C on A.account = C.account join device_info D on C.openudid = D.openudid where B.account is null and D.os = "windows") A left join (select distinct A.account from login A join device_info B on A.openudid = B.openudid where A.date between thirty_ago_date and count_pre_day and B.os = "windows") B on A.account = B.account join (select distinct account from login where date = count_day) C on A.account = C.account where B.account is null;
		 
		-- 更新 30日 活跃/付费/非付费 回流用户    
		update return_user set thirty_day=thirty_active_return_ios where date=date_sub(thirty_ago_date, interval 1 day) and type="active" and os="iOS";
		update return_user set thirty_day=thirty_active_return_android where date=date_sub(thirty_ago_date, interval 1 day) and type="active" and os="android";
		update return_user set thirty_day=thirty_active_return_windows where date=date_sub(thirty_ago_date, interval 1 day) and type="active" and os="windows";
		update return_user set thirty_day=thirty_paid_return_ios where date=date_sub(thirty_ago_date, interval 1 day) and type="paid" and os="iOS";
		update return_user set thirty_day=thirty_paid_return_android where date=date_sub(thirty_ago_date, interval 1 day) and type="paid" and os="android";
		update return_user set thirty_day=thirty_paid_return_windows where date=date_sub(thirty_ago_date, interval 1 day) and type="paid" and os="windows";
		update return_user set thirty_day=thirty_nonpaid_return_ios where date=date_sub(thirty_ago_date, interval 1 day) and type="nonpaid" and os="iOS";
		update return_user set thirty_day=thirty_nonpaid_return_android where date=date_sub(thirty_ago_date, interval 1 day) and type="nonpaid" and os="android";
		update return_user set thirty_day=thirty_nonpaid_return_windows where date=date_sub(thirty_ago_date, interval 1 day) and type="nonpaid" and os="windows";
        
    set j = j-1;
    END;
    END WHILE;
    
END |
DELIMITER ;