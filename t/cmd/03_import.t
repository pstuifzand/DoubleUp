use Test::More;
use App::DoubleUp;

my $app = App::DoubleUp->new();
$app->process_args(qw/import file1 file2/);

is($app->command, 'import');

is_deeply($app->database_names, [ $app->list_of_schemata ]);
is_deeply($app->files, [qw/file1 file2/]);

done_testing();
