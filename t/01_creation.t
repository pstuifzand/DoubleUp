use strict;
use lib 'lib';
use Test::More tests => 1;

use App::DoubleUp;

my $app = App::DoubleUp->new();
ok($app);
