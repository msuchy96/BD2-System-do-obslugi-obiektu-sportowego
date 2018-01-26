import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;

import java.sql.Connection;

public class TestWindow {
    public void setWindow(Connection connection){
        Stage stage = new Stage();
        stage.setTitle("Testing");
        GridPane grid = new GridPane();
        grid.setAlignment(Pos.CENTER);
        grid.setHgap(10);
        grid.setVgap(10);
        grid.setPadding(new Insets(25, 25, 25, 25));

        Scene scene = new Scene(grid, 700, 480);
        stage.setResizable(false);
        stage.setScene(scene);

        Button populationButton = new Button("Populating Test");
        Button deletionButton = new Button("Deletion Test");

        populationButton.setMinWidth(150);
        deletionButton.setMinWidth(150);

        HBox hbBtn = new HBox(10);
        hbBtn.setAlignment(Pos.CENTER);
        hbBtn.getChildren().add(populationButton);
        hbBtn.getChildren().add(deletionButton);

        grid.add(hbBtn, 1, 1);

        populationButton.setOnAction(e -> {
            double time = Test.populate(connection);
            System.out.println("Populating elapsed time: " + time/1000 + " seconds");
            stage.close();
        });

        deletionButton.setOnAction(e -> {
            double time = Test.delete(connection);
            System.out.println("Deletion elapsed time: " + time/1000 + " seconds");
            stage.close();
        });

        scene.addEventHandler(KeyEvent.KEY_PRESSED, t -> {
            if(t.getCode()== KeyCode.ESCAPE)
            {
                stage.close();
            }
        });

        stage.setOnCloseRequest(we -> stage.close());

        stage.showAndWait();
    }
}
