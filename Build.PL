use Module::Build;  
my $build = Module::Build->new
(
    module_name => 'App::DoubleUp',
    license     => 'perl',
    requires    => {
        DBI                   => 0,
        YAML                  => '0.71',
        'SQL::SplitStatement' => '0.05003',
    },
    recursive_test_files => 1,

);
$build->create_build_script;
