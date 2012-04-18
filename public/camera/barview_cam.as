package
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.core.ButtonAsset;

	
	public class barview_cam extends Sprite
	{
		//var snd:Sound = new camerasound(); //new sound instance for the "capture" button click
		
		private var bandwidth:int; // Maximum amount of bandwidth that the current outgoing video feed can use, in bytes per second.
		private var quality:int; // This value is 0-100 with 1 being the lowest quality.
		
		private var cam:Camera;
		
		private var video:Video;
		
		private var bitmapData:BitmapData;
		private var bitmap:Bitmap;
		
		private var jpgEncoder:JPGEncoder = new JPGEncoder(70);
//		private var byteArray:ByteArray = myEncoder.encode(bitmapData);
		private var byteArray:ByteArray;
		 
		private var contentTypeHeader:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
		private var barIdHeader:URLRequestHeader;		// Resolved when we send the picture.
		private var barNameHeader:URLRequestHeader;
		private var sessionIdHeader:URLRequestHeader;
		
		// Broadcast button and associated text label
		private var capture_mc:Sprite = new Sprite();
		private var textLabel:TextField = new TextField();
		
		private var interval:Number = 0;
		
		// Flags to keep track of whether we're broadcasting, and whether the
		// interval to run captureImage was called.
		private var broadcasting:Boolean = false;
		private var isInitialized:Boolean = false;
		 
		//private var saveJPG:URLRequest = new URLRequest("http://dmaclean.no-ip.org:8080/~dmaclean/pb/save.php");
		private var saveJPG:URLRequest;
		
		private var bar_id:String;
		private var bar_name:String;
		private var session_id:String;
		private var server_url:String;
		
		public function barview_cam()
		{
			bandwidth = 0;
			quality = 100;
			
			capture_mc.buttonMode = true;
			capture_mc.addEventListener(MouseEvent.CLICK,startImageCapture);
			capture_mc.x = 120;
			capture_mc.y = 280;
			
			capture_mc.graphics.clear();
			capture_mc.graphics.beginFill(0xD4D4D4); // grey color
			capture_mc.graphics.drawRoundRect(0, 0, 155, 25, 10, 10); // x, y, width, height, ellipseW, ellipseH
			capture_mc.graphics.endFill();
			textLabel.text = "Broadcast to Barview.com!";
			textLabel.x = 10;
			textLabel.y = 5;
			textLabel.width = 130;
			textLabel.selectable = false;
			capture_mc.addChild(textLabel)
			addChild(capture_mc);
			
			cam = Camera.getCamera();
			cam.setQuality(bandwidth, quality);
			cam.setMode(320,240,30,false); // setMode(videoWidth, videoHeight, video fps, favor area)
			
			video = new Video();
			video.attachCamera(cam);
			video.x = 20;
			video.y = 20;
			addChild(video);
			
			bitmapData = new BitmapData(video.width,video.height);
			bitmap = new Bitmap(bitmapData);
			bitmap.x = 360;
			bitmap.y = 20;
			//addChild(bitmap);
			
			
//			var tf:TextField = new TextField();
//			tf.autoSize = TextFieldAutoSize.LEFT;
//			tf.border = true;
//			addChild(tf);
			
			//tf.appendText("params:" + "\n");
			try {
				var keyStr:String;
				var valueStr:String;
				var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
				for (keyStr in paramObj) {
					valueStr = String(paramObj[keyStr]);
					//tf.appendText("\t" + keyStr + ":\t" + valueStr + "\n");
					
					if(keyStr == "bar_id") {
						bar_id = valueStr;
//						tf.appendText(bar_id + '\n');
					}
					else if(keyStr == "server_url") {
						server_url = valueStr;
//						tf.appendText(server_url+'\n');
					}
					else if(keyStr == "bar_name") {
						bar_name = valueStr;
//						tf.appendText(bar_name+'\n');
					}
					else if(keyStr == "session_id") {
						session_id = valueStr;
//						tf.appendText(session_id+'\n');
					}
				}
			} catch (error:Error) {
//				tf.appendText(error.toString());
			}
		}
		
		public function startImageCapture(event:MouseEvent):void {
			if(!isInitialized) {
				interval = setInterval(captureImage, 5000);
				isInitialized = true;
			}
			
			if(!broadcasting) {
				broadcasting = true;
				textLabel.text = "Stop broadcasting";
			}
			else {
				textLabel.text = "Broadcast to Barview.com!";
				broadcasting = false;
			}
		}
		
		private function captureImage(/*e:MouseEvent*/):void {
			if(broadcasting) {
				//snd.play();
				bitmapData.draw(video);
				//save_mc.buttonMode = true;
				//save_mc.addEventListener(MouseEvent.CLICK, onSaveJPG);
				//save_mc.alpha = 1;
				
				byteArray = jpgEncoder.encode(bitmapData);
				sendJPGToServer(byteArray);
			}
		}
		 
		//save_mc.alpha = .5;
		
		private function sendJPGToServer(pic:ByteArray):void {
			// Resolve bar_id
			barIdHeader 		= new URLRequestHeader("bar_id", bar_id);
			barNameHeader 		= new URLRequestHeader("bar_name", bar_name);
			sessionIdHeader 	= new URLRequestHeader("session_id", session_id); 
			
			
			// Resolve url
			saveJPG = new URLRequest(server_url);
			
			saveJPG.requestHeaders.push(new URLRequestHeader("X-HTTP-Method-Override", "PUT"));
			saveJPG.requestHeaders.push(barIdHeader);
			saveJPG.requestHeaders.push(barNameHeader);
			saveJPG.requestHeaders.push(sessionIdHeader);
			saveJPG.requestHeaders.push(contentTypeHeader);
			saveJPG.method = URLRequestMethod.POST;
			
			saveJPG.data = byteArray;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(saveJPG);
		}
		 
		private function onSaveJPG(e:Event):void{
			
			saveJPG.requestHeaders.push(contentTypeHeader);
			saveJPG.method = URLRequestMethod.POST;
			saveJPG.data = byteArray;
			
			var urlLoader:URLLoader = new URLLoader();
//			urlLoader.addEventListener(Event.COMPLETE, sendComplete);
			urlLoader.load(saveJPG);
			 
//			function sendComplete(event:Event):void{
//				warn.visible = true;
//				addChild(warn);
//				warn.addEventListener(MouseEvent.MOUSE_DOWN, warnDown);
//				warn.buttonMode = true;
//			}
			 
		}
		 
//		function warnDown(e:MouseEvent):void{
//			navigateToURL(new URLRequest("images/"), "_blank");
//			warn.visible = false;
//		}
		 
//		warn.visible = false;
	}
}