import spark.effects.Move;
import spark.effects.Resize;
import spark.effects.Scale;

// ActionScript file
public var tabbarvisible:Boolean = false;

public function setTab(u:uint):void {
	if (u == 1){
		tabimg1.source = tab11;
		tabimg2.source = tab2;
		tabimg3.source = tab3;
		tabimg4.source = tab4;
		tabimg5.source = tab5;
		showTabBar();
	}
	else if (u == 2){
		tabimg1.source = tab1;
		tabimg2.source = tab21;
		tabimg3.source = tab3;
		tabimg4.source = tab4;
		tabimg5.source = tab5;
		showTabBar();
	}
	else if (u == 3){
		tabimg1.source = tab1;
		tabimg2.source = tab2;
		tabimg3.source = tab31;
		tabimg4.source = tab4;
		tabimg5.source = tab5;
		showTabBar();
	}
	else if (u == 4){
		tabimg1.source = tab1;
		tabimg2.source = tab2;
		tabimg3.source = tab3;
		tabimg4.source = tab41;
		tabimg5.source = tab5;
		showTabBar();
	}
	else if (u == 5){
		tabimg1.source = tab1;
		tabimg2.source = tab2;
		tabimg3.source = tab3;
		tabimg4.source = tab4;
		tabimg5.source = tab51;
		showTabBar();
	}
	else if (u == 0){
		tabimg1.source = tab1;
		tabimg2.source = tab2;
		tabimg3.source = tab3;
		tabimg4.source = tab4;
		tabimg5.source = tab5;
		showTabBar();
	}
	else if (u == 99){
		hideTabBar();
	}
}
public function showTabBar():void {
	if (tabbarvisible == false){
		tabbar.height = 100/(320/Capabilities.screenDPI);
		tabbarvisible = true;
	}
}
public function hideTabBar():void {
	if (tabbarvisible){
		tabbar.height = -1;
		tabbarvisible = false;
	}
	
}
public function clicktab(u:uint):void {
	setTab(u);
	if (u == 1){
		mainNavigator.pushView(Home);
	}
	else if (u == 2){
		mainNavigator.pushView(MenuAll);
	}
	else if (u == 3){
		mainNavigator.pushView(SpecialsAll);
	}
	else if (u == 4){
		mainNavigator.pushView(Restrictions);
	}
	else if (u == 5){
		mainNavigator.pushView(Profile);
	}
}