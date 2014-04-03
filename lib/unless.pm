package unless;
$unless::VERSION = '0.04';
#ABSTRACT: use a Perl module unless a condition holds

sub work {
  my $method = shift() ? 'import' : 'unimport';
  die "Too few arguments to 'use unless' (some code returning an empty list in list context?)"
    unless @_ >= 2;
  return if shift;		# CONDITION

  my $p = $_[0];		# PACKAGE
  (my $file = "$p.pm") =~ s!::!/!g;
  require $file;		# Works even if $_[0] is a keyword (like open)
  my $m = $p->can($method);
  goto &$m if $m;
}

sub import   { shift; unshift @_, 1; goto &work }
sub unimport { shift; unshift @_, 0; goto &work }

q"There must be something wrong with human nature";

__END__

=pod

=encoding UTF-8

=head1 NAME

unless - use a Perl module unless a condition holds

=head1 VERSION

version 0.04

=head1 SYNOPSIS

  use unless CONDITION, MODULE => ARGUMENTS;

=head1 DESCRIPTION

The construct

  use unless CONDITION, MODULE => ARGUMENTS;

has no effect if C<CONDITION> is true.  In this case the effect is
the same as of

  use MODULE ARGUMENTS;

Above C<< => >> provides necessary quoting of C<MODULE>.  If not used (e.g.,
no ARGUMENTS to give), you'd better quote C<MODULE> yourselves.

=head1 BUGS

The current implementation does not allow specification of the
required version of the module.

=head1 AUTHORS

=over 4

=item *

Ilya Zakharevich <ilyaz@cpan.org>

=item *

Chris Williams <chris@bingosnet.co.uk>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ilya Zakharevich.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
