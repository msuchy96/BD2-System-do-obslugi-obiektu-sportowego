import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;

public class MainWindow {
    private String activityName;

    public String setWindow() {
        Stage stage = new Stage();
        stage.setTitle("Ticket selling management application");
        GridPane grid = new GridPane();
        grid.setAlignment(Pos.CENTER);
        grid.setHgap(10);
        grid.setVgap(10);
        grid.setPadding(new Insets(25, 25, 25, 25));

        Scene scene = new Scene(grid, 640, 480);
        stage.setResizable(false);
        stage.setScene(scene);

        Button reservationButton = new Button("Reservation");
        Button purchaseButton = new Button("Purchase");
        Button paymentButton = new Button("Payment");
        Button testButton = new Button("Test");
        reservationButton.setMinWidth(150);
        purchaseButton.setMinWidth(150);
        paymentButton.setMinWidth(150);
        testButton.setMinWidth(150);
        HBox hbBtn = new HBox(10);
        hbBtn.setAlignment(Pos.CENTER);
        hbBtn.getChildren().add(reservationButton);
        hbBtn.getChildren().add(purchaseButton);
        hbBtn.getChildren().add(paymentButton);
        hbBtn.getChildren().add(testButton);
        grid.add(hbBtn, 1, 4);

        reservationButton.setOnAction(e -> {
            activityName = reservationButton.getText();
            stage.close();
        });

        purchaseButton.setOnAction(e -> {
            activityName = purchaseButton.getText();
            stage.close();
        });

        paymentButton.setOnAction(e -> {
            activityName = paymentButton.getText();
            stage.close();
        });

        testButton.setOnAction(e -> {
            activityName = testButton.getText();
            stage.close();
        });
        scene.addEventHandler(KeyEvent.KEY_PRESSED, t -> {
            if(t.getCode()== KeyCode.ESCAPE)
            {
                activityName = new String("Exit");
                stage.close();
            }
        });

        stage.setOnCloseRequest(we -> {
            activityName = new String("Exit");
            stage.close();
        });

        stage.showAndWait();
        return activityName;
    }
}
