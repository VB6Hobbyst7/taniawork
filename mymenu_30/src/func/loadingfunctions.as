import flash.events.Event;
import flash.net.URLRequest;
import mx.core.UIComponent;
import mx.events.EffectEvent;
import org.bytearray.gif.*;
import org.bytearray.gif.player.GIFPlayer;
import spark.effects.Fade;

	

public function showloading():void {
	/*var uic:UIComponent = new UIComponent();
	var gif:GIFPlayer =new GIFPlayer();
	gif.load(new URLRequest("../assets/Loading.gif"));
	uic.addChild(gif);
	this.addElement(uic);*/
	/*
	loadingswf.source = 'assets/loading.swf';
	loadingswf.verticalCenter = 0;
	loadingswf.horizontalCenter = 0;
	loadingswf.alpha = 0;
	this.addElement(loadingswf);
	loadingIndex = this.getElementIndex(loadingswf);
	var fs:Fade = new Fade();
	fs.alphaFrom = 0;
	fs.alphaTo = 1;
	fs.duration = 500;
	fs.target = loadingswf;
	fs.play();
	var aLoader:Loader = new Loader();
	var url:URLRequest = new URLRequest("assets/loading.swf");
	var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
	aLoader.load(url, loaderContext); // load the SWF file
	aLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSWFLoadComplete, false, 0, true);*/
}
public function hideloading():void {
	/*try{
		var fs:Fade = new Fade();
		fs.alphaFrom = 1;
		fs.alphaTo = 0;
		fs.duration = 1000;
		fs.target = loadingswf;
		fs.play();
		fs.addEventListener(EffectEvent.EFFECT_END, afterFade);	
	}
	catch(e:Error){
	this.removeElement(ui);
	}*/

	
}
public function afterFade(ev:EffectEvent):void {
	/*try{
		if (loadingIndex >= 0){
			this.removeElementAt(loadingIndex);
			loadingIndex = -1;
		}	
	}
	catch(e:Error){
		
	}*/
	
	
}