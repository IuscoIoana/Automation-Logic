import java.util.Scanner;
public class SistemDeInchidere {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Introduceți codul de acces:");
        String codIntrodus = scanner.nextLine();

        if (verificaCodul(codIntrodus)) {
            System.out.println("Acces permis.");
        } else {
            System.out.println("Acces interzis.");
        }

        scanner.close();
    }

    public static boolean verificaCodul(String cod) {
        String codCorect = "2002";
        return cod.equals(codCorect);
    }
}