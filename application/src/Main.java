import javafx.application.Application;
import javafx.stage.Stage;
import javafx.util.Pair;

import java.sql.Connection;
import java.sql.SQLException;

public class Main extends Application {
    Connection connection;
    public static void main(String[] argv){
        launch();
    }

    @Override
    public void start(Stage primaryStage){
        LoginWindow loginWindow = new LoginWindow();
        Pair<String, String> loginInfo = loginWindow.setStage();
        if(loginInfo.getKey() == null || loginInfo.getValue() == null){
            System.out.println("Application will now close");
            System.exit(0);
        }
        try {
            connection = DatabaseConnection.connect(loginInfo.getKey(), loginInfo.getKey());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if(connection == null){
            System.out.println("Connection failed");
            System.exit(-1);
        }
        System.out.println("Connection successful");
        while(true){
            MainWindow mainWindow = new MainWindow();
            String activityName = mainWindow.setWindow();
            switch(activityName){
                case "Reservation":
                    ReservationWindow reservationWindow = new ReservationWindow();
                    reservationWindow.setWindow(connection);
                    break;
                case "Payment":
                    break;
                case "Test":
                    break;
                case "Exit":
                    System.out.println("Application will now close");
                    System.exit(0);
            }
        }
    }
}
