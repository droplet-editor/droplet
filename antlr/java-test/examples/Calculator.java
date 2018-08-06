import java.util.Scanner;

public class Calculator
{
    public static void main(String[] args)
    {
        int selection;
        double first, second;
        Scanner myScanner = new Scanner(System.in);

        System.out.print("Enter first operand: ");
        first = myScanner.nextDouble();

        System.out.print("Enter second operand: ");
        second = myScanner.nextDouble();

        System.out.println("\nCalculator Menu");
        System.out.println("---------------");
        System.out.println("1. Addition");
        System.out.println("2. Subtraction");
        System.out.println("3. Multiplication");
        System.out.println("4. Division\n");

        System.out.print("Which operation do you want to perform? ");
        selection = myScanner.nextInt();
        double result = 0.0;

        switch (selection)
        {
            case 1:
                result = first + second;
                break;
            case 2:
                result = first - second;
                break;
            case 3:
                result = first * second;
                break;
            case 4:
                result = first / second;
                break;
            default:
                System.out.println("\nError: Invalid selection! Terminating program.");
                return;
        }
        System.out.println("\nThe result of the operation is " + result + ". Goodbye!");
    }
}
