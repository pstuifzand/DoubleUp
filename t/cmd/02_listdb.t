use Test::More;
use App::DoubleUp;

my $app = App::DoubleUp->new();
$app->process_args(qw/listdb/);

is($app->command, 'listdb');
is_deeply($app->database_names, [ $app->list_of_schemata ]);

done_testing();
