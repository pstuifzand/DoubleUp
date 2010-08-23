package App::DoubleUp;
our $VERSION = '0.2.0';

use strict;
use warnings;
use 5.010;

use DBI;
use YAML;

local $|=1;

sub new {
    my ($klass) = @_;
    my $self = {};

    $self->{config} = YAML::LoadFile($ENV{HOME} . '/.doubleuprc');

    return bless $self, $klass;
}

sub process_args {
    my ($self, @args) = @_;
    $self->{command} = shift @args;
    $self->{files} = \@args;
    return;
}

sub process_files {
    my ($self, $files) = @_;

    my @querys;

    local $/ = ";\n";

    for my $filename (@$files) {
        open my $in, '<', $filename or die "Can't open $filename";

        while (<$in>) {
            next if m/^\s*$/;
            chomp;

            my $query = $_;
            push @querys, $query;
        }
    }

    return @querys;
}
sub db_prepare {
    my ($db, $query) = @_;
    my $stmt = $db->prepare($query);
    return $stmt;
}

sub db_flatarray {
    my ($db, $query, @args) = @_;
    my $stmt = db_prepare($db, $query);
    $stmt->execute(@args);
    my @vals;
    while (my $row = $stmt->fetchrow_arrayref) {
        push @vals, $row->[0];
    }
    return @vals;
}

sub list_of_schemata {
    my ($self) = @_;
    my $db = $self->connect_to_db('dbi:mysql:information_schema', $self->credentials);
    return db_flatarray($db, $self->{config}{schemata_sql});
}

sub credentials {
    my $self = shift;
    return @{$self->{config}{credentials}};
}

sub connect_to_db {
    my ($self, $dsn, $user, $password) = @_;
    return DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0 }) or die "Can't $dsn";
}

sub process_querys_for_one_db {
    my ($self, $db, $querys) = @_;

    for my $q (@$querys) {
        if ($self->process_one_query($db, $q)) {
            print '.';
        }
        else {
            print '!';
        }
    }
}

sub process_one_query {
    my ($self, $db, $q) = @_;

    eval { 
        $db->do($q);
    };
    if ($@) {
        return;
    }
    return 1;
}

sub command {
    my $self=shift;
    return $self->{command};
}

sub run {
    my ($self) = @_;

    given ($self->command) {
        when ('listdb') {
            my @db = $self->list_of_schemata();
            for (@db) {
                say;
            }
        }
        when ('import') {
            my @querys = $self->process_files($self->{files});

            for my $schema ($self->list_of_schemata) {
                my $dsn = 'dbi:mysql:'.$schema;
                say "DB: " . $schema;
                my $db = $self->connect_to_db($dsn, $self->credentials);
                $self->process_querys_for_one_db($db, \@querys);
                say '';
            }
        }
        when (undef) {
            $self->usage;
        }
        default {
            say "Unknown command: $_";
            $self->usage;
        }
    }

}
sub usage {
    my $self = shift;
    say "Usage: doubleup [command] [options]";
    say "";
    say "List of commands";
    say "";
    say "  listdb               list of schemata";
    say "  import [filename]    import a file into each db";
    say "";
}

1;

=head1 NAME

App::DoubleApp - Import SQL files into MySQL

=cut
