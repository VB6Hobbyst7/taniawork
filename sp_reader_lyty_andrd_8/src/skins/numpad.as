package skins
{
import mx.core.DPIClassification;

import assets.numpadback;
import assets.numpadbackBlue;

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
                upBorderSkin = assets.numpadback;
                downBorderSkin = assets.numpadbackBlue;
                
                break;
            }
            case DPIClassification.DPI_240:
            {
				upBorderSkin = assets.numpadback;
				downBorderSkin = assets.numpadbackBlue;
                
                break;
            }
            default:
            {
                // default DPI_160
				upBorderSkin = assets.numpadback;
				downBorderSkin = assets.numpadbackBlue;
                
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