import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class Test {
    public static float populate(Connection connection) {
        CallableStatement callableStatement;
        try {
            callableStatement = connection.prepareCall("BEGIN POPULATE(?); END;");
            callableStatement.registerOutParameter(1, Types.NUMERIC);
        } catch (SQLException e) {
            callableStatement = null;
            e.printStackTrace();
        }
        try {
            assert callableStatement != null;
            long startTime = System.currentTimeMillis();
            callableStatement.execute();
            long endTime   = System.currentTimeMillis();
            return endTime - startTime;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public static float delete(Connection connection) {
        CallableStatement callableStatement;
        try {
            callableStatement = connection.prepareCall("BEGIN DELETE_FROM_TABLES(?); END;");
            callableStatement.registerOutParameter(1, Types.NUMERIC);
        } catch (SQLException e) {
            callableStatement = null;
            e.printStackTrace();
        }
        try {
            assert callableStatement != null;
            long startTime = System.currentTimeMillis();
            callableStatement.execute();
            long endTime   = System.currentTimeMillis();
            return endTime - startTime;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}
