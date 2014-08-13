import mx.collections.ArrayCollection;
import mx.messaging.AbstractConsumer;
import mx.rpc.events.ResultEvent;

public function afterMain(ev:ResultEvent):void {
	mainArray = new ArrayCollection();
	if (ev.result.books != null){
		try{
		mainArray = ev.result.books.book;
		}
		catch(Exception:Error){
			mainArray.addItem({id:ev.result.books.book.id.toString(),name:ev.result.books.book.name});
		}
	}
	else {
		showWarn("No Books Loaded, Contact Admin");
	}
}
public function afterCuratorGet(ev:ResultEvent):void {
	curatorAcceptArray = new ArrayCollection();
	var j:uint = 0;
	userTagArray = new ArrayCollection();
	if (ev.result.tags != null){
		try{
			var tempArray:ArrayCollection = new ArrayCollection();
			tempArray = ev.result.tags.tag;
			//more than one
			for (var i:uint = 0; i < tempArray.length; i++){
				for (j = 0; j < curatorTagArray.length; j++){
					if (curatorTagArray[j].name == tempArray[i].xmlname){
						curatorAcceptArray.addItem({name:curatorTagArray.getItemAt(j).name,
							newname:tempArray[i].curatorname,
							num:curatorTagArray.getItemAt(j).num,
							index:curatorTagArray.getItemAt(j).index,
							type:curatorTagArray.getItemAt(j).type,
							show:curatorTagArray.getItemAt(j).show});
						curatorTagArray[j].show = true;
						curatorTagBox.dataProvider.itemUpdated(curatorTagArray[j]);
					}
				}
					userTagArray.addItem({id:tempArray[i].id,
						xmlid:tempArray[i].xmlid,
						xmlname:tempArray[i].xmlname,
						curatorname:tempArray[i].curatorname,
						visible:tempArray[i].visible,
						tcount:tempArray[i].tcount,
						show:false});
				
			}
		}
		catch(Exception:Error){
			//just one
			for (j = 0; j < curatorTagArray.length; j++){
				if (curatorTagArray[j].name == ev.result.tags.tag.xmlname){
					curatorAcceptArray.addItem({name:curatorTagArray.getItemAt(j).name,
						newname:ev.result.tags.tag.curatorname,
						num:curatorTagArray.getItemAt(j).num,
						index:curatorTagArray.getItemAt(j).index,
						type:curatorTagArray.getItemAt(j).type,
						show:curatorTagArray.getItemAt(j).show});
					curatorTagArray[j].show = true;
					curatorTagBox.dataProvider.itemUpdated(curatorTagArray[j]);
				}
			}
				userTagArray.addItem({id:ev.result.tags.tag.id,
					xmlid:ev.result.tags.tag.xmlid,
					xmlname:ev.result.tags.tag.xmlname,
					curatorname:ev.result.tags.tag.curatorname,
					visible:ev.result.tags.tag.visible,
					tcount:ev.result.tags.tag.tcount,
					show:false});
			
		}
		
	}
	else {
		showWarn("No Tags Defined, Please Ask Curator to Choose Tags to Display.");
	}
	try{
		checkUserTags();
	}
	catch(Exception:Error){
		
	}
}
public function afterFileParse(ev:ResultEvent):void {
	parseDocument(ev.result);
	
}