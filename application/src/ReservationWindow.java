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

public class ReservationWindow {
    private int cId;
    private int eId;
    private int sId;
    private int nOfTickets;

    public void setWindow(Connection connection) {
        Stage stage = new Stage();
        stage.setTitle("Reservation");
        stage.setResizable(false);
        GridPane grid = new GridPane();
        grid.setAlignment(Pos.CENTER);
        grid.setHgap(10);
        grid.setVgap(10);
        grid.setPadding(new Insets(25, 25, 25, 25));

        Scene scene = new Scene(grid, 640, 480);
        stage.setScene(scene);

        Label clientId = new Label("Client Id:");
        grid.add(clientId, 0, 1);

        TextField clientIdField = new TextField();
        grid.add(clientIdField, 1, 1);

        Label eventId = new Label("Event Id:");
        grid.add(eventId, 0, 2);

        TextField eventIdField = new TextField();
        grid.add(eventIdField, 1, 2);

        Label sectorId = new Label("Sector Id:");
        grid.add(sectorId, 0, 3);

        TextField sectorIdField = new TextField();
        grid.add(sectorIdField, 1, 3);

        Label numberOfTickets = new Label("Number of Tickets:");
        grid.add(numberOfTickets, 0, 4);

        TextField numberOfTicketsField = new TextField();
        grid.add(numberOfTicketsField, 1, 4);

        clientIdField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d{0,7}?")) {
                clientIdField.setText(oldValue);
            }
        });

        eventIdField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d{0,7}?")) {
                eventIdField.setText(oldValue);
            }
        });

        sectorIdField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d{0,7}?")) {
                sectorIdField.setText(oldValue);
            }
        });

        numberOfTicketsField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d{0,7}?")) {
                numberOfTicketsField.setText(oldValue);
            }
        });

        Button btn = new Button("Confirm Reservation");
        HBox hbBtn = new HBox(10);
        hbBtn.setAlignment(Pos.BOTTOM_RIGHT);
        hbBtn.getChildren().add(btn);
        grid.add(hbBtn, 1, 10);

        btn.setOnAction(e -> {
            if (!(clientIdField.getText().trim().isEmpty() || eventIdField.getText().trim().isEmpty()
                    || sectorIdField.getText().trim().isEmpty() || numberOfTicketsField.getText().trim().isEmpty())){
                cId = Integer.parseInt(clientIdField.getText());
                eId = Integer.parseInt(eventIdField.getText());
                sId = Integer.parseInt(sectorIdField.getText());
                nOfTickets = Integer.parseInt(numberOfTicketsField.getText());
                int result = this.createReservation(connection);
                if(result == -1)
                    System.out.println("Not enough empty places in this sector.");
                else if(result == -2)
                    System.out.println("This client already has reservation for this event.");
                else if(result == -3)
                    System.out.println("Failed to execute database function call.");
                else
                    System.out.println("Reservation id: " + result);
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

    private int createReservation(Connection connection) {
        CallableStatement callableStatement;
        try {
            callableStatement = connection.prepareCall("{? = call rezerwuj(?, ?, ?, ?)}");
            callableStatement.registerOutParameter(1, Types.NUMERIC);
            callableStatement.setInt(2, nOfTickets);
            callableStatement.setInt(3, cId);
            callableStatement.setInt(4, eId);
            callableStatement.setInt(5, sId);
        } catch (SQLException e) {
            callableStatement = null;
            e.printStackTrace();
        }
        try {
            assert callableStatement != null;
            callableStatement.execute();
            return callableStatement.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -3;
    }
}
