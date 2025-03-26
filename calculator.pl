% Define a dynamic predicate to store variable values
:- dynamic variable/2.

% Assign a value to a variable
assign(Var, Value) :-
    retractall(variable(Var, _)),
    asserta(variable(Var, Value)).

% Evaluate an expression
eval(Var, Value) :-
    variable(Var, Value).
eval(Number, Number) :-
    number(Number).
eval(Expression, Value) :-
    Expression =.. [Op, Left, Right],
    eval(Left, LeftValue),
    eval(Right, RightValue),
    calculate(Op, LeftValue, RightValue, Value).

% Basic arithmetic operations
calculate(add, Left, Right, Result) :-
    Result is Left + Right.
calculate(sub, Left, Right, Result) :-
    Result is Left - Right.
calculate(mul, Left, Right, Result) :-
    Result is Left * Right.
calculate(div, Left, Right, Result) :-
    Right =\= 0,
    Result is Left / Right.

% Evaluate an expression with parentheses
eval_with_parentheses(Expression, Value) :-
    Expression =.. [Op, Left, Right],
    eval_with_parentheses(Left, LeftValue),
    eval_with_parentheses(Right, RightValue),
    calculate(Op, LeftValue, RightValue, Value).
eval_with_parentheses(Expression, Value) :-
    Expression =.. [Op, Left],
    eval_with_parentheses(Left, LeftValue),
    calculate(Op, LeftValue, 0, Value).
eval_with_parentheses(Var, Value) :-
    variable(Var, Value).
eval_with_parentheses(Number, Number) :-
    number(Number).
eval_with_parentheses(Expression, Value) :-
    Expression = (Left),
    eval_with_parentheses(Left, Value).
eval_with_parentheses(Expression, Value) :-
    Expression =.. [Op, Left, Right],
    eval_with_parentheses(Left, LeftValue),
    eval_with_parentheses(Right, RightValue),
    calculate(Op, LeftValue, RightValue, Value).

% Test cases
test_assign :-
    assign(x, 5),
    eval(x, 5),
    writeln('Assign test passed').

test_add :-
    eval(add(2, 3), 5),
    writeln('Add test passed').

test_sub :-
    eval(sub(5, 3), 2),
    writeln('Sub test passed').

test_mul :-
    eval(mul(4, 5), 20),
    writeln('Mul test passed').

test_div :-
    eval(div(10, 2), 5),
    writeln('Div test passed').

test_div_by_zero :-
    \+ eval(div(10, 0), _),
    writeln('Div by zero test passed').

test_parentheses :-
    eval_with_parentheses((add(2, 3)), 5),
    writeln('Parentheses test passed').

test_all :-
    test_assign,
    test_add,
    test_sub,
    test_mul,
    test_div,
    test_div_by_zero,
    test_parentheses.

% Run all tests
:- test_all.

