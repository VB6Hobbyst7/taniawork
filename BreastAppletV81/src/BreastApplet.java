import java.applet.Applet;
import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.Font;
import java.awt.Label;
import java.net.URL;

public class BreastApplet
  extends Applet
{
  private static final long serialVersionUID = 1L;
  
  public void init()
  {
    super.init();
    setBackground(Color.white);
    setForeground(Color.black);
    setFont(new Font("Serif", 0, 12));
    add(validHost());
  }
  
  public Component validHost()
  {
    String emailAddress = "bieber@ualberta.ca";//getParameter("email");
    
    return new BreastPanel(this, emailAddress);
    
    /*
    if (emailAddress == null) {
      emailAddress = "unknown";
    }
    if (getCodeBase().getHost().equals("www.adjuvantonline.com")) {
      return new BreastPanel(this, emailAddress);
    }
    if (getCodeBase().getHost().equals("www.adjuvantonline.org")) {
      return new BreastPanel(this, emailAddress);
    }
    return new Label("This applet is not running from adjuvantonline.com. It is running from " + getCodeBase().getHost());*/
  }
}
