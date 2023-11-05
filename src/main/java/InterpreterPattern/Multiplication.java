package InterpreterPattern;

public class Multiplication implements ASTNode{
    private ASTNode operator1;
    private ASTNode operator2;

    public Multiplication(ASTNode operator1, ASTNode operator2) {
        this.operator1 = operator1;
        this.operator2 = operator2;
    }

    @Override
    public Object execute() {
        return (int) operator1.execute() * (int) operator2.execute();
    }
}
