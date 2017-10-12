use strict;
use warnings;

use Test::More;

use HTTP::Headers::Util qw( split_header_tokens );

my @invalid = (
    ( map { "ha${_}he" } qw~ ( ) < > @ ; : \ " / [ ] ? = { } ~ ),
);

plan tests => 3 + @invalid;

is_deeply(
    [ split_header_tokens('haha') ],
    [ 'haha' ],
    'single token',
);

is_deeply(
    [ split_header_tokens('haha, hoho') ],
    [ 'haha', 'hoho' ],
    '2 tokens',
);

is_deeply(
    [ split_header_tokens("\thaha  \t,    hoho ") ],
    [ 'haha', 'hoho' ],
    '2 tokens, wonky whitespace',
);

for my $val (@invalid) {
    eval { diag explain [ split_header_tokens($val) ] };
    my $err = $@;
    like( $err, qr<\Q$val\E>, "“$val” fails as a token" );
}
