package Sub::Regular;

use 5.006;
use strict;
use warnings;
our $VERSION = '0.01';
require Exporter;
use AutoLoader;
our @EXPORT = qw/AUTOLOAD/;
our @ISA = qw(Exporter AutoLoader);

my %Regs;
my $Regprefix = q/__REGSUB__/;

use Filter::Simple;
FILTER {
    my $sno = 0;
    while(s,^[\s\t]*sub[\t\s]+/(.+)/.*[\t\s]*(\([\$\@\%\\\*;&]*?\))?\{,"sub ${Regprefix}".$sno." ".($2?$2:'')."{",meg
){
	$Regs{$1} = $sno++;
    }
#    print $_;
};

sub AUTOLOAD{
    no strict 'refs';
    use vars '$AUTOLOAD';
    $AUTOLOAD =~ /(.+)::/;
    my $pkg = $1;
    for my $k (keys %Regs){
	goto &{"$pkg"."::${Regprefix}".$Regs{$k}} if ( $AUTOLOAD =~ /$k/i );
    }
    die "Can't translate your sub\n";
}



1;

__END__

# Below is stub documentation for your module. You better edit it!

=head1 NAME

Sub::Regular - Creating Synonymous Subroutines

=head1 SYNOPSIS

  use Sub::Regular;
  sub /look(s|ing)?_for/ ($){
     foobar blah blah
  }

  look_for('Amanda');
  looks_for('Amanda');
  looking_for('Amanda');
  lOoKiNg_fOr('Amanda');

=head1 DESCRIPTION

Sub::Regular is a small tool for users to create a subroutine with multiple names. The only thing to be done is replace the normal name of a subroutine with a regular expression. However, regexp modifiers are not allowed, and matching is all considered case-insensitive.

=head1 AUTHOR

xern E<lt>xern@cpan.orgE<gt>

=cut
