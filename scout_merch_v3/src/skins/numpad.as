package skins
{
import mx.core.DPIClassification;

import assets.old.numpadback;
import assets.old.numpadbackBlue;

import spark.skins.mobile.ButtonSkin;

public class numpad extends ButtonSkin
{
    public function numpad()
    {
        super();
        
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                upBorderSkin = assets.old.numpadback;
                downBorderSkin = assets.old.numpadbackBlue;
                
                break;
            }
            case DPIClassification.DPI_240:
            {
				upBorderSkin = assets.old.numpadback;
				downBorderSkin = assets.old.numpadbackBlue;
                
                break;
            }
            default:
            {
                // default DPI_160
				upBorderSkin = assets.old.numpadback;
				downBorderSkin = assets.old.numpadbackBlue;
                
                break;
            }
        }
    }
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // transparent button, do nothing
    }
}
}