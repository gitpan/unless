#!./perl

my $t = 1;
print "1..5\n";
sub ok {
  print "not " unless shift;
  print "ok $t\n ", shift, "\n";
  $t++;
}

my $v_plus = $] + 1;
my $v_minus = $] - 1;

unless (eval 'use open ":std"; 1') {
  # pretend that open.pm is present
  $INC{'open.pm'} = 'open.pm';
  eval 'sub open::foo{}';		# Just in case...
}


ok( eval "use unless ($v_minus < \$]), strict => 'subs'; \${'f'} = 12" eq 12,
    '"use unless" with a false condition, fake pragma');

ok( eval "use unless ($v_minus < \$]), strict => 'refs'; \${'f'} = 12" eq 12,
    '"use unless" with a false condition and a pragma');

ok( eval "use unless ($v_plus < \$]), strict => 'subs'; \${'f'} = 12" eq 12,
    '"use unless" with a true condition, fake pragma');

ok( (not defined eval "use unless ($v_plus < \$]), strict => 'refs'; \${'f'} = 12"
     and $@ =~ /while "strict refs" in use/),
    '"use unless" with a true condition and a pragma');

# Old version had problems with the module name `open', which is a keyword too
# Use 'open' =>, since pre-5.6.0 could interpret differently
ok( (eval "use unless ($v_plus < \$]), 'open' => IN => ':crlf'; 12" || 0) eq 12,
    '"use unless" with open');
