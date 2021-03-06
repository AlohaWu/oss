package common.controllers.operations;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.jfinal.aop.Before;
import com.jfinal.aop.Clear;
import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.jfinal.ext.interceptor.GET;
import com.jfinal.ext.interceptor.POST;
import common.interceptor.GmInterceptor;
import common.service.OperationService;
import common.service.impl.OperationServiceImpl;
import common.util.StringUtils;

@Clear
public class FeedbackController extends Controller{
	private static Logger logger = Logger.getLogger(FeedbackController.class);
	private OperationService os = new OperationServiceImpl();
	/**
	 * 用户反馈页
	 * @author chris
	 * @role vip
	 */
	@Before({GET.class, GmInterceptor.class})
	@ActionKey("/operation/feedback")
	public void feedbackIndex() {
		render("userFeedback.html");
	}
	
	/**
	 * 玩家填写反馈页
	 * @author kola
	 * @role all
	 */
	 @Before(GET.class)
	 @ActionKey("/operation/feedback/players")
	 public void feedbackPlayers() {
	 	render("feedBack.html");
 	 }
	
	/**
	 * 用户反馈接口
	 * @author chris
	 * @getPara account 帐号id
	 * @getPara title 标题
	 * @getPara content 内容
	 * @getPara server 服务器
	 * @getPara port 端口
	 * @role vip 
	 */
	@Before(POST.class)
	@ActionKey("/api/operation/feedback")
	public void feedback() {
		String account = getPara("account", "");
		String title = getPara("title", "");
		String content = getPara("content", "");
		String server = getPara("server", "");
		String port = getPara("port", "");
		logger.info("params:{ " + "account:" + account + " title:" + title + " content:" + content + " server:" + server + " port:" + port + "}");
		if("".equals(account)){
			renderText("帐号格式非法");
			return;
		}
		boolean succeed = os.addFeedback(account, title, content, server, port);
		if(succeed == true){
			logger.info("return:" + "succeed");
			redirect("/operation/feedback/players");
		}
	}
	
	/**
	 * 查询用户反馈列表
	 * 当首次进入feedback页面 由于页面渲染的原因js可能获取不到当前服务器，server参数可能为“”，此时使用后端当前的db
	 * @author chris
	 * @role vip
	 */
	@Before({POST.class, GmInterceptor.class})
	@ActionKey("/api/operation/feedback/list")
	public void queryFeedback() {
		String startDate = getPara("startDate", "");
		String endDate = getPara("endDate", "");
		String server = StringUtils.arrayToQueryString(getParaValues("server[]"));
		
		logger.info("params {"+"startDate:"+startDate+",endDate:"+endDate+",server:"+server+"}");
		List<List<String>> data = os.queryFeedback(startDate, endDate, server);
		logger.info("return:" + data);
		renderJson(data);
	}
	
	/**
	 * 回复反馈成功修改 reply 为 1 
	 * @author chris
	 * @getPara id  -- mysql row id
	 * @role vip 
	 */
	@Before({POST.class, GmInterceptor.class})
	@ActionKey("/api/operation/feedback/user/reply")
	public void modifyFeedbackUserReply() {
		String id = getPara("id","");
		logger.info("params {" + "id:" + id + "}");
		if("".equals(id)){
			renderText("0");
			return;
		}
		try{
			int succeed = os.completeReply(Integer.parseInt(id));
			renderText(String.valueOf(succeed));
		}catch(Exception e){
			logger.info("Exception:", e);
		}
	}
	
	/**
	 * 置邮件发送后的操作记录状态为成功
	 * @param rowId --mysql row id
	 * @return row Id   /0表示失败
	 */
	@Before({POST.class, GmInterceptor.class})
	@ActionKey("/api/operation/record/mail/succeed")
	public void setGmRecordMailSucceed(){
		String rowId = getPara("rowId", "");
		logger.info("params {" + "rowId:" + rowId + "}");
		if("".equals(rowId)){
			renderText("0");
			return;
		}
		try{
			int succeed = os.setGmRecordMailToSucceed(Integer.parseInt(rowId));
			renderText(String.valueOf(succeed));
		}catch(Exception e){
			logger.info("Exception:", e);
		}
	}
	
	/**
	 * 根据某个row id 查询反馈信息
	 * @author chris
	 * @getPara id 获取row id
	 */
	@Before({POST.class,GmInterceptor.class})
	@ActionKey("/api/operation/feedback/user/detail")
	public void deleteFeedbackUser() {
		String id = getPara("id");
		logger.info("params: {" + "id:" + id + "}");
		Map<String, String> data = os.queryFeedbackById(id);
		renderJson(data);
	}
	
	/**
	 * 记录gm管理员的操作
	 * @author chris
	 * @getPara account 获取登录系统的帐号
	 * @getPara operation 获取gm的操作指令
	 */
	@Before(POST.class)
	@ActionKey("/api/operation/record")
	public void recordGm(){
		String account = getPara("account", "");
		String operation = getPara("operation", "");
		String emailAddress = getPara("emailAddress", "");
		String type = getPara("type", "mail");
		logger.info("params:{"+"account:"+account+",operation:"+operation+",emailAddress:"+emailAddress+",type"+type+"}");
		int rowId = os.insertGmRecord(account, operation, emailAddress, type);
		Map<String, Integer> data = new HashMap<String, Integer>();
		data.put("rowId", rowId);
		renderJson(data);
	}
}
