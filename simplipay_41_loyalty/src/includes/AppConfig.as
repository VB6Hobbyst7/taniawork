import com.mapquest.DistanceUnits;
import com.mapquest.services.directions.DirectionsConstants;


[Bindable]
public var key:String = "Jmjtd%7Clu6yn907nu%2C8w%3Do5-lw8x9";

public var distanceUnit:DistanceUnits = DistanceUnits.MILES;



public var mapStartZoomLevel:int = 3;

public var mapStartType:String = "map";

public var mapFriction:Number = 1.31;

public var mapUseZoomControl:Boolean = true;

public var mapUseTrafficControl:Boolean = true;




public var searchDataBase:String = "mqap.ntpois";

public var searchMaxMatches:int = 10;

public var searchRadius:int = 3;

public var searchOverlayAlpha:Number = 0.20;

public var searchOverlayColor:String = "yellow";

public var searchShowOrigin:Boolean = false;

public var searchShowOverlay:Boolean = true;

public var searchLocationShowPhoneButton:Boolean = true;

public var searchLocationShowEmailButton:Boolean = true;



public var directionsType:String = DirectionsConstants.TYPE_FASTEST;

public var directionsLanguage:String = "English";

public var directionsRibbonColor:String = "blue";

public var directionsPoiText:String = DirectionsConstants.STOP_TEXT_LETTERS;

