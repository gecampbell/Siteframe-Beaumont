<?php
// $Id: Database.class.inc,v 1.1 2006/05/03 01:36:32 glen Exp $
// The Database class is called statically; it returns a reader or a
// writer, both of which are mysqli connections. Internally, it checks
// for the existence of a global database connection object, and returns
// it if it is available. Otherwise, it creates an appropriate connection
// as desired.

class Database
{

	// constructor - not used
	public function __construct()
	{
		die("The Database class can only be used statically");
	}

	// getReader()
	// returns a database read connection
	public function getReader()
	{
		global $_DB_READ_CONNECTION;

		if (isset($_DB_READ_CONNECTION) && is_object($_DB_READ_CONNECTION))
		{
			return $_DB_READ_CONNECTION;
		}
		else
		{
			return $_DB_READ_CONNECTION = Database::makeReader();
		}
	}

	// getWriter()
	// returns a database write connection
	public function getWriter()
	{
		global $_DB_WRITE_CONNECTION;

		if (isset($_DB_WRITE_CONNECTION) && is_object($_DB_WRITE_CONNECTION))
		{
			return $_DB_WRITE_CONNECTION;
		}
		else
		{
			return $_DB_WRITE_CONNECTION = Database::makeWriter();
		}
	}

	// makeReader()
	// creates a new reader connection
	public function makeReader()
	{
		$conn = new mysqli(
			config('db_host'),
			config('db_user'),
			config('db_password'),
			config('db_database'),
			config('db_port', 3306)
		);
		
		// abort on error
		if (mysqli_connect_errno())
			abort('Could not connect to read database: %s',	
				mysqli_connect_error());
		
		// return the connection
		return $conn;
	}

	// makeWriter()
	// creates a new reader connection
	public function makeWriter()
	{
		$conn = new mysqli(
			config('db_host_write',config('db_host')),
			config('db_user_write',config('db_user')),
			config('db_password_write',config('db_password')),
			config('db_database_write',config('db_database')),
			config('db_port_write', config('db_port',3306))
		);
		
		// abort on error
		if (mysqli_connect_errno())
			abort('Could not connect to write database: %s', 
				mysqli_connect_error());
		
		// return the connection
		return $conn;
	}

} // end class Database
?>