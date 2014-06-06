/*  1:   */ package edu.iu.nwb.composite.extractauthorpapernetwork.algorithm;
/*  2:   */ 
/*  3:   */ import edu.iu.nwb.composite.extractauthorpapernetwork.metadata.AuthorPaperFormat;

/*  4:   */ import java.util.Collection;
/*  5:   */ import java.util.Dictionary;

/*  6:   */ import org.cishell.framework.CIShellContext;
/*  7:   */ import org.cishell.framework.algorithm.Algorithm;
/*  8:   */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*  9:   */ import org.cishell.framework.algorithm.ParameterMutator;
/* 10:   */ import org.cishell.framework.data.Data;
/* 11:   */ import org.cishell.reference.service.metatype.BasicAttributeDefinition;
/* 12:   */ import org.cishell.reference.service.metatype.BasicObjectClassDefinition;
/* 13:   */ import org.cishell.utilities.MutateParameterUtilities;
/* 14:   */ import org.osgi.service.log.LogService;
/* 15:   */ import org.osgi.service.metatype.ObjectClassDefinition;

/* 16:   */ import prefuse.data.Table;
/* 17:   */ 
/* 18:   */ @SuppressWarnings("deprecation")
public class ExtractAuthorPaperNetworkFactory
/* 19:   */   implements AlgorithmFactory, ParameterMutator
/* 20:   */ {
/* 21:   */   public static final String FILE_FORMAT_ID = "fileFormat";
/* 22:   */   
/* 23:   */   public Algorithm createAlgorithm(Data[] data, Dictionary<String, Object> parameters, CIShellContext ciShellContext)
/* 24:   */   {
/* 25:25 */     String fileFormat = parameters.get("fileFormat").toString();
/* 26:26 */     Data inData = data[0];
/* 27:27 */     Table table = (Table)inData.getData();
/* 28:28 */     LogService logger = (LogService)ciShellContext.getService(LogService.class.getName());
/* 29:   */     
/* 30:30 */     return new ExtractAuthorPaperNetwork(table, fileFormat, inData, logger);
/* 31:   */   }
/* 32:   */   
/* 33:   */   public ObjectClassDefinition mutateParameters(Data[] data, ObjectClassDefinition oldParameters)
/* 34:   */   {
/* 35:36 */     BasicObjectClassDefinition newParameters = 
/* 36:37 */       MutateParameterUtilities.createNewParameters(oldParameters);
/* 37:   */     
/* 38:39 */     String[] supportedFormatOptions = 
/* 39:40 */       (String[])AuthorPaperFormat.FORMATS_SUPPORTED.toArray(new String[0]);
/* 40:   */     
/* 41:42 */     newParameters.addAttributeDefinition(
/* 42:43 */       1, 
/* 43:44 */       new BasicAttributeDefinition(
/* 44:45 */       "fileFormat", 
/* 45:46 */       "File Format", 
/* 46:47 */       "The file format of the original data.", 
/* 47:48 */       1, 
/* 48:49 */       supportedFormatOptions, supportedFormatOptions));
/* 49:   */     
/* 50:   */ 
/* 51:   */ 
/* 52:53 */     return newParameters;
/* 53:   */   }
/* 54:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\javasrc\important ones\edu.iu.nwb.composite.extractauthorpapernetwork_0.0.2.jar
 * Qualified Name:     edu.iu.nwb.composite.extractauthorpapernetwork.algorithm.ExtractAuthorPaperNetworkFactory
 * JD-Core Version:    0.7.0.1
 */