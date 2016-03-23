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
private class TwitterForceTest {

	private class TwitterForceTester extends TwitterForce {
		TwitterForceTester(String u, String p) {
			super(u,p);
		} 

		public override XmlStreamReader getReader(String xml) {
			return super.getReader(xml);
		}
		
		public override List<TwitterStatus> parseStatuses(XmlStreamReader x) {
			return super.parseStatuses(x);
		} 
		
		public override List<TwitterMessage> parseMessages(XmlStreamReader x) {
			return super.parseMessages(x);
		}

		public override RateLimitStatus parseRateLimitStatus(XmlStreamReader x) {
			return super.parseRateLimitStatus(x);
		}
		
		public override TwitterUser parseUser(XmlStreamReader x) {
			return super.parseUser(x);
		}
	
		public override HttpRequest createRequest(String m, String p) {
			return super.createRequest(m,p);
		}
		
		public override HttpRequest createRequest(String m, String p, Map<String, String> parms) {
			return super.createRequest(m, p, parms);
		}
	}

	static testMethod void testAuthHeader() {
		TwitterForceTester tf = new TwitterForceTester('foo','bar');
		HttpRequest r = tf.createRequest('GET', 'foo');
		System.assertEquals('Basic Zm9vOmJhcg==', r.getHeader('Authorization'));
		System.assertEquals('GET', r.getMethod());
		System.assertEquals('http://twitter.com/foo', r.getEndpoint());
		r = tf.createRequest('GET', 'foo', new Map<String, String>{ 'foo'=>'bar' } ) ;
	}

	static testMethod void testUserParser() { 
		TwitterForceTester t = new TwitterForceTester('foo', 'bar');
		TwitterUser user = t.parseUser(t.getReader(getUserCreds()));
		
	}

	static testMethod void testMessageParser() { 
		TwitterForceTester t = new TwitterForceTester('foo', 'bar');
		List<TwitterMessage> messages = t.parseMessages(t.getReader(getMessages()));
		
	}

	static testMethod void testRateLimitStatus() {
		TwitterForceTester t = new TwitterForceTester('foo', 'bar');
		TwitterForce.RateLimitStatus rls = t.parseRateLimitStatus(t.getReader(getRateLimitStatus()));
	}
	
	static testMethod void testStatusesParser() {
		TwitterForceTester t = new TwitterForceTester('foo','bar');
		List<TwitterStatus> statuses = t.parseStatuses(t.getReader(getStatuses()));
		System.assertEquals(2, statuses.size());
		TwitterStatus s = statuses[0];
		System.assertEquals('Sun Nov 02 03:20:06 +0000 2008', s.created_at);
		System.assertEquals('985929063', s.id);
		System.assertEquals('@superfell not using twitter api yet from apex. show us what it can do!', s.text);
		System.assertEquals('<a href="http://github.com/dustin/twitterspy">TwitterSpy</a>', s.source);
		System.assertEquals(false, s.truncated);
		System.assertEquals('985892918', s.in_reply_to_status_id);
		System.assertEquals('17104583', s.in_reply_to_user_id);
		System.assertEquals(false, s.favorited);
		System.assertEquals('8420652', s.user.id);
		System.assertEquals('Scott Hemmeter', s.user.name);
		System.assertEquals('arrowpointe', s.user.screen_name);
		System.assertEquals('Southern Cal, USA', s.user.location);
		System.assertEquals('Services & Applications on the Salesforce.com platform', s.user.description);
		System.assertEquals('http://s3.amazonaws.com/twitter_production/profile_images/21840362/twitter_normal.jpg', s.user.profile_image_url);
		System.assertEquals('http://sfdc.arrowpointe.com', s.user.url);
		System.assertEquals(false, s.user.is_protected);
		System.assertEquals(91, s.user.followers_count);
	}

	static String getStatuses() {
		return '<?xml version="1.0" encoding="UTF-8"?>\n' +
		'<statuses type="array">\n' +
		'<status>\n' +
		'<created_at>Sun Nov 02 03:20:06 +0000 2008</created_at>\n' +
		'<id>985929063</id>\n' +
		'<text>@superfell not using twitter api yet from apex. show us what it can do!</text>\n' +
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
		'</statuses>';
	}
	
	static String getUserCreds() {
		return '<?xml version="1.0" encoding="UTF-8"?>' +
			'<user>' +
			  '<id>7688502</id>' +
			  '<name>dcarroll</name>' +
			  '<screen_name>dcarroll</screen_name>' +
			  '<location>Redwood City, California</location>' +
			  '<description></description>' +
			  '<profile_image_url>http://s3.amazonaws.com/twitter_production/profile_images/77151021/Photo_28_normal.jpg</profile_image_url>' +
			  '<url></url>' +
			  '<protected>false</protected>' +
			  '<followers_count>39</followers_count>' +
			  '<profile_background_color>9AE4E8</profile_background_color>' +
			  '<profile_text_color>333333</profile_text_color>' +
			  '<profile_link_color>0084B4</profile_link_color>' +
			  '<profile_sidebar_fill_color>DDFFCC</profile_sidebar_fill_color>' +
			  '<profile_sidebar_border_color>BDDCAD</profile_sidebar_border_color>' +
			  '<friends_count>47</friends_count>' +
			  '<created_at>Tue Jul 24 16:53:58 +0000 2007</created_at>' +
			  '<favourites_count>0</favourites_count>' +
			  '<utc_offset>-28800</utc_offset>' +
			  '<time_zone>Pacific Time (US &amp; Canada)</time_zone>' +
			  '<profile_background_image_url>http://static.twitter.com/images/themes/theme1/bg.gif</profile_background_image_url>' +
			  '<profile_background_tile>false</profile_background_tile>' +
			  '<following>false</following>' +
			  '<notifications>false</notifications>' +
			  '<statuses_count>32</statuses_count>' +
			  '<status>' +
			    '<created_at>Sun Mar 15 19:18:34 +0000 2009</created_at>' +
			    '<id>1332560300</id>' +
			    '<text>testing twitter source parameter</text>' +
			    '<source>&lt;a href=&quot;http://developer.force.com/codeshare/apex/ProjectPage?id=a06300000030w3aAAA&quot;&gt;TwitterForce&lt;/a&gt;</source>' +
			    '<truncated>false</truncated>' +
			    '<in_reply_to_status_id></in_reply_to_status_id>' +
			    '<in_reply_to_user_id></in_reply_to_user_id>' +
			    '<favorited>false</favorited>' +
			    '<in_reply_to_screen_name></in_reply_to_screen_name>' +
			  '</status>' +
			'</user>';

	}
	
	static String getMessages() {
		return '<?xml version="1.0" encoding="UTF-8"?>' +
			'<direct-messages type="array">' +
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
			'</direct_message>' +
			'<direct_message>' +
			  '<id>72319790</id>' +
			  '<sender_id>5740872</sender_id>' +
			  '<text>bummer. If I do anything like this again, I\'ll give you more notice.</text>' +
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
			    '<followers_count>39</followers_count>' +
			  '</recipient>' +
			'</direct_message>' +
		   '</direct-messages>'
		;
	}
	
	static String getRateLimitStatus() {
		return '<?xml version="1.0" encoding="UTF-8"?>' +
			'<hash>' +
			  '<reset-time type="datetime">2009-03-15T22:37:56+00:00</reset-time>' +
			  '<reset-time-in-seconds type="integer">1237156676</reset-time-in-seconds>' +
			  '<remaining-hits type="integer">99</remaining-hits>' +
			  '<hourly-limit type="integer">100</hourly-limit>' +
			'</hash>';
	}
}