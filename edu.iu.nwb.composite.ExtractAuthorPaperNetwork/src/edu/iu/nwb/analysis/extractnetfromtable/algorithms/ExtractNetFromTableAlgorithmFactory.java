/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.algorithms;
/*  2:   */ 
/*  3:   */ import java.util.Collections;
/*  4:   */ import java.util.Dictionary;
/*  5:   */ import java.util.List;
/*  6:   */ import org.cishell.framework.CIShellContext;
/*  7:   */ import org.cishell.framework.algorithm.Algorithm;
/*  8:   */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*  9:   */ import org.cishell.framework.algorithm.ParameterMutator;
/* 10:   */ import org.cishell.framework.data.Data;
/* 11:   */ import org.cishell.utilities.TableUtilities;
/* 12:   */ import org.cishell.utilities.mutateParameter.dropdown.DropdownMutator;
/* 13:   */ import org.osgi.service.metatype.ObjectClassDefinition;
/* 14:   */ import prefuse.data.Table;
/* 15:   */ 
/* 16:   */ public class ExtractNetFromTableAlgorithmFactory
/* 17:   */   implements AlgorithmFactory, ParameterMutator
/* 18:   */ {
/* 19:   */   public static final String COLUMN_NAME_PARAMETER_ID = "columnName";
/* 20:   */   public static final String AGGREGATION_FUNCTION_FILE_PARAMETER_ID = "aggregationFunctionFile";
/* 21:   */   public static final String DELIMITER_PARAMETER_ID = "delimiter";
/* 22:   */   
/* 23:   */   public Algorithm createAlgorithm(Data[] data, Dictionary parameters, CIShellContext context)
/* 24:   */   {
/* 25:29 */     return new ExtractNetFromTableAlgorithm(data, parameters, context);
/* 26:   */   }
/* 27:   */   
/* 28:   */   public ObjectClassDefinition mutateParameters(Data[] data, ObjectClassDefinition oldParameters)
/* 29:   */   {
/* 30:35 */     Table table = (Table)data[0].getData();
/* 31:   */     
/* 32:37 */     List columnNames = TableUtilities.getAllColumnNames(table.getSchema());
/* 33:38 */     Collections.sort(columnNames);
/* 34:   */     
/* 35:40 */     DropdownMutator mutator = new DropdownMutator();
/* 36:41 */     mutator.add("columnName", columnNames);
/* 37:   */     
/* 38:43 */     return mutator.mutate(oldParameters);
/* 39:   */   }
/* 40:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.algorithms.ExtractNetFromTableAlgorithmFactory
 * JD-Core Version:    0.7.0.1
 */