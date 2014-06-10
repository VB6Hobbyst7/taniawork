/*  1:   */ package edu.iu.nwb.composite.extractpapercitationnetwork.algorithm;
/*  2:   */ 
/*  3:   */ import java.util.Dictionary;
/*  4:   */ import org.cishell.framework.CIShellContext;
/*  5:   */ import org.cishell.framework.algorithm.Algorithm;
/*  6:   */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*  7:   */ import org.cishell.framework.data.Data;
/*  8:   */ 
/*  9:   */ public class ExtractPaperCitationNetworkFactory
/* 10:   */   implements AlgorithmFactory
/* 11:   */ {
/* 12:   */   public Algorithm createAlgorithm(Data[] data, Dictionary parameters, CIShellContext context)
/* 13:   */   {
/* 14:12 */     return new ExtractPaperCitationNetwork(data, context);
/* 15:   */   }
/* 16:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\javasrc\important ones\edu.iu.nwb.composite.extractpapercitationnetwork_0.0.2.jar
 * Qualified Name:     edu.iu.nwb.composite.extractpapercitationnetwork.algorithm.ExtractPaperCitationNetworkFactory
 * JD-Core Version:    0.7.0.1
 */