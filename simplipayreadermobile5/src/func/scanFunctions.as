import com.rancondev.extensions.qrzbar.QRZBar;
import com.rancondev.extensions.qrzbar.QRZBarEvent;
import flash.events.*;
import mx.rpc.events.ResultEvent;
import org.osmf.events.TimeEvent;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
private var qr:QRZBar;
public var qrCode_found:String;
[Bindable]
public var code:String = "";
[Bindable]
public var busy:Boolean = true;
public function startScanner():void {
	busy = false;
	qr = new QRZBar();
	qr.scan();
	qr.addEventListener( QRZBarEvent.SCANNED, scannedHandler );
}
protected function scannedHandler( event : QRZBarEvent ) : void
{
	qr.removeEventListener( QRZBarEvent.SCANNED, scannedHandler );
	var qrtext:String  = event.result;
	qrCode_found = qrtext;
	var scannedText2:String = qrtext;
	try{
		code = scannedText2.substring(0,scannedText2.toLowerCase().indexOf('formalendofstatement')).toLowerCase();
	}
	catch(e:Error){
		code = "ERROR";
	}
	
	payGo.send();
	busy = true;
}
public function afterProcess(ev:ResultEvent):void {	
	scanBTN.visible = false;
	totalValue.text = "$0.00";
	var message:String = ev.result[0].res.message;
	warn.text = message;
	busy = false;
}
public function gOver(ev:MouseEvent):void {
	var gl:GlowFilter = new GlowFilter(000000,0.6,30,30,30,1,true);
	ev.currentTarget.filters = [gl];
}
public function gDown(ev:MouseEvent):void {
	var gl:GlowFilter = new GlowFilter(000000,0.6,30,30,30,1,true);
	ev.currentTarget.filters = [gl];
}
public function gOut(ev:MouseEvent):void {
	ev.currentTarget.filters = [];
}