import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PriceGetter {
    public static double getPrice(Connection connection, int result) {
        Statement statement = null;
        ResultSet rs = null;
        String query = "SELECT CENA FROM ZAKUPY WHERE ID_ZAKUPU = " + result;
        double price = 0;
        try {
            statement = connection.createStatement();
            rs = statement.executeQuery(query);
            rs.next();
            price = rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return price;
    }
}
