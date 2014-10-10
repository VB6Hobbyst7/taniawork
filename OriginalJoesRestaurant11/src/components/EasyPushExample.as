package components
{
import com.milkmangames.nativeextensions.*;
import com.milkmangames.nativeextensions.events.*;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;

import mx.rpc.http.HTTPService;

/** EasyPush Example App */
public class EasyPushExample extends Sprite
{
	//
	// Definitions
	//
	
	/** Your Airship Application Key */
	public static const AIRSHIP_KEY:String="bH3oFML6Q7GynXJghbMS9w";
	
	/** Your Airship App Secret */
	public static const AIRSHIP_SECRET:String="JshH1DzfRKuuBKarH043Pw";
	
	/** Your GCM Project Number */
	public static const GCM_PROJECT_NUMBER:String="org.enactforum.originaljoes";
	
	/** If true, uses urbanairship in this example.  if false, you must set up your own remote server */
	public static const USE_URBAN_AIRSHIP:Boolean=true;

	//
	// Instance Variables
	//
	
	/** Status */
	private var txtStatus:TextField;
	
	/** Buttons */
	private var buttonContainer:Sprite;
	
	public var storeid:String;
	
	//
	// Public Methods
	//
	
	/** Create New EasyPushExample */
	public function EasyPushExample(storeidtemp:String) 
	{		
		storeid = storeidtemp;
		createUI();
		
		if (!EasyPush.isSupported())
		{
			log("EasyPush is not supported on this platform (not android or ios!)");
			return;
		}
		if (!EasyPush.areNotificationsAvailable())
		{
			log("Notifications are disabled!");
			return;
		}
		
		if (!validateConstants()) return;
		
		if (USE_URBAN_AIRSHIP)
		{
			setupUrbanAirship();
		}
		else
		{
			setupManual();
		}

		
		showMenu();
		log("Ready!");
	}
	
	/** Setup for Urbanairship */
	public function setupUrbanAirship():void
	{
		log("init airship...");
		EasyPush.initAirship(AIRSHIP_KEY,AIRSHIP_SECRET,GCM_PROJECT_NUMBER,true,true,true);		
		log("did init airship.");
		EasyPush.airship.addEventListener(PNAEvent.ALERT_DISMISSED,onAlertDismissed);
		EasyPush.airship.addEventListener(PNAEvent.FOREGROUND_NOTIFICATION,onNotification);
		EasyPush.airship.addEventListener(PNAEvent.RESUMED_FROM_NOTIFICATION,onNotification);
		EasyPush.airship.addEventListener(PNAEvent.TOKEN_REGISTERED,onTokenRegistered);
		EasyPush.airship.addEventListener(PNAEvent.TOKEN_REGISTRATION_FAILED,onRegFailed);
		EasyPush.airship.addEventListener(PNAEvent.TYPES_DISABLED, onTokenTypesDisabled);		
	}
	
	/** Setp for Manual Mode.  This requires running your own backend push server. */
	public function setupManual():void
	{
		// manual mode
		log("init Manual...");
		EasyPush.initManual(GCM_PROJECT_NUMBER, true);
		log("did init manual.");
		EasyPush.manual.addEventListener(PNMEvent.ALERT_DISMISSED,onAlertDismissed);
		EasyPush.manual.addEventListener(PNMEvent.FOREGROUND_NOTIFICATION,onNotification);
		EasyPush.manual.addEventListener(PNMEvent.RESUMED_FROM_NOTIFICATION,onNotification);
		EasyPush.manual.addEventListener(PNMEvent.TOKEN_REGISTERED,onTokenRegistered);
		EasyPush.manual.addEventListener(PNMEvent.TOKEN_REGISTRATION_FAILED,onRegFailed);		
	}
	
	/** Set 'quiet time' when notifications don't show */
	public function setQuietTime():void
	{
		log("Setting quiet time for next 15 minutes...");
		var now:Date=new Date();
		var inFifteen:Date=new Date();
		inFifteen.setTime(now.millisecondsUTC+(15*60*1000));
		EasyPush.airship.setQuietTime(now,inFifteen);
		log("Did set quiet time.");
	}
	
	/** Set tags for identifying groups of users */
	public function setTags():void
	{
		log("Setting custom tags 'gamer' and 'advanced'...");
		var tags:Vector.<String>=new Vector.<String>();
		tags.push("gamer");
		tags.push("advanced");
		EasyPush.airship.setAirshipTags(tags);
		log("Set custom tags to "+tags.join(","));
	}
	
	/** Set a new (unique!) alias to identify one user */
	public function setNewAlias():void
	{
		log("Setting new alias...");
		var newAlias:String="MilkmanGamer";
		EasyPush.airship.updateAlias(newAlias);
		log("Set the alias to '"+newAlias+"'.");
	}
	//
	// Events
	//	
	
	private function onTokenRegistered(e:PNEvent):void
	{
		log("token registered:"+e.token);
		
		var ht:HTTPService = new HTTPService();
		ht.url = 'http://www.enactforum.org/originaljoes/manager/updateStoreSync.php';
		ht.method = "GET";
		ht.resultFormat = 'array';
		var ob:Object = {storeid:storeid,token:e.token};
		ht.request = ob;	
		ht.send();
	}
	
	private function onTokenTypesDisabled(e:PNAEvent):void
	{
		log("disabled token types:"+e.disabledTypes);
	}
	
	private function onRegFailed(e:PNEvent):void
	{
		log("reg failed: "+e.errorId+"="+e.errorMsg);
	}
	
	private function onAlertDismissed(e:PNEvent):void
	{
		log("dismissed alert "+e.alert);
	}
	
	private function onNotification(e:PNEvent):void
	{
		log(e.type+"="+e.rawPayload+","+e.badgeValue+","+e.title);
	}

	//
	// Impelementation
	//
	
	/** Create UI */
	public function createUI():void
	{
		txtStatus=new TextField();
		txtStatus.defaultTextFormat=new flash.text.TextFormat("Arial",25);
		txtStatus.width=200;
		txtStatus.height=200;
		txtStatus.multiline=true;
		txtStatus.wordWrap=true;
		txtStatus.text="Ready";
		addChild(txtStatus);
		

	}
	
	/** Show Menu */
	private function showMenu():void
	{
		if (!USE_URBAN_AIRSHIP)
		{
			return;
		}
		
		if (buttonContainer)
		{
			removeChild(buttonContainer);
			buttonContainer=null;
		}
		
		buttonContainer=new Sprite();
		buttonContainer.y=txtStatus.height;
		addChild(buttonContainer);
		
		var uiRect:Rectangle=new Rectangle(0,0,200,200);
		var layout:ButtonLayout=new ButtonLayout(uiRect,14);
		layout.addButton(new SimpleButton(new Command("Set Quiet Time",setQuietTime)));
		layout.addButton(new SimpleButton(new Command("Set Some Tags",setTags)));
		layout.addButton(new SimpleButton(new Command("Set Alias",setNewAlias)));

		layout.attach(buttonContainer);
		layout.layout();			
	}
	
	/** Log */
	private function log(msg:String):void
	{
		trace("[EPExample] "+msg);
		txtStatus.text=msg;
	}
	
	
	/** Validate Constants */
	private function validateConstants():Boolean
	{
		if (USE_URBAN_AIRSHIP && AIRSHIP_KEY=="put your key here")
		{
			log("You did not put your key in EasyPushExample.as.");
			return false;
		}
		if (USE_URBAN_AIRSHIP && AIRSHIP_SECRET=="put your secret here")
		{
			log("You did not put your secret in EasyPushExample.as.");
			return false;
		}
		if (GCM_PROJECT_NUMBER=="put your id here")
		{
			log("WARNING: won't work on android until id set in EasyPushExample.as.");
			return true;
		}
		
		return true;
	}
	
}
}


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/** Simple Button */
class SimpleButton extends Sprite
{
	//
	// Instance Variables
	//
	
	/** Command */
	private var cmd:Command;
	
	/** Width */
	private var _width:Number;
	
	/** Label */
	private var txtLabel:TextField;
	
	//
	// Public Methods
	//
	
	/** Create New SimpleButton */
	public function SimpleButton(cmd:Command)
	{
		super();
		this.cmd=cmd;
		
		mouseChildren=false;
		mouseEnabled=buttonMode=useHandCursor=true;
		
		txtLabel=new TextField();
		txtLabel.defaultTextFormat=new TextFormat("Arial",32,0xFFFFFF);
		txtLabel.mouseEnabled=txtLabel.mouseEnabled=txtLabel.selectable=false;
		txtLabel.text=cmd.getLabel();
		txtLabel.autoSize=TextFieldAutoSize.LEFT;
		
		redraw();
		
		addEventListener(MouseEvent.CLICK,onSelect);
	}
	
	/** Set Width */
	override public function set width(val:Number):void
	{
		this._width=val;
		redraw();
	}

	
	/** Dispose */
	public function dispose():void
	{
		removeEventListener(MouseEvent.CLICK,onSelect);
	}
	
	//
	// Events
	//
	
	/** On Press */
	private function onSelect(e:MouseEvent):void
	{
		this.cmd.execute();
	}
	
	//
	// Implementation
	//
	
	/** Redraw */
	private function redraw():void
	{		
		txtLabel.text=cmd.getLabel();
		_width=_width||txtLabel.width*1.1;
		
		graphics.clear();
		graphics.beginFill(0x444444);
		graphics.lineStyle(2,0);
		graphics.drawRoundRect(0,0,_width,txtLabel.height*1.1,txtLabel.height*.4);
		graphics.endFill();
		
		txtLabel.x=_width/2-(txtLabel.width/2);
		txtLabel.y=txtLabel.height*.05;
		addChild(txtLabel);
	}
}

/** Button Layout */
class ButtonLayout
{
	private var buttons:Array;
	private var rect:Rectangle;
	private var padding:Number;
	private var parent:DisplayObjectContainer;
	
	public function ButtonLayout(rect:Rectangle,padding:Number)
	{
		this.rect=rect;
		this.padding=padding;
		this.buttons=new Array();
	}
	
	public function addButton(btn:SimpleButton):uint
	{
		return buttons.push(btn);
	}
	
	public function attach(parent:DisplayObjectContainer):void
	{
		this.parent=parent;
		for each(var btn:SimpleButton in this.buttons)
		{
			parent.addChild(btn);
		}
	}
	
	public function layout():void
	{
		var btnX:Number=rect.x+padding;
		var btnY:Number=rect.y;
		for each( var btn:SimpleButton in this.buttons)
		{
			btn.width=rect.width-(padding*2);
			btnY+=this.padding;
			btn.x=btnX;
			btn.y=btnY;
			btnY+=btn.height;
		}
	}
}

/** Inline Command */
class Command
{
	/** Callback Method */
	private var fnCallback:Function;
	
	/** Label */
	private var label:String;
	
	//
	// Public Methods
	//
	
	/** Create New Command */
	public function Command(label:String,fnCallback:Function)
	{
		this.fnCallback=fnCallback;
		this.label=label;
	}
	
	//
	// Command Implementation
	//
	
	/** Get Label */
	public function getLabel():String
	{
		return label;
	}
	
	/** Execute */
	public function execute():void
	{
		fnCallback();
	}
}