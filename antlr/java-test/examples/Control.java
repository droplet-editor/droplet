import java.util.Scanner;
import bob.*;
import static bob.*;

public class HelloWorld
{
    public static void main(String[] args)
    {
        for (int index = 0; index < 10; index++)
        {
            System.out.println("Foo");
        }

        int indexAgain = 0;

        while (indexAgain < 10)
        {
            System.out.println("Bar");
            indexAgain++;
        }

        switch (indexAgain)
        {
            case 0:
                break;
            default:
                System.out.println("Wat");
        }

        if (indexAgain > 1)
        {
          return;
        }
        else if (indexAgain > 3)
        {
           break;
        }
        else
        {
           continue;
        }
    }
}
