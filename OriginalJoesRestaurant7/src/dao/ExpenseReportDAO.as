package dao
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import model.Expense;
	import model.Report;
	
	import mx.collections.ArrayCollection;
	
	public class ExpenseReportDAO
	{
		public function getLastReport():Report
		{
			var sql:String = "SELECT * FROM report ORDER BY id DESC LIMIT 1";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result && result.length == 1)
				return processReportRow(result[0]);
			else
				return null;
		}
		
		public function getReport(id:int):Report
		{
			var sql:String = "SELECT * FROM report WHERE id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = id;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result && result.length == 1)
				return processReportRow(result[0]);
			else
				return null;
		}
		
		public function getReports():ArrayCollection
		{
			var sql:String = "SELECT r.id, r.title, r.date, r.description, sum(i.amount) total FROM report r LEFT JOIN expense i ON i.report_id = r.id GROUP BY r.id";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result)
			{
				var list:ArrayCollection = new ArrayCollection();
				for (var i:int=0; i<result.length; i++)
				{
					list.addItem(processReportRow(result[i]));	
				}
				return list;
			}
			else
			{
				return null;
			}
		}
		
		public function saveReport(report:Report):int
		{
			if (report.id>0)
				return updateReport(report);
			else
				return createReport(report);
		}
		
		public function createReport(report:Report):int
		{
			var sql:String = 
				"INSERT INTO report (date, title, description) " +
				"VALUES (?,?,?)";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = report.date;
			stmt.parameters[1] = report.title;
			stmt.parameters[2] = report.description;
			stmt.execute();
			return stmt.getResult().lastInsertRowID;
		}

		public function updateReport(report:Report):int
		{
			var sql:String = "UPDATE report SET date=?, title=?, description=? WHERE id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = report.date;
			stmt.parameters[1] = report.title;
			stmt.parameters[2] = report.description;
			stmt.parameters[3] = report.id;
			stmt.execute();
			return report.id;
		}
		
		protected function processReportRow(o:Object):Report
		{
			var report:Report = new Report();
			report.id = o.id;
			report.date = o.date;
			report.title = o.title == null ? "" : o.title;
			report.description = o.description == null ? "" : o.description;
			report.total = o.total;
			return report;
		}
		
		public function getExpense(id:int):Expense
		{
			var sql:String = "SELECT * FROM expense WHERE id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = id;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result && result.length == 1)
				return processExpenseRow(result[0]);
			else
				return null;
		}
		
		public function getExpensesByReport(report:Report):ArrayCollection
		{
			var sql:String = "SELECT * FROM expense WHERE report_id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = report.id;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result)
			{
				var list:ArrayCollection = new ArrayCollection();
				var total:Number = 0;
				for (var i:int=0; i<result.length; i++)
				{
					var expense:Expense = processExpenseRow(result[i]);
					list.addItem(expense);
					total += expense.amount;
				}
				report.total = total;
				return list;
			}
			else
			{
				return null;
			}
		}
		
		public function saveExpense(expense:Expense):int
		{
			if (expense.id>0)
				return updateExpense(expense);
			else
				return createExpense(expense);
		}

		public function updateExpense(expense:Expense):int
		{
			var sql:String = "UPDATE expense SET report_id=?, date=?, category=?, location=?, longitude=?, latitude=?, description=?, receipt_url=?, amount=? WHERE id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = expense.reportId;
			stmt.parameters[1] = expense.date;
			stmt.parameters[2] = expense.category;
			stmt.parameters[3] = expense.location;
			stmt.parameters[4] = expense.longitude;
			stmt.parameters[5] = expense.latitude;
			stmt.parameters[6] = expense.description;
			stmt.parameters[7] = expense.receiptURL;
			stmt.parameters[8] = expense.amount;
			stmt.parameters[9] = expense.id;
			stmt.execute();
			return expense.id;
		}
		
		public function createExpense(expense:Expense):int
		{
			var sql:String = 
				"INSERT INTO expense (report_id, date, category, location, longitude, latitude, description, receipt_url, amount) " +
				"VALUES (?,?,?,?,?,?,?,?,?)";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = expense.reportId;
			stmt.parameters[1] = expense.date;
			stmt.parameters[2] = expense.category;
			stmt.parameters[3] = expense.location;
			stmt.parameters[4] = expense.longitude;
			stmt.parameters[5] = expense.latitude;
			stmt.parameters[6] = expense.description;
			stmt.parameters[7] = expense.receiptURL;
			stmt.parameters[8] = expense.amount;
			stmt.execute();
			return stmt.getResult().lastInsertRowID;
		}
		
		protected function processExpenseRow(o:Object):Expense
		{
			var expense:Expense = new Expense();
			expense.id = o.id;
			expense.reportId = o.report_id;
			expense.date = o.date;
			expense.category = o.category == null ? "" : o.category;
			expense.location = o.location == null ? "" : o.location;
			expense.longitude = o.longitude;
			expense.latitude = o.latitude;
			expense.receiptURL = o.receipt_url;
			expense.description = o.description == null ? "" : o.description;
			expense.amount = o.amount;
			return expense;
		}
		
		public static var _sqlConnection:SQLConnection;
		
		public function get sqlConnection():SQLConnection
		{
			if (_sqlConnection) return _sqlConnection;
			var file:File = File.documentsDirectory.resolvePath("xpsenseit00.db");
			var fileExists:Boolean = file.exists;
			_sqlConnection = new SQLConnection();
			_sqlConnection.open(file);
			if (!fileExists)
			{
				createDatabase();
				populateDatabase(_sqlConnection);
			}
			return _sqlConnection;
		}
		
		protected function createDatabase():void
		{
			var sql:String = 
				"CREATE TABLE IF NOT EXISTS report ( "+
				"id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"date DATETIME, " +
				"title TEXT, " +
				"description TEXT)"; 
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.execute();	

			sql = 
				"CREATE TABLE IF NOT EXISTS expense ( "+
				"id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"report_id INTEGER, " +
				"date DATETIME, " +
				"category TEXT, " +
				"location TEXT, " +
				"longitude TEXT, " +
				"latitude TEXT, " +
				"description TEXT, " + 
				"receipt_url TEXT, " + 
				"amount REAL)";
			stmt.text = sql;
			stmt.execute();	
		}

		protected function populateDatabase(sqlConnection:SQLConnection):void
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "INSERT INTO report (title, date, description) values (?,?,?)";
			
			stmt.parameters[0] = "Team Meeting SF";
			stmt.parameters[1] = new Date(new Date().time - 7 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Technical Evangelists Meeting";
			stmt.execute();	

			stmt.parameters[0] = "Customer Briefings NYC";
			stmt.parameters[1] = new Date(new Date().time - 10 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Flex on iOS Briefings";
			stmt.execute();	

			stmt.parameters[0] = "Flex User Group Hawaii";
			stmt.parameters[1] = new Date(new Date().time - 14 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Presenter at Flex User Group Hawaii";
			stmt.execute();	

			stmt.text = "INSERT INTO expense (report_id, date, category, location, longitude, latitude, description, amount) values (?,?,?,?,?,?,?,?)";
			stmt.parameters[0] = 1;
			stmt.parameters[1] = new Date(new Date().time - 7 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Taxi";
			stmt.parameters[3] = "San Francisco, CA";
			stmt.parameters[4] = -122.401681;
			stmt.parameters[5] = 37.771829;
			stmt.parameters[6] = "SFO -> Office";
			stmt.parameters[7] = 45;
			stmt.execute();	
			
			stmt.parameters[0] = 1;
			stmt.parameters[1] = new Date(new Date().time - 7 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Hotel";
			stmt.parameters[3] = "San Francisco, CA";
			stmt.parameters[4] = -122.404791;
			stmt.parameters[5] = 37.785016;
			stmt.parameters[6] = "Marriott Marquis";
			stmt.parameters[7] = 859.23;
			stmt.execute();	
			
			stmt.parameters[0] = 1;
			stmt.parameters[1] = new Date(new Date().time - 7 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Meal";
			stmt.parameters[3] = "San Jose, CA";
			stmt.parameters[4] = -122.412058;
			stmt.parameters[5] = 37.788266;
			stmt.parameters[6] = "Le Colonial";
			stmt.parameters[7] = 32.85;
			stmt.execute();	

			stmt.parameters[0] = 2;
			stmt.parameters[1] = new Date(new Date().time - 10 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Taxi";
			stmt.parameters[3] = "New York, NY";
			stmt.parameters[4] = -73.8720313;
			stmt.parameters[5] = 40.7746389;
			stmt.parameters[6] = "La Guardia";
			stmt.parameters[7] = 42.50;
			stmt.execute();	

			stmt.parameters[0] = 2;
			stmt.parameters[1] = new Date(new Date().time - 10 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Hotel";
			stmt.parameters[3] = "New York, NY";
			stmt.parameters[4] = -73.985517;
			stmt.parameters[5] = 40.758408;
			stmt.parameters[6] = "Marriott Marquis";
			stmt.parameters[7] = 956.85;
			stmt.execute();	
			
			stmt.parameters[0] = 2;
			stmt.parameters[1] = new Date(new Date().time - 10 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Meal";
			stmt.parameters[3] = "New York, NY";
			stmt.parameters[4] = -73.982213;
			stmt.parameters[5] = 40.761561;
			stmt.parameters[6] = "Le Bernardin";
			stmt.parameters[7] = 72.36;
			stmt.execute();	

			stmt.parameters[0] = 3;
			stmt.parameters[1] = new Date(new Date().time - 14 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Taxi";
			stmt.parameters[3] = "Honolulu, HI";
			stmt.parameters[4] = -157.921418;
			stmt.parameters[5] = 21.332898;
			stmt.parameters[6] = "Airport";
			stmt.parameters[7] = 28.63;
			stmt.execute();	
			
			stmt.parameters[0] = 3;
			stmt.parameters[1] = new Date(new Date().time - 14 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Hotel";
			stmt.parameters[3] = "Honolulu, HI";
			stmt.parameters[4] = -157.8231051;
			stmt.parameters[5] = 21.2728669;
			stmt.parameters[6] = "Waikiki Beach Marriott Resort & Spa";
			stmt.parameters[7] = 1268.47;
			stmt.execute();	
			
			stmt.parameters[0] = 3;
			stmt.parameters[1] = new Date(new Date().time - 14 * 24 * 60 * 60 * 1000);
			stmt.parameters[2] = "Meal";
			stmt.parameters[3] = "Honolulu, HI";
			stmt.parameters[4] = -157.8165543;
			stmt.parameters[5] = 21.3420075;
			stmt.parameters[6] = "Indigo Restaurant";
			stmt.parameters[7] = 51.45;
			stmt.execute();	
			
		}
	}
}