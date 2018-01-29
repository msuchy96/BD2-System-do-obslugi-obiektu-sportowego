import java.io.File;
import java.io.FileNotFoundException;
import java.sql.*;
import java.util.Scanner;

public class DatabaseConnection {

    public static Connection connect(String username, String password) throws SQLException {
        System.out.println("-------- Oracle JDBC Connection Testing ------");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

        } catch (ClassNotFoundException e) {

            System.out.println("Where is your Oracle JDBC Driver?");
            e.printStackTrace();
            return null;

        }
        Scanner scanner = null;
        System.out.println("Oracle JDBC Driver Registered!");
        try {
            scanner = new Scanner(new File("info"));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        String url = scanner.nextLine();
        String port = scanner.nextLine();
        String sid = scanner.nextLine();

        Connection connection = null;

        String usrname, passwd;
        try {
            scanner = new Scanner(new File("passwd"));
            usrname = scanner.nextLine();
            passwd = scanner.nextLine();
        } catch (FileNotFoundException e) {
            usrname = null;
            passwd = null;
            e.printStackTrace();
        }
        if (username.equals(usrname) && password.equals(passwd)) {
            try {

                connection = DriverManager.getConnection(
                        "jdbc:oracle:thin:" + username + "/" + password + "@" + url + ":" + port + ":" + sid);

            } catch (SQLException e) {

                System.out.println("Connection Failed! Check output console");
                e.printStackTrace();
                return null;

            }
        } else {
            System.out.println("Incorrect credentials.");
        }

//        if (connection != null) {
//            System.out.println("You made it, take control your database now!");
//        } else {
//            System.out.println("Failed to make connection!");
//        }
//
//        Statement statement = null;
//
//        try {
//            statement = connection.createStatement();
//            ResultSet rs = statement.executeQuery("SELECT count(*) from imprezy");
//            rs.next();
//            int result = rs.getInt(1);
//            System.out.println(result);
//            if (statement != null) statement.close();
//        } catch (SQLException e) {
//            e.printStackTrace();
//            System.exit(-1);
//        }
//        if (connection != null) connection.close();
        return connection;
    }
}