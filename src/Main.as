package {
    
    //
    // Howto generate keyhash from p12
    // keytool -export -alias 1 -storetype pkcs12 -keystore <your certificate>.p12 | openssl sha1 -binary | openssl enc -a -e
    //
    
    
    import com.freshplanet.ane.AirFacebook.Facebook;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.StatusEvent;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	
	public class Main extends Sprite {
        
        [Embed(source = "facebook.png")] 
        private static const FACEBOOK_PNG:Class;
        
        //
        
        private static const APP_ID:String = "<FACEBOOK APP ID>";
        private static const PERMISSIONS:Array = [ "<LIST OF PERMISSIONS>" ];

        //
        
        private var facebook :Facebook;
        private var fb_button:Sprite;
        
		public function Main():void {
            
            var img_facebook:Bitmap = new FACEBOOK_PNG();
            img_facebook.x = -img_facebook.width  / 2;
            img_facebook.y = -img_facebook.height / 2;
            
            fb_button = new Sprite();
            fb_button.addChild(img_facebook);

            addEventListener(Event.ADDED_TO_STAGE, on_added_to_stage, false, 0, true);
		}
        
        private function on_added_to_stage(e:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, on_added_to_stage);
            
            trace("Facebook supported: " + Facebook.isSupported);
            if (!Facebook.isSupported) {
                return;
            }
            
            facebook = Facebook.getInstance();
            facebook.addEventListener(StatusEvent.STATUS, on_fb_status, false, 0, true);
            facebook.init(APP_ID);
            
            trace("Facebook Session is open: " + facebook.isSessionOpen);
            if (!facebook.isSessionOpen) {
                //
                // Show Connect Button
                //
                fb_button.x = stage.stageWidth  / 2;
                fb_button.y = stage.stageHeight / 2;
                fb_button.addEventListener(MouseEvent.CLICK, on_fb_button_click, false, 0, true);
                addChild(fb_button);
                
            } else {
                //
                // Show /me information
                //  
                facebook.requestWithGraphPath("/me", null, URLRequestMethod.GET, on_fb_request_me);
                
            }
        }
        
        private function on_fb_request_me(response:Object):void {
            trace(JSON.stringify(response));
            
            var user_info:Sprite    = new Sprite();
            var user_pic :Loader    = new Loader();
            var user_name:TextField = new TextField();
            var user_id  :String    = response.id;
            
            user_pic.load(new URLRequest("https://graph.facebook.com/" + response.id + "/picture"));
            user_pic.x = -25;
            user_pic.y = -50;
            
            user_name.defaultTextFormat = new TextFormat("_sans", 12, 0x000000);
            user_name.autoSize = TextFieldAutoSize.LEFT;
            user_name.text = response.name;
            user_name.x = -(user_name.width / 2);
            user_name.y = 0;
            
            user_info.addChild(user_pic);
            user_info.addChild(user_name);
            
            user_info.x = stage.stageWidth  / 2;
            user_info.y = stage.stageHeight / 2;
            user_info.scaleX = 2.0;
            user_info.scaleY = 2.0;
            addChild(user_info);
            
        }
        
        private function on_fb_button_click(e:MouseEvent):void {
            facebook.openSessionWithReadPermissions(PERMISSIONS, 
                function (success:Boolean, canceled:Boolean, error:String):void {
                    trace("Success : " + success);
                    trace("Canceled: " + canceled);
                    trace("Error   : " + error);
                    
                    if (success) {
                        removeChild(fb_button);
                        facebook.requestWithGraphPath("/me", null, URLRequestMethod.GET, on_fb_request_me);
                    }
                });
        }
        
        private function on_fb_status(e:StatusEvent):void {
            trace(e);
        }
	}
	
}