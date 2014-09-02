package edu.iu.nwb.composite.extractauthorpapernetwork.algorithm;
import java.util.ArrayList;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import prefuse.data.Graph;
public class processfile extends NotifyingThread
{
 public int initialsizeedge;
 public int endcount;
 public String source1;
 public int i;
 public String target1;
 public Graph outputNetwork;
   public processfile(int initialsizeedge,Graph outputNetwork, String source1, String target1, int endcount, int i)
   {
      this.initialsizeedge = initialsizeedge;
      this.source1 = source1;
      this.i = i;
      this.target1 = target1;
      this.endcount = endcount;
      this.outputNetwork = outputNetwork;
   }
   @Override
   public void doRun() {   
		for (int k = i+1; k < initialsizeedge; k++){
			String source2 = outputNetwork.getEdge(k).get("source").toString();
			String target2 = outputNetwork.getEdge(k).get("target").toString();
			if ((target2.compareTo(target1) != 0)&&(source2.compareTo(source1) == 0)){
				String target3 = "";
				String source3 = "";
				for (int j = endcount; j < outputNetwork.getNodeCount(); j++){
					if (target2.compareTo(outputNetwork.getNode(j).get("oldid").toString()) == 0){
						target3 = Integer.toString(j);
					}
					
					if (target1.compareTo(outputNetwork.getNode(j).get("oldid").toString()) == 0){
						source3 = Integer.toString(j);
					}
				}
				Boolean goodtogo = true;
				for (int kk = initialsizeedge; kk < outputNetwork.getEdgeCount(); kk++){
					if ((outputNetwork.getEdge(kk).getString("source").compareTo(source3) == 0)&&
							(outputNetwork.getEdge(kk).getString("target").compareTo(target3) == 0)){
						outputNetwork.getEdge(kk).setInt("numberOfCoAuthoredWorks", outputNetwork.getEdge(kk).getInt("numberOfCoAuthoredWorks")+1);
						outputNetwork.getNode(Integer.parseInt(source3)).setInt("numberOfWorks", outputNetwork.getNode(Integer.parseInt(source3)).getInt("numberOfWorks")+1);
						outputNetwork.getNode(Integer.parseInt(target3)).setInt("numberOfWorks", outputNetwork.getNode(Integer.parseInt(target3)).getInt("numberOfWorks")+1);
						goodtogo = false;
						kk = outputNetwork.getEdgeCount();
					}
					else if ((outputNetwork.getEdge(kk).getString("source").compareTo(target3) == 0)&&
							(outputNetwork.getEdge(kk).getString("target").compareTo(source3) == 0)){
						outputNetwork.getEdge(kk).setInt("numberOfCoAuthoredWorks", outputNetwork.getEdge(kk).getInt("numberOfCoAuthoredWorks")+1);
						outputNetwork.getNode(Integer.parseInt(source3)).setInt("numberOfWorks", outputNetwork.getNode(Integer.parseInt(source3)).getInt("numberOfWorks")+1);
						outputNetwork.getNode(Integer.parseInt(target3)).setInt("numberOfWorks", outputNetwork.getNode(Integer.parseInt(target3)).getInt("numberOfWorks")+1);
						goodtogo = false;
						kk = outputNetwork.getEdgeCount();
					}
				}

				if (goodtogo){
					outputNetwork.addEdge(outputNetwork.getNode(Integer.parseInt(target3)), outputNetwork.getNode(Integer.parseInt(source3)));
					outputNetwork.getEdge(outputNetwork.getEdgeCount()-1).setInt("numberOfCoAuthoredWorks", 1);
					outputNetwork.getEdge(outputNetwork.getEdgeCount()-1).setString("oldid", "1");
					outputNetwork.getEdge(outputNetwork.getEdgeCount()-1).setInt("special", 10);
				}
			}
		}
	}
}