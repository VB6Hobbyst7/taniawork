package org.cishell.service.database;

import java.sql.Connection;
import java.sql.SQLException;

public abstract interface Database
{
  public static final String DB_MIME_TYPE_PREFIX = "db:";
  public static final String GENERIC_DB_MIME_TYPE = "db:any";
  
  public abstract Connection getConnection()
    throws SQLException;
  
  public abstract String getApplicationSchemaName();
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.service.database_1.0.0.jar
 * Qualified Name:     org.cishell.service.database.Database
 * JD-Core Version:    0.7.0.1
 */