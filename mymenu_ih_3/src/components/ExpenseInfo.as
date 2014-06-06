package components
{

import flash.events.MouseEvent;

import mx.core.IDataRenderer;
import mx.events.FlexEvent;

import spark.components.supportClasses.SkinnableComponent;

[SkinState("normal")]
[SkinState("hovered")]
public class ExpenseInfo extends SkinnableComponent implements IDataRenderer
{

    private var m_over:Boolean = false;

    public function ExpenseInfo()
    {
        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
    }

    private function rollOutHandler(event:MouseEvent):void
    {
        m_over = false;
        invalidateSkinState();
    }

    private function rollOverHandler(event:MouseEvent):void
    {
        m_over = true;
        invalidateSkinState();
    }

    private var m_data:Object;

    [Bindable("dataChange")]
    public function get data():Object
    {
        return m_data;
    }

    public function set data(value:Object):void
    {
        m_data = value;
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }

    override protected function getCurrentSkinState():String
    {
        return m_over ? 'hovered' : 'normal';
    }

}
}
