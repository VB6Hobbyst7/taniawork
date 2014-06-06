/*  1:   */ package edu.iu.nwb.analysis.extractcoauthorship.algorithms;
/*  2:   */ 
/*  3:   */ import edu.iu.nwb.analysis.extractcoauthorship.metadata.SupportedFileTypes;
/*  4:   */ import java.io.IOException;
/*  5:   */ import java.util.Dictionary;
/*  6:   */ import org.cishell.framework.CIShellContext;
/*  7:   */ import org.cishell.framework.algorithm.Algorithm;
/*  8:   */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*  9:   */ import org.cishell.framework.algorithm.ParameterMutator;
/* 10:   */ import org.cishell.framework.data.Data;
/* 11:   */ import org.cishell.reference.service.metatype.BasicAttributeDefinition;
/* 12:   */ import org.cishell.reference.service.metatype.BasicObjectClassDefinition;
/* 13:   */ import org.osgi.framework.BundleContext;
/* 14:   */ import org.osgi.framework.ServiceReference;
/* 15:   */ import org.osgi.service.component.ComponentContext;
/* 16:   */ import org.osgi.service.metatype.MetaTypeInformation;
/* 17:   */ import org.osgi.service.metatype.MetaTypeService;
/* 18:   */ import org.osgi.service.metatype.ObjectClassDefinition;
/* 19:   */ 
/* 20:   */ public class ExtractAlgorithmFactory
/* 21:   */   implements AlgorithmFactory, ParameterMutator, SupportedFileTypes
/* 22:   */ {
/* 23:   */   private MetaTypeInformation originalProvider;
/* 24:   */   private String pid;
/* 25:   */   
/* 26:   */   public ObjectClassDefinition mutateParameters(Data[] data, ObjectClassDefinition parameters)
/* 27:   */   {
/* 28:28 */     ObjectClassDefinition oldDefinition = this.originalProvider.getObjectClassDefinition(this.pid, null);
/* 29:   */     BasicObjectClassDefinition definition;
/* 30:   */     try
/* 31:   */     {
/* 32:32 */       definition = new BasicObjectClassDefinition(oldDefinition.getID(), oldDefinition.getName(), oldDefinition.getDescription(), oldDefinition.getIcon(16));
/* 33:   */     }
/* 34:   */     catch (IOException localIOException)
/* 35:   */     {
/* 36:   */       //BasicObjectClassDefinition definition;
/* 37:34 */       definition = new BasicObjectClassDefinition(oldDefinition.getID(), oldDefinition.getName(), oldDefinition.getDescription(), null);
/* 38:   */     }
/* 39:37 */     String[] supportedFormats = SupportedFileTypes.supportedFormats;
/* 40:   */     
/* 41:39 */     definition.addAttributeDefinition(1, 
/* 42:40 */       new BasicAttributeDefinition("fileFormat", "File Format", "The file format of the original data.", 1, supportedFormats, supportedFormats));
/* 43:   */     
/* 44:   */ 
/* 45:   */ 
/* 46:44 */     return definition;
/* 47:   */   }
/* 48:   */   
/* 49:   */   protected void activate(ComponentContext ctxt)
/* 50:   */   {
/* 51:51 */     MetaTypeService mts = (MetaTypeService)ctxt.locateService("MTS");
/* 52:52 */     this.originalProvider = mts.getMetaTypeInformation(ctxt.getBundleContext().getBundle());
/* 53:53 */     this.pid = ((String)ctxt.getServiceReference().getProperty("service.pid"));
/* 54:   */   }
/* 55:   */   
/* 56:   */   protected void deactivate(ComponentContext ctxt)
/* 57:   */   {
/* 58:58 */     this.originalProvider = null;
/* 59:   */   }
/* 60:   */   
/* 61:   */   public Algorithm createAlgorithm(Data[] data, Dictionary parameters, CIShellContext context)
/* 62:   */   {
/* 63:62 */     return new ExtractAlgorithm(data, parameters, context);
/* 64:   */   }
/* 65:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractcoauthorship_1.0.1.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractcoauthorship.algorithms.ExtractAlgorithmFactory
 * JD-Core Version:    0.7.0.1
 */