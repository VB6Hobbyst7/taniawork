import views.AccountSettings;

public function gettextweekday(u:uint):String{
	var temps:String = "";
	if (u == 0){
		temps = "sunday";
	}
	else if (u == 1){
		temps = "monday";
	}
	else if (u == 2){
		temps = "tuesday";
	}
	else if (u == 3){
		temps = "wednesday";
	}
	else if (u == 4){
		temps = "thursday";
	}
	else if (u == 5){
		temps = "friday";
	}
	else if (u == 6){
		temps = "saturday";
	}	
	return temps;
}
private function filterCompleted(item:Object):Boolean{
	if((item.weekday.toString().toLowerCase().indexOf(currentfilterweekday) != -1))
		return true;
	return false;
}
public function usermenuclick():void {
	navigator.pushView(AccountSettings);
}