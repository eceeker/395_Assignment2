use std::collections::HashMap;
use std::io::{self, Write};

#[derive(Debug, PartialEq, Clone)]
enum Token {
    Number(f64),
    Plus,
    Minus,
    Multiply,
    Divide,
    Assign,
    Variable(String),
    LeftParen,
    RightParen,
}

fn tokenize(input: &str) -> Result<Vec<Token>, String> {
    let mut tokens = Vec::new();
    let mut chars = input.chars().peekable();

    while let Some(&c) = chars.peek() {
        match c {
            ' ' | '\t' | '\n' => {
                chars.next();
            }
            '+' => {
                tokens.push(Token::Plus);
                chars.next();
            }
            '-' => {
                tokens.push(Token::Minus);
                chars.next();
            }
            '*' => {
                tokens.push(Token::Multiply);
                chars.next();
            }
            '/' => {
                tokens.push(Token::Divide);
                chars.next();
            }
            '=' => {
                tokens.push(Token::Assign);
                chars.next();
            }
            '(' => {
                tokens.push(Token::LeftParen);
                chars.next();
            }
            ')' => {
                tokens.push(Token::RightParen);
                chars.next();
            }
            c if c.is_ascii_digit() || c == '.' => {
                let mut number = String::new();
                while let Some(&c) = chars.peek() {
                    if c.is_ascii_digit() || c == '.' {
                        number.push(c);
                        chars.next();
                    } else {
                        break;
                    }
                }
                match number.parse::<f64>() {
                    Ok(num) => tokens.push(Token::Number(num)),
                    Err(_) => return Err(format!("Geçersiz sayı: {}", number)),
                }
            }
            c if c.is_ascii_alphabetic() => {
                let mut variable = String::new();
                while let Some(&c) = chars.peek() {
                    if c.is_ascii_alphabetic() || c.is_ascii_digit() {
                        variable.push(c);
                        chars.next();
                    } else {
                        break;
                    }
                }
                tokens.push(Token::Variable(variable));
            }
            _ => return Err(format!("Geçersiz karakter: {}", c)),
        }
    }

    Ok(tokens)
}

fn apply_op(values: &mut Vec<f64>, op: Token) -> Result<(), String> {
    if values.len() < 2 {
        return Err("Hata: Yetersiz operand".to_string());
    }
    let b = values.pop().unwrap();
    let a = values.pop().unwrap();

    match op {
        Token::Plus => values.push(a + b),
        Token::Minus => values.push(a - b),
        Token::Multiply => values.push(a * b),
        Token::Divide => {
            if b == 0.0 {
                return Err("Hata: Sıfıra bölme".to_string());
            }
            values.push(a / b);
        }
        _ => return Err("Hata: Geçersiz operatör".to_string()),
    }
    Ok(())
}

fn evaluate(tokens: &[Token], variables: &mut HashMap<String, f64>) -> Result<f64, String> {
    if tokens.is_empty() {
        return Err("Hata: Boş ifade".to_string());
    }

    if tokens.len() == 1 {
        if let Token::Variable(var_name) = &tokens[0] {
            if let Some(value) = variables.get(var_name) {
                return Ok(*value);
            } else {
                return Err(format!("Hata: Tanımsız değişken: {}", var_name));
            }
        }
    }

    let mut iter = tokens.iter().peekable();

    if let Some(Token::Variable(var_name)) = iter.peek().cloned() {
        iter.next();
        if let Some(Token::Assign) = iter.peek().cloned() {
            iter.next();
            let expr_tokens: Vec<Token> = iter.cloned().collect();
            let result = evaluate(&expr_tokens, variables)?;
            variables.insert(var_name.clone(), result);
            return Ok(result);
        }
    }

    let mut values: Vec<f64> = Vec::new();
    let mut ops: Vec<Token> = Vec::new();

    for token in tokens {
        match token {
            Token::Number(num) => values.push(*num),
            Token::Variable(var) => {
                if let Some(value) = variables.get(var) {
                    values.push(*value);
                } else {
                    return Err(format!("Hata: Tanımsız değişken: {}", var));
                }
            }
            Token::LeftParen => ops.push(Token::LeftParen),
            Token::RightParen => {
                while let Some(op) = ops.pop() {
                    if op == Token::LeftParen {
                        break;
                    }
                    apply_op(&mut values, op)?;
                }
            }
            Token::Plus | Token::Minus | Token::Multiply | Token::Divide => {
                while let Some(op) = ops.last() {
                    if precedence(op) >= precedence(token) {
                        apply_op(&mut values, ops.pop().unwrap())?;
                    } else {
                        break;
                    }
                }
                ops.push(token.clone());
            }
            _ => return Err("Hata: Geçersiz ifade".to_string()),
        }
    }

    while let Some(op) = ops.pop() {
        apply_op(&mut values, op)?;
    }

    if values.len() != 1 {
        return Err("Hata: Geçersiz ifade".to_string());
    }

    Ok(values.pop().unwrap())
}

fn precedence(op: &Token) -> i32 {
    match op {
        Token::Plus | Token::Minus => 1,
        Token::Multiply | Token::Divide => 2,
        _ => 0,
    }
}

fn main() {
    let mut variables: HashMap<String, f64> = HashMap::new();

    loop {
        print!("> "); // işlemleri girdiğin yer. değiştir istersen
        io::stdout().flush().unwrap();

        let mut input = String::new();
        io::stdin().read_line(&mut input).unwrap();
        let input = input.trim();

        if input.eq_ignore_ascii_case("exit") {
            break;
        }

        match tokenize(input) {
            Ok(tokens) => match evaluate(&tokens, &mut variables) {
                Ok(result) => println!("{}", result),
                Err(err) => println!("{}", err),
            },
            Err(err) => println!("{}", err),
        }
    }
}