# NAME

App::DoubleApp - Import SQL files into MySQL

# SYNOPSIS

    $ doubleup listdb
    ww_test1
    ww_test2
    ww_test3
    ww_test4
    $ doubleup import1 ww_test db/01_base.sql
    .
    $ doubleup import db/02_upgrade.sql
    ....

# DESCRIPTION

Import SQL files into a DBI compatible database.

# AUTHOR

Peter Stuifzand <peter@stuifzand.eu>

# COPYRIGHT

Copyright 2013- Peter Stuifzand

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
