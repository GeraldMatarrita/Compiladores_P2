package InterpreterPattern;

import java.util.List;

public class If implements ASTNode {
    private ASTNode condition;
    private List<ASTNode> body;
    private List<ASTNode> elseBody;

    public If(ASTNode condition, List<ASTNode> body, List<ASTNode> elseBody) {
        this.condition = condition;
        this.body = body;
        this.elseBody = elseBody;
    }

    @Override
    public Object execute() {
        if ((boolean) condition.execute()) {
            for (ASTNode node : body) {
                node.execute();
            }
        } else {
            for (ASTNode node : elseBody) {
                node.execute();
            }
        }
        return null;
    }
}
