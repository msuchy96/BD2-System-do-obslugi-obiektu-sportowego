import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class Test {
    public static int test(Connection connection) {
        CallableStatement callableStatement;
        try {
            callableStatement = connection.prepareCall("BEGIN TESUTO(?); END;");
            callableStatement.registerOutParameter(1, Types.NUMERIC);
        } catch (SQLException e) {
            callableStatement = null;
            e.printStackTrace();
        }
//        try {
//            assert callableStatement != null;
//            callableStatement.execute();
//            return callableStatement.getInt(1);
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
        return -1;
    }
}
