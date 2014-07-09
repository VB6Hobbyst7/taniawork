import java.awt.Button;
import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.Dialog;
import java.awt.Frame;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.Label;
import java.awt.Panel;
import java.awt.TextComponent;
import java.awt.TextField;
import java.awt.Window;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.util.EventObject;

public class PrognosticDialog
  extends Dialog
  implements ActionListener, WindowListener
{
  private static final long serialVersionUID = 1L;
  private Button calcButton = new Button("Calculate");
  private Button highButton = new Button("Use High");
  private Button lowButton = new Button("Use Low");
  private Button cancelButton = new Button("Cancel");
  private TextField relRiskField = new TextField(4);
  private PositiveIntField highPercentField = new PositiveIntField();
  private PositiveIntField absRiskField = new PositiveIntField();
  private Label highLabel = new Label();
  private Label lowLabel = new Label();
  private Frame parentFrame = null;
  private int risk;
  private int highrisk;
  private int lowrisk;
  
  public PrognosticDialog(Frame aFrame, int initialRisk, String riskString)
  {
    super(aFrame, "Prognostic Factor Impact Calculator", true);
    this.parentFrame = aFrame;
    this.risk = initialRisk;
    this.highrisk = initialRisk;
    this.lowrisk = initialRisk;
    setForeground(Color.black);
    GridBagLayout gridBagLayout1 = new GridBagLayout();
    Panel contentPane = new Panel();
    contentPane.setLayout(gridBagLayout1);
    Label jLabel1 = new Label("Relative Risk; High vs. Low Risk Group:");
    Label jLabel2 = new Label("Percent of Patients in High Risk Group:");
    Label jLabel3 = new Label();
    if (riskString != null) {
      jLabel3.setText(riskString);
    }
    Label jLabel4 = new Label("Results for High Risk Group:");
    Label jLabel5 = new Label("Results for Low Risk Group:");
    Label jLabel6 = new Label(" ");
    this.relRiskField.setText("2.0");
    this.highPercentField.setValue(50);
    this.absRiskField.setValue(this.risk);
    this.highLabel.setText(String.valueOf(this.highrisk));
    this.lowLabel.setText(String.valueOf(this.lowrisk));
    
    GridBagConstraints gbc = new GridBagConstraints();
    gbc.gridx = 0;
    gbc.gridy = 0;
    gbc.anchor = 17;
    gbc.fill = 0;
    gbc.gridwidth = 2;
    gbc.gridheight = 1;
    gbc.insets = new Insets(2, 2, 2, 2);
    
    contentPane.add(jLabel1, gbc);
    gbc.gridy += 1;
    contentPane.add(jLabel2, gbc);
    gbc.gridy += 1;
    contentPane.add(jLabel3, gbc);
    gbc.gridy += 1;
    gbc.gridx += 2;
    gbc.gridy = 0;
    gbc.gridwidth = 1;
    contentPane.add(this.relRiskField, gbc);
    gbc.gridy += 1;
    contentPane.add(this.highPercentField, gbc);
    gbc.gridy += 1;
    contentPane.add(this.absRiskField, gbc);
    gbc.gridy += 1;
    gbc.fill = 2;
    contentPane.add(this.calcButton, gbc);
    gbc.gridy += 1;
    contentPane.add(jLabel6, gbc);
    gbc.gridy += 1;
    contentPane.add(this.highButton, gbc);
    gbc.gridy += 1;
    contentPane.add(this.lowButton, gbc);
    gbc.gridy += 1;
    contentPane.add(this.cancelButton, gbc);
    gbc.fill = 0;
    gbc.gridx = 0;
    gbc.gridy = 5;
    contentPane.add(jLabel4, gbc);
    gbc.gridy += 1;
    contentPane.add(jLabel5, gbc);
    gbc.gridx += 1;
    gbc.gridy -= 1;
    contentPane.add(this.highLabel, gbc);
    gbc.gridy += 1;
    contentPane.add(this.lowLabel, gbc);
    this.calcButton.addActionListener(this);
    this.highButton.addActionListener(this);
    this.lowButton.addActionListener(this);
    this.cancelButton.addActionListener(this);
    gbc.insets = new Insets(2, 2, 2, 2);
    setLayout(new GridBagLayout());
    add(contentPane, gbc);
    addWindowListener(this);
    pack();
    setResizable(false);
    setVisible(true);
  }
  
  public static int execute(Frame aFrame, int initialRisk, String riskString)
  {
    PrognosticDialog myDialog = new PrognosticDialog(aFrame, initialRisk, riskString);
    return myDialog.getResult();
  }
  
  public void actionPerformed(ActionEvent e)
  {
    if (e.getSource() == this.highButton)
    {
      this.risk = this.highrisk;
      setVisible(false);
    }
    else if (e.getSource() == this.lowButton)
    {
      this.risk = this.lowrisk;
      setVisible(false);
    }
    else if (e.getSource() == this.cancelButton)
    {
      setVisible(false);
    }
    else if (e.getSource() == this.calcButton)
    {
      calculateResults();
      this.highLabel.setText(String.valueOf(this.highrisk));
      this.lowLabel.setText(String.valueOf(this.lowrisk));
    }
  }
  
  private void calculateResults()
  {
    boolean triggered = false;
    double triggerVal = 0.0D;
    int absRiskIn = 0;
    double relRiskIn = 0.0D;
    int highPerIn = 0;
    int lowPerIn = 0;
    double hazard = 0.0D;
    double tempHigh = 0.0D;
    double tempLow = 0.0D;
    double tempHigh2 = 0.0D;
    double tempLow2 = 0.0D;
    double tempDiff = 0.0D;
    double tempAbsRisk = 0.0D;
    boolean badHighResults = false;
    boolean badLowResults = false;
    double tempRelRisk1 = 0.0D;
    double tempRelRisk2 = 0.0D;
    
    absRiskIn = this.absRiskField.getValue();
    try
    {
      relRiskIn = Double.valueOf(this.relRiskField.getText()).doubleValue();
    }
    catch (Exception e)
    {
      relRiskIn = 2.0D;
      new MessageDialog(this.parentFrame, "Invalid Relative Risk", true, new Label("Relative risk values must be between 0.01 and 10.00."));
      this.relRiskField.setText("2.0");
    }
    if (relRiskIn > 10.0D)
    {
      relRiskIn = 10.0D;
      new MessageDialog(this.parentFrame, "Invalid Relative Risk", true, new Label("Relative risk values must be between 0.01 and 10.00."));
      this.relRiskField.setText("10.0");
    }
    if (relRiskIn < 0.01D)
    {
      relRiskIn = 0.01D;
      new MessageDialog(this.parentFrame, "Invalid Relative Risk", true, new Label("Relative risk values must be between 0.01 and 10.00."));
      this.relRiskField.setText("0.01");
    }
    highPerIn = this.highPercentField.getValue();
    lowPerIn = 100 - highPerIn;
    triggered = false;
    badHighResults = false;
    badLowResults = false;
    try
    {
      hazard = 1.0D - Math.exp(0.2D * Math.log((100.0D - absRiskIn) / 100.0D));
      tempHigh = 100.0D - 100.0D * Math.exp(5.0D * Math.log(1.0D - hazard));
      if (hazard > relRiskIn) {
        tempLow = 100.0D - 100.0D * Math.exp(5.0D * Math.log(1.0D - (relRiskIn - 0.01D) / relRiskIn));
      } else {
        tempLow = 100.0D - 100.0D * Math.exp(5.0D * Math.log(1.0D - hazard / relRiskIn));
      }
      tempDiff = tempHigh * (highPerIn / 100.0D) + tempLow * (lowPerIn / 100.0D);
      triggerVal = absRiskIn * absRiskIn / tempDiff;
      if (triggerVal > 100.0D)
      {
        relRiskIn = 1.0D / relRiskIn;
        highPerIn = 100 - highPerIn;
        lowPerIn = 100 - lowPerIn;
        triggered = true;
      }
      tempAbsRisk = absRiskIn;
      for (int i = 0; i < 10; i++)
      {
        tempHigh2 = tempHigh;
        tempLow2 = tempLow;
        if (tempAbsRisk > 99.900000000000006D) {
          hazard = 1.0D - Math.exp(0.2D * Math.log(0.0009999999999999432D));
        } else {
          hazard = 1.0D - Math.exp(0.2D * Math.log((100.0D - tempAbsRisk) / 100.0D));
        }
        tempHigh = 100.0D - 100.0D * Math.exp(5.0D * Math.log(1.0D - hazard));
        if (hazard > relRiskIn) {
          tempLow = 100.0D - 100.0D * Math.exp(5.0D * Math.log(1.0D - (relRiskIn - 0.01D) / relRiskIn));
        } else {
          tempLow = 100.0D - 100.0D * Math.exp(5.0D * Math.log(1.0D - hazard / relRiskIn));
        }
        tempDiff = tempHigh * (highPerIn / 100.0D) + tempLow * (lowPerIn / 100.0D);
        tempAbsRisk = tempAbsRisk * absRiskIn / tempDiff;
      }
      if ((100.0D * tempHigh / tempHigh2 > 110.0D) || (100.0D * tempHigh / tempHigh2 < 90.0D)) {
        badHighResults = true;
      }
      if ((100.0D * tempLow / tempLow2 > 110.0D) || (100.0D * tempLow / tempLow2 < 90.0D)) {
        badHighResults = true;
      }
      if (triggered)
      {
        tempAbsRisk = tempLow;
        tempLow = tempHigh;
        tempHigh = tempAbsRisk;
        relRiskIn = 1.0D / relRiskIn;
      }
      tempRelRisk1 = 1.0D - Math.exp(Math.log(0.01D * (100.0D - tempHigh)) * 0.2D);
      tempRelRisk2 = 1.0D - Math.exp(Math.log(0.01D * (100.0D - tempLow)) * 0.2D);
      tempRelRisk1 /= tempRelRisk2;
      if ((100.0D * tempRelRisk1 / relRiskIn > 110.0D) || (100.0D * tempRelRisk1 / relRiskIn < 90.0D)) {
        badHighResults = true;
      }
      if (tempLow > 99.0D) {
        tempLow = 99.0D;
      }
      if (tempLow < 1.0D) {
        tempLow = 1.0D;
      }
      if (tempHigh > 99.0D) {
        tempHigh = 99.0D;
      }
      if (tempHigh < 1.0D) {
        tempHigh = 1.0D;
      }
      if ((badHighResults) || (badLowResults))
      {
        this.lowrisk = absRiskIn;
        this.highrisk = absRiskIn;
        new MessageDialog(this.parentFrame, "Invalid Relative Risk", true, new Label("Unable to accurately calculate risk factors for the specified input values."));
      }
      else if (absRiskIn > 0)
      {
        this.highrisk = ((int)Math.round(tempHigh));
        this.lowrisk = ((int)Math.round(tempLow));
      }
    }
    
    catch (Exception e)
    {
      new MessageDialog(this.parentFrame, "Invalid Relative Risk", true, new Label("Unable to accurately calculate risk factors for the specified input values."));
    }
  }
  
  public int getResult()
  {
    return this.risk;
  }
  
  public void windowClosing(WindowEvent evt)
  {
    this.cancelButton.dispatchEvent(new ActionEvent(this.cancelButton, 1001, "OK"));
  }
  
  public void windowOpened(WindowEvent evt) {}
  
  public void windowClosed(WindowEvent evt) {}
  
  public void windowIconified(WindowEvent evt) {}
  
  public void windowDeiconified(WindowEvent evt) {}
  
  public void windowActivated(WindowEvent evt) {}
  
  public void windowDeactivated(WindowEvent evt) {}
}
