import spark.effects.Move;
import spark.effects.Resize;
import spark.effects.Scale;

// ActionScript file
public var tabbarvisible:Boolean = false;

public function setTab(u:uint):void {
	if (u == 1){
		tabback1.color = 0x333333;
		tabback2.color = 0x4d4d4d;
		tabback3.color = 0x4d4d4d;
		tabback4.color = 0x4d4d4d;
		tabback5.color = 0x4d4d4d;
		
		tabimg1.source = tab11;
		tabimg2.source = tab2;
		tabimg3.source = tab3;
		tabimg4.source = tab4;
		tabimg5.source = tab5;
		showTabBar();
	}
	else if (u == 2){
		tabback1.color = 0x4d4d4d;
		tabback2.color = 0x333333;
		tabback3.color = 0x4d4d4d;
		tabback4.color = 0x4d4d4d;
		tabback5.color = 0x4d4d4d;
		tabimg1.source = tab1;
		tabimg2.source = tab21;
		tabimg3.source = tab3;
		tabimg4.source = tab4;
		tabimg5.source = tab5;
		showTabBar();
	}
	else if (u == 3){
		tabback1.color = 0x4d4d4d;
		tabback2.color = 0x4d4d4d;
		tabback3.color = 0x333333;
		tabback4.color = 0x4d4d4d;
		tabback5.color = 0x4d4d4d;
		tabimg1.source = tab1;
		tabimg2.source = tab2;
		tabimg3.source = tab31;
		tabimg4.source = tab4;
		tabimg5.source = tab5;
		showTabBar();
	}
	else if (u == 4){
		tabback1.color = 0x4d4d4d;
		tabback2.color = 0x4d4d4d;
		tabback3.color = 0x4d4d4d;
		tabback4.color = 0x333333;
		tabback5.color = 0x4d4d4d;
		tabimg1.source = tab1;
		tabimg2.source = tab2;
		tabimg3.source = tab3;
		tabimg4.source = tab41;
		tabimg5.source = tab5;
		showTabBar();
	}
	else if (u == 5){
		tabback1.color = 0x4d4d4d;
		tabback2.color = 0x4d4d4d;
		tabback3.color = 0x4d4d4d;
		tabback4.color = 0x4d4d4d;
		tabback5.color = 0x333333;
		tabimg1.source = tab1;
		tabimg2.source = tab2;
		tabimg3.source = tab3;
		tabimg4.source = tab4;
		tabimg5.source = tab51;
		showTabBar();
	}
	else if (u == 0){
		tabback1.color = 0x333333;
		tabback2.color = 0x333333;
		tabback3.color = 0x333333;
		tabback4.color = 0x333333;
		tabback5.color = 0x333333;
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