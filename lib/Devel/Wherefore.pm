package Devel::Wherefore;

our $VERSION = '0.000001'; # 0.0.1

$VERSION = eval $VERSION;

use strict;
use warnings;
use B ();
use Sub::Identify qw(sub_fullname get_code_location);
use Package::Stash;

sub import {
  our (undef, $pkg) = @_;
  unless ($pkg) {
    if (my ($path) = $0 =~ m{^(?:lib/)?(.*)\.pm$}) {
      $pkg = join '::', split '/', $path;
    } else {
      $pkg = 'main';
    }
  }
  B::minus_c;
}

sub CHECK {
  my $subs = Package::Stash->new(our $pkg)->get_all_symbols('CODE');
  print "# Symbols found in package ${pkg} after compiling $0\n";
  foreach my $name (sort keys %$subs) {
    my $fullname = sub_fullname $subs->{$name};
    my ($file, $line) = get_code_location $subs->{$name};
    print join("\t",
      map +(defined() ? $_ : "\\N"), ${name}, ${fullname}, ${file}, ${line}
    )."\n";
  }
}

1;

=head1 NAME

Devel::Wherefore - Where the heck did these subroutines come from?

=head1 SYNOPSIS

  $ perl -MDevel::Wherefore myscript.pl

will dump symbols in main from myscript.pl

  $ perl -MDevel::Wherefore=App::opan $(which opan)

will dump symbols from package App::opan in the installed opan script

  $ perl -MDevel::Wherefore lib/Foo/Bar.pm

will dump symbols from package Foo::Bar (must be in lib/ or at root, doesn't
yet handle finding them in @INC, sorry).

Note that this code uses C<B::minus_c> to only compile the script so you
don't have to worry about it executing - does mean we'll miss runtime
require and import but hey, trade-offs.

=head1 DESCRIPTION

Rage driven development rapidly released.

=head1 AUTHOR

 mst - Matt S. Trout (cpan:MSTROUT) <mst@shadowcat.co.uk>

=head1 CONTRIBUTORS

None yet - maybe this software is perfect! (ahahahahahahahahaha)

=head1 COPYRIGHT

Copyright (c) 2020 the Devel::Wherefore L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.
