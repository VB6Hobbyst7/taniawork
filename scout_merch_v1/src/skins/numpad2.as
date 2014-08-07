package skins
{
import mx.core.DPIClassification;

import assets.numpadback2;
import assets.numpadbackBlue2;

import spark.skins.mobile.ButtonSkin;

public class numpad2 extends ButtonSkin
{
    public function numpad2()
    {
        super();
        
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                upBorderSkin = assets.numpadback2;
                downBorderSkin = assets.numpadbackBlue2;
                
                break;
            }
            case DPIClassification.DPI_240:
            {
				upBorderSkin = assets.numpadback2;
				downBorderSkin = assets.numpadbackBlue2;
                
                break;
            }
            default:
            {
                // default DPI_160
				upBorderSkin = assets.numpadback2;
				downBorderSkin = assets.numpadbackBlue2;
                
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