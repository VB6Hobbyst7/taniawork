/*  1:   */ package org.cishell.algorithm.convertergraph;
/*  2:   */ 
/*  3:   */ import java.util.Dictionary;
/*  4:   */ import org.cishell.framework.CIShellContext;
/*  5:   */ import org.cishell.framework.algorithm.Algorithm;
/*  6:   */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*  7:   */ import org.cishell.framework.data.Data;
/*  8:   */ import org.osgi.framework.BundleContext;
/*  9:   */ import org.osgi.service.component.ComponentContext;
/* 10:   */ 
/* 11:   */ public class ConverterGraphAlgorithmFactory
/* 12:   */   implements AlgorithmFactory
/* 13:   */ {
/* 14:   */   private BundleContext bundleContext;
/* 15:   */   
/* 16:   */   protected void activate(ComponentContext ctxt)
/* 17:   */   {
/* 18:22 */     this.bundleContext = ctxt.getBundleContext();
/* 19:   */   }
/* 20:   */   
/* 21:   */   public Algorithm createAlgorithm(Data[] data, Dictionary parameters, CIShellContext context)
/* 22:   */   {
/* 23:26 */     return new ConverterGraphAlgorithm(data, parameters, context, this.bundleContext);
/* 24:   */   }
/* 25:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.algorithm.convertergraph_1.0.0.jar
 * Qualified Name:     org.cishell.algorithm.convertergraph.ConverterGraphAlgorithmFactory
 * JD-Core Version:    0.7.0.1
 */