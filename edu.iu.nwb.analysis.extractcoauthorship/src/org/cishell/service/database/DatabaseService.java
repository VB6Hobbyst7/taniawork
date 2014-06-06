package org.cishell.service.database;

public abstract interface DatabaseService
{
  public abstract Database createNewDatabase()
    throws DatabaseCreationException;
  
  public abstract Database connectToExistingDatabase(String paramString1, String paramString2)
    throws DatabaseCreationException;
  
  public abstract Database connectToExistingDatabase(String paramString1, String paramString2, String paramString3, String paramString4)
    throws DatabaseCreationException;
  
  public abstract Database copyDatabase(Database paramDatabase)
    throws DatabaseCopyException;
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.service.database_1.0.0.jar
 * Qualified Name:     org.cishell.service.database.DatabaseService
 * JD-Core Version:    0.7.0.1
 */