import javax.swing.*;
import java.awt.*;

public class Main {
    public static void main(String[] args) {
        JFrame frame = new JFrame("Simulare Semafor");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(200, 600);
        frame.setLayout(new GridLayout(3, 1)); // 3 culori pentru semafor

        // Crearea panourilor pentru culorile semaforului
        JPanel redPanel = new JPanel();
        redPanel.setBackground(Color.gray);
        JPanel yellowPanel = new JPanel();
        yellowPanel.setBackground(Color.gray);
        JPanel greenPanel = new JPanel();
        greenPanel.setBackground(Color.gray);

        // Adăugarea panourilor în fereastră
        frame.add(redPanel);
        frame.add(yellowPanel);
        frame.add(greenPanel);

        // Vizibilitatea ferestrei
        frame.setVisible(true);

        // Logica pentru schimbarea culorilor semaforului
        new Thread(() -> {
            try {
                while (true) {
                    // Rosu
                    redPanel.setBackground(Color.RED);
                    yellowPanel.setBackground(Color.gray);
                    greenPanel.setBackground(Color.gray);
                    Thread.sleep(5000); // Sta rosu 5 secunde

                    // Galben
                    redPanel.setBackground(Color.gray);
                    yellowPanel.setBackground(Color.YELLOW);
                    Thread.sleep(2000); // Sta galben 2 secunde

                    // Verde
                    yellowPanel.setBackground(Color.gray);
                    greenPanel.setBackground(Color.GREEN);
                    Thread.sleep(5000); // Sta verde 5 secunde

                    // Galben din nou înainte de a reveni la roșu
                    greenPanel.setBackground(Color.gray);
                    yellowPanel.setBackground(Color.YELLOW);
                    Thread.sleep(2000); // Sta galben 2 secunde
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();
    }
}