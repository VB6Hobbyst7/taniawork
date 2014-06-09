import java.sql.*;
import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
public class updater
{

	public static void main(String [] args){
		updater  tcd = new updater();
		sidemain(tcd);
	}
	public static void sidemain(updater o) {
		o.connect();
	}
	public void connect() {
		
		 Gui gui = new Gui();
		 gui.launchFrame();
		 
		 
	}
	
}