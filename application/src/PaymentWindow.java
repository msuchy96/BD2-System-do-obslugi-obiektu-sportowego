import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class PaymentWindow {
    private int rId;
    private int pId;

    public void setWindow(Connection connection){
        Stage stage = new Stage();
        stage.setTitle("Payment");
        stage.setResizable(false);
        GridPane grid = new GridPane();
        grid.setAlignment(Pos.CENTER);
        grid.setHgap(10);
        grid.setVgap(10);
        grid.setPadding(new Insets(25, 25, 25, 25));

        Scene scene = new Scene(grid, 700, 480);
        stage.setScene(scene);


        Label reservationId = new Label("Reservation Id:");
        grid.add(reservationId, 0, 1);

        TextField reservationIdField = new TextField();
        grid.add(reservationIdField, 1, 1);

        Label promotionId = new Label("Promotion Id:");
        grid.add(promotionId, 0, 2);

        TextField promotionIdField = new TextField("0");
        grid.add(promotionIdField, 1, 2);

        reservationIdField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d{0,7}?")) {
                reservationIdField.setText(oldValue);
            }
        });

        promotionIdField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d{0,7}?")) {
                promotionIdField.setText(oldValue);
            }
        });

        Button btn = new Button("Confirm Payment");
        HBox hbBtn = new HBox(10);
        hbBtn.setAlignment(Pos.BOTTOM_RIGHT);
        hbBtn.getChildren().add(btn);
        grid.add(hbBtn, 1, 10);

        btn.setOnAction(e -> {
            if (!(reservationIdField.getText().trim().isEmpty() || promotionIdField.getText().trim().isEmpty())){
                rId = Integer.parseInt(reservationIdField.getText());
                pId = Integer.parseInt(promotionIdField.getText());
                int result = this.createPayment(connection);
                if(result < 0)
                    System.out.println("Something went wrong");
                else {
                    double price = PriceGetter.getPrice(connection, result);
                    System.out.println("Purchase Id: " + result);
                    System.out.println("Price: " + price);
                }
                stage.close();
            }
        });

        scene.addEventHandler(KeyEvent.KEY_PRESSED, t -> {
            if (t.getCode() == KeyCode.ESCAPE) {
                stage.close();
            }
        });

        stage.setOnCloseRequest(we -> stage.close());

        stage.showAndWait();
    }

    private int createPayment(Connection connection) {
        CallableStatement callableStatement;
        try {
            callableStatement = connection.prepareCall("{? = call zakup_z_rezerwacji(?, ?)}");
            callableStatement.registerOutParameter(1, Types.NUMERIC);
            callableStatement.setInt(2, rId);
            callableStatement.setInt(3, pId);
        } catch (SQLException e) {
            callableStatement = null;
            e.printStackTrace();
        }
        try {
            callableStatement.execute();
            return callableStatement.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -5;
    }
}
