use strict;
use Test::More;

use App::DoubleUp;

{
    my $app = App::DoubleUp->new({ config_file => 't/doubleuprc' });
    ok($app);
}

{
    my $app = App::DoubleUp->new({ config_file => 't/doubleuprc' });
    is($app->config_file, 't/doubleuprc');
}

{
    my $app = App::DoubleUp->new();
    is($app->config_file, './.doubleuprc');
}

done_testing();
