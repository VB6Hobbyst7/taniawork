import mx.collections.ArrayCollection;
[Bindable]
public var listData:ArrayCollection = new ArrayCollection();
[Bindable]
public var resData:ArrayCollection = new ArrayCollection();
[Bindable]
public var modData:ArrayCollection = new ArrayCollection();
public function syncmenurestrictions():void {
	createIfNotExsist("resvalues");
	var i:uint = 0;
	var resvaluesData:ArrayCollection = getDatabaseArray("SELECT * FROM resvalues");
	if (resvaluesData.length > 0){
		for (var j:uint = 0; j < listData.length; j++){
			var goodstatus:Number = 0;
			var permabad:Boolean = false;
			for (var k:uint = 0; k < resData.length; k++){
				if (resData[k].menuid == listData[j].id){
					for (i = 0; i<resvaluesData.length; i++){
						if ((resvaluesData[i].id == resData[k].restrictid)
							&&(resvaluesData[i].chosen == 'yes')){
							goodstatus = 1;
							for (var l:uint = 0; l < modData.length; l++){
								if ((resvaluesData[i].id == modData[l].restrictid)
									&&(modData[l].menuid == resData[k].menuid)){
									//show it but add warning
									goodstatus = 2;
								}
							}
							
							if (goodstatus == 1){
								permabad = true;
							}
						}
					}
				}
			}
			
			if (permabad){
				//no mod for an item so its bad
				listData.removeItemAt(j);
				j = j-1;
				//listData[j].hideall = true;
				//listData[j].goodforme = false;
			}
			else if (goodstatus == 2){
				// a mod exsists to a restriction so just add warning
				listData[j].hideall = false;
				listData[j].goodforme = false;
			}
			else {
				//all good show away. 
				listData[j].hideall = false;
				listData[j].goodforme = true;
			}
		}
	}
	else {
		for (i = 0; i < listData.length; i++){
			listData[i].hideall = false;
		}
	}
	
	
} 