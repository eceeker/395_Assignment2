use strict;
use warnings;

my %variables;

print "Simple Perl Calculator. Type 'exit' to quit.\n";
while (1) {
    print "> ";
    my $input = <STDIN>;
    chomp $input;
    
    last if $input =~ /^exit$/i;
    
    if ($input =~ /^\s*([a-zA-Z_]\w*)\s*=\s*(.+)$/) {
        my ($var, $expr) = ($1, $2);
        my $evaluated_expr = replace_variables($expr);
        my $result = evaluate_expression($evaluated_expr);
        if (defined $result) {
            $variables{$var} = $result;
            print "$var = $result\n";
        }
    } else {
        my $evaluated_expr = replace_variables($input);
        my $result = evaluate_expression($evaluated_expr);
        print "$result\n" if defined $result;
    }
}

sub replace_variables {
    my ($expr) = @_;
    $expr =~ s/([a-zA-Z_]\w*)/exists $variables{$1} ? $variables{$1} : 0/eg;
    return $expr;
}

sub evaluate_expression {
    my ($expr) = @_;
    
    if ($expr =~ /[^0-9+\-\*\/().\s]/) {
        print "Error: Invalid characters in expression.\n";
        return undef;
    }
    
    my $result = eval "$expr";
    if ($@) {
        print "Error in expression: $@\n";
        return undef;
    }
    
    return $result;
}pl