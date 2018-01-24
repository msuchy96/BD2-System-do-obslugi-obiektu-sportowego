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

public class ReservationWindow {
    public void setWindow() {
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

        Label name = new Label("Name:");
        grid.add(name, 0, 1);

        TextField nameField = new TextField();
        grid.add(nameField, 1, 1);

        Label lastName = new Label("Last Name:");
        grid.add(lastName, 0, 2);

        TextField lastNameField = new TextField();
        grid.add(lastNameField, 1, 2);

        Label pesel = new Label("Pesel:");
        grid.add(pesel, 0, 3);

        TextField peselField = new TextField();
        grid.add(peselField, 1, 3);

        Button btn = new Button("Confirm Reservation");
        HBox hbBtn = new HBox(10);
        hbBtn.setAlignment(Pos.BOTTOM_RIGHT);
        hbBtn.getChildren().add(btn);
        grid.add(hbBtn, 1, 10);

        btn.setOnAction(e -> {
            if(nameField.getText().trim().isEmpty() || lastNameField.getText().trim().isEmpty()
                    || peselField.getText().trim().isEmpty()){

            }
            else
                stage.close();
        });

        scene.addEventHandler(KeyEvent.KEY_PRESSED, t -> {
            if(t.getCode()== KeyCode.ESCAPE)
            {
                stage.close();
            }
        });

        stage.setOnCloseRequest(we -> {
            stage.close();
        });

        stage.showAndWait();
    }
}
