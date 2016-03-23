public class TwitterTestController extends Twitterforce {

    
    public List<TwitterStatus> publicStatuses { 
        get {
            return getPublicStatuses();
        } set; }
        
    public List<TwitterStatus> friendStatuses { get ; set; }
    public List<TwitterMessage> messages { get; set; }
    public List<TwitterMessage> messagesSent { get; set; }
    public List<TwitterUser> followers { get; set; }
    public Boolean haveError { get; set { if (value == false) errorMessage = ''; haveError = value;} }
    public String errorMessage { get; set; }
    
    public String newTweet { get; set; }
    public String un { get; set; }
    public String pw { get; set; }
    public String inReplyTo { get; set; }
    
    public TwitterUser thisUser { get; set; }
    public Boolean authenticated { get; set; }
    
    public TwitterTestController() {
        //un = 'djcarroll@gmail.com';
        authenticated = false; 
    }
    
    public pageReference loadFollowers() {
        followers = myFollowers();  
        return null;
    }
    
    public pageReference loadFriendsTimeline() {
        friendStatuses = friendsTimeline();
        return null;
    } 
    
    public pageReference loadMessages() {
        messages = getReceivedMessages();
        return null;
    }

    public pageReference loadMessagesSent() {
        messagesSent = getSentMessages();
        return null;
    }
    
    public pageReference authCheck() {
    	haveError = false;
        if (un != null || pw != null) {
        	try {
	            thisUser = checkCreds(un, pw);
	                
	            if (thisUser == null) {
	                authenticated = null;
	            } else {
	                loadFriendsTimeline();
	                loadMessages();
	                loadMessagesSent();
	                loadFollowers();
	                authenticated = true;
	            }
        	} catch (Exception ex) {
				haveError = true;
				errorMessage = ex.getMessage();
        	}
        }
        return null;
    }
    
    public pageReference doTweet() {
        tweet(newTweet, inReplyTo);
        newTweet = null;
        inReplyTo = null;
        return null;
    }

    public pageReference doMessage() {
        sendMessage(newTweet, inReplyTo);
        newTweet = null;
        inReplyTo = null;
        return null;
    }
}