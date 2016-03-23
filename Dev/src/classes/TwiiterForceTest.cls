/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TwiiterForceTest {

	private class TwitterForceTester extends TwitterForce {
		TwitterForceTester(String u, String p) {
			super(u,p);
		}
		TwitterForceTester() {
			super();
		}
		/*public override List<TwitterStatus> parseStatuses(XmlStreamReader x) {
			return super.parseStatuses(x);
		}
		
		public override HttpRequest createRequest(String m, String p) {
			return super.createRequest(m,p);
		}
		
		public override HttpRequest createAnonRequest(String m, String p) {
			return super.createAnonRequest(m,p);
		}

		public override HttpRequest createRequest(String m, String p, Map<String, String> params) {
			return super.createRequest(m,p, params);
		}*/
		 
		public override String getResponseBody(HttpResponse r, HttpRequest req) {
			super.getResponseBody(r, req);
			String ep = req.getEndpoint();
			System.debug(LoggingLevel.INFO, '\n\nGET RESPONSE FOR ' + ep + '\n\n');
			String body = '';
			if (ep.equals('http://twitter.com/account/verify_credentials.xml')) {
				System.debug(LoggingLevel.INFO, '\n\nverify_credentials_xml\n\n');
				body = checkCredsResponse;
			} else if (ep.equals('http://twitter.com/account/rate_limit_status.xml')) {
				System.debug(LoggingLevel.INFO, '\n\nrate_limit_status.xml\n\n');
				body = rateLimitStatusResponse;
			} else if (ep.equals('http://twitter.com/direct_messages.xml') || ep.equals('http://twitter.com/direct_messages/sent.xml')) {
				System.debug(LoggingLevel.INFO, '\n\ndirect_messages.xml\n\n');
				body = getMessagesResponse;
			} else if (ep.equals('http://twitter.com/direct_messages/new.xml') ) {
				System.debug(LoggingLevel.INFO, '\n\ndirect_messages/new.xml\n\n');
				body = singleMessageResponse;
			} else if (ep.equals('http://twitter.com/statuses/followers.xml')) {
				System.debug(LoggingLevel.INFO, '\n\nstatuses/followers.xml\n\n');
				body = multipleUsersResponse;
			} else if (ep.equals('http://twitter.com/statuses/update.xml')) {
				System.debug(LoggingLevel.INFO, '\n\nstatuses/update.xml\n\n');
				body = getSingleStatus();
			} else if (ep.equals('http://twitter.com/statuses/friends_timeline.xml') || ep.equals('http://twitter.com/statuses/public_timeline.xml') ) {
				System.debug(LoggingLevel.INFO, '\n\nstatuses\n\n');
				body = getStatuses();
			} else if (ep.indexOf('search.atom') != -1) {
				System.debug(LoggingLevel.INFO, '\n\nsearch.atom\n\n');
				body = searchResponse;
			}
			System.debug(LoggingLevel.INFO, '\n\nReturning body: \n' + body + '\n\n');
			return body;
		}
		
		public override HttpResponse execute(HttpRequest req) {
			HttpResponse r = new HttpResponse();
			return r;
		}
	}
	
    static testMethod void testAuthHeader() {
    	/*TwitterForceTester t = new TwitterForceTester();
    	TwitterForceTester tf = new TwitterForceTester('foo','bar');
    	HttpRequest r = tf.createRequest('GET', 'foo');
    	System.assertEquals('Basic Zm9vOmJhcg==', r.getHeader('Authorization'));
    	System.assertEquals('GET', r.getMethod());
    	System.assertEquals('http://twitter.com/foo', r.getEndpoint());    	*/
    }
    
    static testMethod void methodSignatureTests() {
    	TwitterForceTester t = new TwitterForceTester();
    	/*Map<String, String> params = new Map<String, String>();
    	params.put('p1', 'v1');
    	HttpRequest r = t.createRequest('GET', 'foo', params);
    	r = t.createAnonRequest('GET', 'foo');
    	t.execute(r);
    	t.postUpdate('foo', 'bar'); 
    	t.checkCreds('user', 'toolkittesting');
    	t.getRateLimitStatus();
    	t.getReceivedMessages();
    	t.getSentMessages();
    	t.sendMessage('user', 'msg');*/
    	t.myFollowers();
    	/*t.friendsTimeline();
    	t.getPublicStatuses();
    	Atom.Feed f = t.wordSearch('searchword');
    	new Atom.Feed().testProperties();
    	f.testProperties();
    	t.tweet('tweet');
    	t.tweet('tweet', 'replyId');
    	t.getRateLimitStatus();
    	TwitterMessage m = new TwitterMessage('foo', 'bor');*/
    }
    
    static testMethod void testStatusesParser() {
    	/*TwitterForceTester t = new TwitterForceTester('foo','bar');
    	List<TwitterStatus> statuses = t.parseStatuses(t.getReader(getStatuses()));
    	System.assertEquals(3, statuses.size());
    	TwitterStatus s = statuses[0]; 
    	System.assertEquals('Sun Nov 02 03:20:06 +0000 2008', s.createdAt);
    	System.assertEquals('985929063', s.id);
    	System.assertEquals('@superfell not using twitter api yet <a href="http://tinyurl.com/5r9kn0" target="_blank">http://tinyurl.com/5r9kn0</a> from apex. show us what it can do!', s.text);
    	System.assertEquals('<a href="http://github.com/dustin/twitterspy">TwitterSpy</a>', s.source);
    	System.assertEquals(false, s.truncated);
    	System.assertEquals('985892918', s.inReplyToStatusId);
    	System.assertEquals('17104583', s.inReplyToUserId);
    	System.assertEquals(false, s.favorited);
    	System.assertEquals('8420652', s.user.id);
    	System.assertEquals('Scott Hemmeter', s.user.name);
    	System.assertEquals('arrowpointe', s.user.screenName);
    	System.assertEquals('Southern Cal, USA', s.user.location);
    	System.assertEquals('Services & Applications on the Salesforce.com platform', s.user.description);
    	System.assertEquals('http://s3.amazonaws.com/twitter_production/profile_images/21840362/twitter_normal.jpg', s.user.profileImageUrl);
    	System.assertEquals('http://sfdc.arrowpointe.com', s.user.url);
    	System.assertEquals(false, s.user.isProtected);
    	System.assertEquals(91, s.user.followersCount);
    	
    	// Backward compatibility coverage
    	s.inReplyToUserId = s.in_reply_to_user_id;
    	s.inReplyToStatusId = s.in_reply_to_status_id;
    	s.createdAt = s.created_at;
    	s.user.isProtected = s.user.is_protected;
    	s.user.followersCount = s.user.followers_count;
    	s.user.profileImageUrl = s.user.profile_image_url;
    	s.user.screenName = s.user.screen_name;
    	// End Backward compatibility coverage
    	
    	s.testGetTimeStamp();
    	s.testGetMonthVal();*/
    }
    
    static String searchResponse { get {
    	return '<?xml version="1.0" encoding="UTF-8"?>' +
				'<feed xmlns:google="http://base.google.com/ns/1.0" xml:lang="en-US" xmlns:openSearch="http://a9.com/-/spec/opensearch/1.1/" xmlns="http://www.w3.org/2005/Atom" xmlns:twitter="http://api.twitter.com/">' +
				  '<id>tag:search.twitter.com,2005:search/"AT&amp;T earnings"</id>' +
				  '<link type="text/html" rel="alternate" href="http://search.twitter.com/search?q=%22AT%26T+earnings%22"/>' +
				  '<link type="application/atom+xml" rel="self" href="http://search.twitter.com/search.atom?q=%22AT%26T+earnings%22"/>' +
				  '<title>"AT&amp;T earnings" - Twitter Search</title>' +
				  '<link type="application/opensearchdescription+xml" rel="search" href="http://search.twitter.com/opensearch.xml"/>' +
				  '<link type="application/atom+xml" rel="refresh" href="http://search.twitter.com/search.atom?q=%22AT%26T+earnings%22&amp;since_id=1642111852"/>' +
				  '<updated>2009-04-25T02:04:31Z</updated>' +
				  '<openSearch:itemsPerPage>15</openSearch:itemsPerPage>' +
				  '<link type="application/atom+xml" rel="next" href="http://search.twitter.com/search.atom?max_id=1642111852&amp;page=2&amp;q=%22AT%26T+earnings%22"/>' +
				  '<entry>' +
				    '<id>tag:search.twitter.com,2005:1609631359</id>' +
				    '<published>2009-04-25T02:04:31Z</published>' +
				    '<link type="text/html" rel="alternate" href="http://twitter.com/wirelesswire/statuses/1609631359"/>' +
				    '<title>AT&amp;T Earnings Call, First Quarter 2009 - 123Jump.com: AT&amp;T Earnings Call, First Quarter 2009123Jump.com,.. http://tinyurl.com/c3y4yu</title>' +
				    '<content type="html">&lt;b&gt;AT&amp;amp;T Earnings&lt;/b&gt; Call, First Quarter 2009 - 123Jump.com: &lt;b&gt;AT&amp;amp;T Earnings&lt;/b&gt; Call, First Quarter 2009123Jump.com,.. &lt;a href="http://tinyurl.com/c3y4yu"&gt;http://tinyurl.com/c3y4yu&lt;/a&gt;</content>' +
				    '<updated>2009-04-25T02:04:31Z</updated>' +
				    '<link type="image/png" rel="image" href="http://static.twitter.com/images/default_profile_normal.png"/>' +
				    '<twitter:source>&lt;a href="http://twitterfeed.com"&gt;twitterfeed&lt;/a&gt;</twitter:source>' +
				    '<twitter:lang>en</twitter:lang>' +
				    '<author>' +
				      '<name>wirelesswire (wirelesswire)</name>' +
				      '<uri>http://twitter.com/wirelesswire</uri>' +
				    '</author>' +
				  '</entry>' +
				  '<entry>' +
				    '<id>tag:search.twitter.com,2005:1604722227</id>' +
				    '<published>2009-04-24T15:47:30Z</published>' +
				    '<link type="text/html" rel="alternate" href="http://twitter.com/thedigitalworld/statuses/1604722227"/>' +
				    '<title>"Apple\'s iPhone Puts AT&amp;T Earnings Above Estimates " http://is.gd/ujiB</title>' +
				    '<content type="html">&amp;quot;Apple\'s iPhone Puts &lt;b&gt;AT&amp;amp;T Earnings&lt;/b&gt; Above Estimates &amp;quot; &lt;a href="http://is.gd/ujiB"&gt;http://is.gd/ujiB&lt;/a&gt;</content>' +
				    '<updated>2009-04-24T15:47:30Z</updated>' +
				    '<link type="image/png" rel="image" href="http://s3.amazonaws.com/twitter_production/profile_images/181029950/logo-thedigitalnews_normal.jpg"/>' +
				    '<twitter:source>&lt;a href="http://twitter.com/"&gt;web&lt;/a&gt;</twitter:source>' +
				    '<twitter:lang>en</twitter:lang>' +
				    '<author>' +
				      '<name>thedigitalworld (.digitalworld.)</name>' +
				      '<uri>http://twitter.com/thedigitalworld</uri>' +
				    '</author>' +
				  '</entry>' +
				'</feed>';
    } }
    
    static String getMessagesResponse { get {
		return '<?xml version="1.0" encoding="UTF-8"?>' +
			'<direct-messages type="array">' +
			'<direct_message>' +
			  '<id>73288794</id>' +
			  '<sender_id>5377742</sender_id>' +
			  '<text>Thanks for following! http://tinyurl/7y6ss0</text>' +
			  '<recipient_id>7688502</recipient_id>' +
			  '<created_at>Sat Mar 14 05:11:08 +0000 2009</created_at>' +
			  '<sender_screen_name>porcupinex</sender_screen_name>' +
			  '<recipient_screen_name>dcarroll</recipient_screen_name>' +
			  '<sender>' +
			    '<id>5377742</id>' +
			    '<name>J&#248;rgen Larsen</name>' +
			    '<screen_name>porcupinex</screen_name>' +
			    '<location>Copenhagen, Denmark</location>' +
			    '<description>Expert in software devlopment, photographer, open networker, writer, handyman, old DJ+radiohost, idealist, creative, easily inspired, very independent, spunky</description>' +
			    '<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/70410190/JorgenLarsen2009SqrW0080_normal.jpg</profile_image_url>' +
			    '<url>http://porcupinex.net/</url>' +
			    '<protected>false</protected>' +
			    '<followers_count>1995</followers_count>' +
			  '</sender>' +
			  '<recipient>' +
			    '<id>7688502</id>' +
			    '<name>dcarroll</name>' +
			    '<screen_name>dcarroll</screen_name>' +
			    '<location>Redwood City, California</location>' +
			    '<description></description>' +
			    '<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/77151021/Photo_28_normal.jpg</profile_image_url>' +
			    '<url></url>' +
			    '<protected>false</protected>' +
			    '<followers_count>39</followers_count>' +
			  '</recipient>' +
			'</direct_message>' +
			'<direct_message>' +
			  '<id>72319790</id>' +
			  '<sender_id>5740872</sender_id>' +
			  '<text>bummer. If I do anything like this again, http://tinyurl/2uu38s I\'ll give you more notice.</text>' +
			  '<recipient_id>7688502</recipient_id>' +
			  '<created_at>Thu Mar 12 15:34:58 +0000 2009</created_at>' +
			  '<sender_screen_name>gokubi</sender_screen_name>' +
			  '<recipient_screen_name>dcarroll</recipient_screen_name>' +
			  '<sender>' +
			    '<id>5740872</id>' +
			    '<name>Steve Andersen</name>' +
			    '<screen_name>gokubi</screen_name>' +
			    '<location>Seattle</location>' +
			    '<description>CRM loser</description>' +
			    '<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/71288598/steve_glasses_normal.jpg</profile_image_url>' +
			    '<url>http://gokubi.com</url>' +
			    '<protected>false</protected>' +
			    '<followers_count>186</followers_count>' +
			  '</sender>' +
			  '<recipient>' +
			    '<id>7688502</id>' +
			    '<name>dcarroll</name>' +
			    '<screen_name>dcarroll</screen_name>' +
			    '<location>Redwood City, California</location>' +
			    '<description></description>' +
			    '<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/77151021/Photo_28_normal.jpg</profile_image_url>' +
			    '<url></url>' +
			    '<protected>false</protected>' +
			    '<followers_count>45</followers_count>' +
			  '</recipient>' +
			'</direct_message>' +
		   '</direct-messages>'
		;
	} }
	
	static String singleUserResponse { get {
		return '<?xml version="1.0" encoding="UTF-8"?>' +
					'<user>' +
					  '<id>36201961</id>' +
					  '<name>Dave Carroll</name>' +
					  '<screen_name>carrolltest</screen_name>' +
					  '<location></location>' +
					  '<description></description>' +
					  '<profile_image_url>http://static.twitter.com/images/default_profile_normal.png</profile_image_url>' +
					  '<url></url>' +
					  '<protected>false</protected>' +
					  '<followers_count>0</followers_count>' +
					  '<profile_background_color>9ae4e8</profile_background_color>' +
					  '<profile_text_color>000000</profile_text_color>' +
					  '<profile_link_color>0000ff</profile_link_color>' +
					  '<profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>' +
					  '<profile_sidebar_border_color>87bc44</profile_sidebar_border_color>' +
					  '<friends_count>0</friends_count>' +
					  '<created_at>Tue Apr 28 22:31:19 +0000 2009</created_at>' +
					  '<favourites_count>0</favourites_count>' +
					  '<utc_offset></utc_offset>' +
					  '<time_zone></time_zone>' +
					  '<profile_background_image_url>http://static.twitter.com/images/themes/theme1/bg.gif</profile_background_image_url>' +
					  '<profile_background_tile>false</profile_background_tile>' +
					  '<statuses_count>1</statuses_count>' +
					  '<notifications>false</notifications>' +
					  '<following>false</following>' +
					  '<status>' +
					    '<created_at>Tue Apr 28 22:42:08 +0000 2009</created_at>' +
					    '<id>1643391007</id>' +
					    '<text>braggbigbug</text>' +
					    '<source>web</source>' +
					    '<truncated>false</truncated>' +
					    '<in_reply_to_status_id></in_reply_to_status_id>' +
					    '<in_reply_to_user_id></in_reply_to_user_id>' +
					    '<favorited>false</favorited>' +
					    '<in_reply_to_screen_name></in_reply_to_screen_name>' +
					  '</status>' +
					'</user>';
	} }
	
	static String multipleUsersResponse { get {
		return '<?xml version="1.0" encoding="UTF-8"?>' +
				'<users type="array">' +
					'<user>' +
					  '<id>36201961</id>' +
					  '<name>Dave Carroll</name>' +
					  '<screen_name>carrolltest</screen_name>' +
					  '<location></location>' +
					  '<description></description>' +
					  '<profile_image_url>http://static.twitter.com/images/default_profile_normal.png</profile_image_url>' +
					  '<url></url>' +
					  '<protected>false</protected>' +
					  '<followers_count>0</followers_count>' +
					  '<profile_background_color>9ae4e8</profile_background_color>' +
					  '<profile_text_color>000000</profile_text_color>' +
					  '<profile_link_color>0000ff</profile_link_color>' +
					  '<profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>' +
					  '<profile_sidebar_border_color>87bc44</profile_sidebar_border_color>' +
					  '<friends_count>0</friends_count>' +
					  '<created_at>Tue Apr 28 22:31:19 +0000 2009</created_at>' +
					  '<favourites_count>0</favourites_count>' +
					  '<utc_offset></utc_offset>' +
					  '<time_zone></time_zone>' +
					  '<profile_background_image_url>http://static.twitter.com/images/themes/theme1/bg.gif</profile_background_image_url>' +
					  '<profile_background_tile>false</profile_background_tile>' +
					  '<statuses_count>1</statuses_count>' +
					  '<notifications>false</notifications>' +
					  '<following>false</following>' +
					  '<status>' +
					    '<created_at>Tue Apr 28 22:42:08 +0000 2009</created_at>' +
					    '<id>1643391007</id>' +
					    '<text>braggbigbug</text>' +
					    '<source>web</source>' +
					    '<truncated>false</truncated>' +
					    '<in_reply_to_status_id></in_reply_to_status_id>' +
					    '<in_reply_to_user_id></in_reply_to_user_id>' +
					    '<favorited>false</favorited>' +
					    '<in_reply_to_screen_name></in_reply_to_screen_name>' +
					  '</status>' +
					'</user>' +
					'<user>' +
					  '<id>36201961</id>' +
					  '<name>Dave Carroll</name>' +
					  '<screen_name>carrolltest</screen_name>' +
					  '<location></location>' +
					  '<description></description>' +
					  '<profile_image_url>http://static.twitter.com/images/default_profile_normal.png</profile_image_url>' +
					  '<url></url>' +
					  '<protected>false</protected>' +
					  '<followers_count>0</followers_count>' +
					  '<profile_background_color>9ae4e8</profile_background_color>' +
					  '<profile_text_color>000000</profile_text_color>' +
					  '<profile_link_color>0000ff</profile_link_color>' +
					  '<profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>' +
					  '<profile_sidebar_border_color>87bc44</profile_sidebar_border_color>' +
					  '<friends_count>0</friends_count>' +
					  '<created_at>Tue Apr 28 22:31:19 +0000 2009</created_at>' +
					  '<favourites_count>0</favourites_count>' +
					  '<utc_offset></utc_offset>' +
					  '<time_zone></time_zone>' +
					  '<profile_background_image_url>http://static.twitter.com/images/themes/theme1/bg.gif</profile_background_image_url>' +
					  '<profile_background_tile>false</profile_background_tile>' +
					  '<statuses_count>1</statuses_count>' +
					  '<notifications>false</notifications>' +
					  '<following>false</following>' +
					  '<status>' +
					    '<created_at>Tue Apr 28 22:42:08 +0000 2009</created_at>' +
					    '<id>1643391007</id>' +
					    '<text>braggbigbug</text>' +
					    '<source>web</source>' +
					    '<truncated>false</truncated>' +
					    '<in_reply_to_status_id></in_reply_to_status_id>' +
					    '<in_reply_to_user_id></in_reply_to_user_id>' +
					    '<favorited>false</favorited>' +
					    '<in_reply_to_screen_name></in_reply_to_screen_name>' +
					  '</status>' +
					'</user>' +
				'</users>';
	} }
	
    static String singleMessageResponse { get {
		return '<?xml version="1.0" encoding="UTF-8"?>' +
			'<direct_message>' +
			  '<id>73288794</id>' +
			  '<sender_id>5377742</sender_id>' +
			  '<text>Thanks for following!</text>' +
			  '<recipient_id>7688502</recipient_id>' +
			  '<created_at>Sat Mar 14 05:11:08 +0000 2009</created_at>' +
			  '<sender_screen_name>porcupinex</sender_screen_name>' +
			  '<recipient_screen_name>dcarroll</recipient_screen_name>' +
			  '<sender>' +
			    '<id>5377742</id>' +
			    '<name>J&#248;rgen Larsen</name>' +
			    '<screen_name>porcupinex</screen_name>' +
			    '<location>Copenhagen, Denmark</location>' +
			    '<description>Expert in software devlopment, photographer, open networker, writer, handyman, old DJ+radiohost, idealist, creative, easily inspired, very independent, spunky</description>' +
			    '<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/70410190/JorgenLarsen2009SqrW0080_normal.jpg</profile_image_url>' +
			    '<url>http://porcupinex.net/</url>' +
			    '<protected>false</protected>' +
			    '<followers_count>1995</followers_count>' +
			  '</sender>' +
			  '<recipient>' +
			    '<id>7688502</id>' +
			    '<name>dcarroll</name>' +
			    '<screen_name>dcarroll</screen_name>' +
			    '<location>Redwood City, California</location>' +
			    '<description></description>' +
			    '<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/77151021/Photo_28_normal.jpg</profile_image_url>' +
			    '<url></url>' +
			    '<protected>false</protected>' +
			    '<followers_count>39</followers_count>' +
			  '</recipient>' +
			'</direct_message>';
	} }

    static String checkCredsResponse { get {
    	return '<?xml version="1.0" encoding="UTF-8"?>' +
				'<user>' +
				  '<id>7688502</id>' +
				  '<name>Dave Carroll</name>' +
				  '<screen_name>dcarroll</screen_name>' +
				  '<location>Redwood City, California</location>' +
				  '<description>Developer Evangelist at salesforce.com, married with 3 wonderful children.</description>' +
				  '<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/103390771/Photo_1_normal.jpg</profile_image_url>' +
				  '<url></url>' +
				  '<protected>false</protected>' +
				  '<followers_count>84</followers_count>' +
				  '<profile_background_color>9AE4E8</profile_background_color>' +
				  '<profile_text_color>333333</profile_text_color>' +
				  '<profile_link_color>0084B4</profile_link_color>' +
				  '<profile_sidebar_fill_color>DDFFCC</profile_sidebar_fill_color>' +
				  '<profile_sidebar_border_color>BDDCAD</profile_sidebar_border_color>' +
				  '<friends_count>76</friends_count>' +
				  '<created_at>Tue Jul 24 16:53:58 +0000 2007</created_at>' +
				  '<favourites_count>0</favourites_count>' +
				  '<utc_offset>-28800</utc_offset>' +
				  '<time_zone>Pacific Time (US &amp; Canada)</time_zone>' +
				  '<profile_background_image_url>http://static.twitter.com/images/themes/theme1/bg.gif</profile_background_image_url>' +
				  '<profile_background_tile>false</profile_background_tile>' +
				  '<statuses_count>64</statuses_count>' +
				  '<notifications>false</notifications>' +
				  '<following>false</following>' +
				  '<status>' +
				    '<created_at>Sun Apr 26 21:28:56 +0000 2009</created_at>' +
				    '<id>1623483698</id>' +
				    '<text>@daddymention PS:The only reason I\'m on line now (from phone) is that I\'m waiting for the soccer game to start!</text>' +
				    '<source>&lt;a href=&quot;http://www.atebits.com/&quot;&gt;Tweetie&lt;/a&gt;</source>' +
				    '<truncated>false</truncated>' +
				    '<in_reply_to_status_id>1622913404</in_reply_to_status_id>' +
				    '<in_reply_to_user_id>17242354</in_reply_to_user_id>' +
				    '<favorited>false</favorited>' +
				    '<in_reply_to_screen_name>daddymention</in_reply_to_screen_name>' +
				  '</status>' +
				'</user>';
    } }
    
    static String rateLimitStatusResponse { get {
    	return '<?xml version="1.0" encoding="UTF-8"?>' +
				'<hash>' +
				  '<reset-time-in-seconds type="integer">1240954511</reset-time-in-seconds>' +
				  '<remaining-hits type="integer">100</remaining-hits>' +
				  '<hourly-limit type="integer">100</hourly-limit>' +
				  '<reset-time type="datetime">2009-04-28T21:35:11+00:00</reset-time>' +
				'</hash>';
    } }

	
    static String getSingleStatus() {
    	return '<?xml version="1.0" encoding="UTF-8"?>\n' +
				'<status>\n' +
  				'<created_at>Sun Nov 02 03:20:06 +0000 2008</created_at>\n' +
  				'<id>985929063</id>\n' +
  				'<text>@superfell not using twitter api yet http://tinyurl.com/5r9kn0 from apex. show us what it can do!</text>\n' +
  				'<source>&lt;a href=&quot;http://github.com/dustin/twitterspy&quot;&gt;TwitterSpy&lt;/a&gt;</source>\n' +
  				'<truncated>false</truncated>\n' +
  				'<in_reply_to_status_id>985892918</in_reply_to_status_id>\n' +
  				'<in_reply_to_user_id>17104583</in_reply_to_user_id>\n' +
  				'<favorited>false</favorited>\n' +
  				'<user>\n' +
    				'<id>8420652</id>\n' +
    				'<name>Scott Hemmeter</name>\n' +
    				'<screen_name>arrowpointe</screen_name>\n' +
    				'<location>Southern Cal, USA</location>\n' +
    				'<description>Services &amp; Applications on the Salesforce.com platform</description>\n' +
    				'<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/21840362/twitter_normal.jpg</profile_image_url>\n' +
    				'<url>http://sfdc.arrowpointe.com</url>\n' +
    				'<protected>false</protected>\n' +
    				'<followers_count>91</followers_count>\n' +
  				'</user>\n' +
				'</status>\n';
    }
    
    static String getStatuses() {
    	return '<?xml version="1.0" encoding="UTF-8"?>\n' +
				'<statuses type="array">\n' +
				'<status>\n' +
  				'<created_at>Sun Nov 02 03:20:06 +0000 2008</created_at>\n' +
  				'<id>985929063</id>\n' +
  				'<text>@superfell not using twitter api yet http://tinyurl.com/5r9kn0 from apex. show us what it can do!</text>\n' +
  				'<source>&lt;a href=&quot;http://github.com/dustin/twitterspy&quot;&gt;TwitterSpy&lt;/a&gt;</source>\n' +
  				'<truncated>false</truncated>\n' +
  				'<in_reply_to_status_id>985892918</in_reply_to_status_id>\n' +
  				'<in_reply_to_user_id>17104583</in_reply_to_user_id>\n' +
  				'<favorited>false</favorited>\n' +
  				'<user>\n' +
    				'<id>8420652</id>\n' +
    				'<name>Scott Hemmeter</name>\n' +
    				'<screen_name>arrowpointe</screen_name>\n' +
    				'<location>Southern Cal, USA</location>\n' +
    				'<description>Services &amp; Applications on the Salesforce.com platform</description>\n' +
    				'<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/21840362/twitter_normal.jpg</profile_image_url>\n' +
    				'<url>http://sfdc.arrowpointe.com</url>\n' +
    				'<protected>false</protected>\n' +
    				'<followers_count>91</followers_count>\n' +
  				'</user>\n' +
				'</status>\n' +
				'<status>\n' +
  				'<created_at>Sun Nov 02 03:09:51 +0000 2008</created_at>\n' +
  				'<id>985920139</id>\n' +
  				'<text>This Edge shave gel commercial is just over the top... stupid.. but funny in a way. http://tinyurl.com/4z8wu9</text>\n' +
  				'<source>&lt;a href=&quot;http://www.tweetdeck.com/&quot;&gt;TweetDeck&lt;/a&gt;</source>\n' +
				'<truncated>false</truncated>\n' +
 				'<in_reply_to_status_id></in_reply_to_status_id>\n' +
  				'<in_reply_to_user_id></in_reply_to_user_id>\n' +
  				'<favorited>false</favorited>\n' +
  				'<user>\n' +
    				'<id>705673</id>\n' +
    				'<name>Michael Wilde</name>\n' +
    				'<screen_name>michaelwilde</screen_name>\n' +
    				'<location>Victorian Oaks Ln &amp; Hidden</location>\n' +
    				'<description>Pre-Sales talent, bleeding edge marketing specialist</description>\n' +
    				'<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/61348859/image_normal.png</profile_image_url>\n' +
    				'<url></url>\n' +
    				'<protected>false</protected>\n' +
    				'<followers_count>250</followers_count>\n' +
  				'</user>\n' +
				'</status>\n' +
				'<status>\n' +
  				'<created_at>Sun Nov 02 03:09:51 +0000 2008</created_at>\n' +
  				'<id>985920139</id>\n' +
  				'<text>This Edge shave gel commercial is just over the top... stupid.. but funny in a way.</text>\n' +
  				'<source>&lt;a href=&quot;http://www.tweetdeck.com/&quot;&gt;TweetDeck&lt;/a&gt;</source>\n' +
				'<truncated>false</truncated>\n' +
 				'<in_reply_to_status_id></in_reply_to_status_id>\n' +
  				'<in_reply_to_user_id></in_reply_to_user_id>\n' +
  				'<favorited>false</favorited>\n' +
  				'<user>\n' +
    				'<id>705673</id>\n' +
    				'<name>Michael Wilde</name>\n' +
    				'<screen_name>michaelwilde</screen_name>\n' +
    				'<location>Victorian Oaks Ln &amp; Hidden</location>\n' +
    				'<description>Pre-Sales talent, bleeding edge marketing specialist</description>\n' +
    				'<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/61348859/image_normal.png</profile_image_url>\n' +
    				'<url></url>\n' +
    				'<protected>false</protected>\n' +
    				'<followers_count>250</followers_count>\n' +
  				'</user>\n' +
				'</status>\n' +
				'</statuses>';
    }
}