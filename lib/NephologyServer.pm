package NephologyServer;
use Mojo::Base 'Mojolicious';
#use DBI;
#use YAML;
#use JSON;
#use Crypt::UnixCrypt;
#use File::Temp;
#use NephologyServer::DB;

#my $config = YAML::LoadFile("nephology.yaml") || die "Unable to load config file";
#my $db = Nephology::DB->new;
#my $dbh = $db->dbh or die $db->error;
#my @salt = ( '.', '/', 0 .. 9, 'A' .. 'Z', 'a' .. 'z' );

## uses global @salt to construct salt string of requested length
#sub gensalt {
    #my $count = shift;

    #my $salt;
    #for (1..$count) {
        #$salt .= (@salt)[rand @salt];
    #}

    #return $salt;
#}

#if (!defined($dbh)) {
    #die "Unable to connect to database";
#}

#get '/' => sub {
    #my $self = shift;
    #$self->render(text => 'Hello World');
#};

sub startup {
    my $self = shift;
    my $r = $self->routes;

    $r->get('/boot:machine')->to(
        controller => 'boot',
        action     => 'lookup_machine'
    );
    $r->get('/welcome')->to(controller => 'welcome', action => 'hello');
}

1;
