package model
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class InfiniteListModel extends ArrayCollection
	{
		private var _remoteObject : RemoteObject;
		
		protected var _loading : Boolean = false;
		
		public function get remoteObject():RemoteObject
		{
			return _remoteObject;
		}

		public function set remoteObject(value:RemoteObject):void
		{
			_remoteObject = value;
			if ( _remoteObject )
				getNextPage();
		}
		
		public function InfiniteListModel(source:Array=null)
		{
			super(source);
			addItem( new LoadingVO() );
		}
		
		public function getNextPage() : void
		{
			if ( !_loading)
			{
				_loading = true;
				
				trace( "fetching data starting at " + (this.length-1).toString() );
				var token : AsyncToken = remoteObject.getData( this.length-1 );
				var responder : Responder = new Responder( resultHandler, faultHandler );
				token.addResponder( responder );
			}
		}
		
		protected function resultHandler(event:ResultEvent):void
		{
			this.disableAutoUpdate();
			
			if ( this.getItemAt( this.length-1 ) is LoadingVO )
				this.removeItemAt( this.length-1 );
			
			for each ( var item : * in event.result )
			{
				addItem( item );
			}
			addItem( new LoadingVO() );
			this.enableAutoUpdate();
			
			_loading = false;
		}
		
		protected function faultHandler(event:FaultEvent):void
		{
			trace( event.fault.toString() );
		}
	}
}