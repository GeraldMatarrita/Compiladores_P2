grammar miLenguaje;

@parser::header {
import java.util.Map;
import java.util.HashMap;
import InterpreterPattern.*;
}

@parser::members {
Map<String, Pair<String, Object>> symbolTable = new HashMap<String, Pair<String, Object>>();
}

start: declaraciones EOF;

declaraciones returns [ASTNode node]:
                declaracion {$node = $declaracion.node;};


declaracion returns [ASTNode node]:
                declaracionFuncion {$node = $declaracionFuncion.node; } (declaraciones {$node = $declaraciones.node; })*
                | declaracionVariable {$node = $declaracionVariable.node; } (declaraciones {$node = $declaraciones.node; })*;
declaracionVariable returns [ASTNode node]:
                TIPO ID ';'
                { $node = new VariableDeclaration($ID.text, $TIPO.text);};

declaracionFuncion returns [ASTNode node] :
                TIPO ID '(' ')' '{'
                {
                    List<ASTNode> body = new ArrayList<ASTNode>();
                    symbolTable.put("actualFunction", new Pair<>($ID.text, $TIPO.text));
                    symbolTable.put($ID.text, new Pair<>($TIPO.text, -1));
                }
                (sentencia {body.add($sentencia.node);})*
                '}'
                {
                    for (ASTNode node : body) {
                        node.execute(symbolTable);
                    }
                }
                {$node = new FunctionDeclaration($ID.text , $TIPO.text);};

sentencias returns [ASTNode node] :
                sentencia {$node = $sentencia.node;} sentencias *;

sentencia returns [ASTNode node] :
                 declaracionVariable {$node = $declaracionVariable.node;}
                | asignacion {$node = $asignacion.node;}
                | ifDeclaracion {$node = $ifDeclaracion.node;}
                | volverDeclaracion {$node = $volverDeclaracion.node;}
                | declaracionFuncion {$node = $declaracionFuncion.node;};

asignacion returns [ASTNode node]
                : ID '=' expresion ';'
                { $node = new Assignment($ID.text, $expresion.node);};

ifDeclaracion returns [ASTNode node]:
                  'Puede' '(' termino ')'
                  {
                      List<ASTNode> body = new ArrayList<ASTNode>();
                  }
                  '{' (s1=sentencia  { body.add($s1.node);})* '}'
                  'Entonces'
                  {
                        List<ASTNode> elseBody = new ArrayList<ASTNode>();
                  }
                  '{' (s2=sentencia { elseBody.add($s2.node);})* '}'
                  {
                        $node = new If($termino.node, body, elseBody);
                  };

volverDeclaracion returns [ASTNode node]:
                'retornar' expresion ';' {$node = new Return($expresion.node);};

expresion returns [ASTNode node] :
                f1=factor {$node = $f1.node;}
                ( '+' f2=factor {$node = new Addition($node, $f2.node);}) * (expresion)*
                | f1=factor {$node = $f1.node;}
                ( '-' f2=factor {$node = new Subtraction($node, $f2.node);}) * (expresion)*;

factor returns [ASTNode node] :
                t1=termino {$node = $t1.node;}
                ( '*' t2=termino {$node = new Multiplication($node, $t2.node);}) *
                | t1=termino {$node = $t1.node;}
                ( '/' t2=termino {$node = new Division($node, $t2.node);}) *;

termino returns [ASTNode node] :
                NUMBER {$node = new Constant(Integer.parseInt($NUMBER.text));}
                | BOOLEAN {$node = new Constant($BOOLEAN.text.equals("hecho") ? true : false);}
                | ID { $node = new VariableReference($ID.text); }
                | '(' expresion {$node = $expresion.node; } ')';

TIPO: 'entero' | 'caracter';
BOOLEAN: 'hecho' | 'noHecho';
ID: [a-zA-Z_][a-zA-Z0-9_]*;
NUMBER: [0-9]+;
WS: [ \t\r\n]+ -> skip;
