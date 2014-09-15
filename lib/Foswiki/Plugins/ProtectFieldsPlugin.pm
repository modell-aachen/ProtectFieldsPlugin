# See bottom of file for default license and copyright information

package Foswiki::Plugins::ProtectFieldsPlugin;

use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

our $VERSION = '1.0';
our $RELEASE = '1.0';

our $SHORTDESCRIPTION = '%$CREATED_SHORTDESCRIPTION%';

our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 2.0 ) {
        Foswiki::Func::writeWarning( 'Version mismatch between ',
            __PACKAGE__, ' and Plugins.pm' );
        return 0;
    }

    # Plugin correctly initialized
    return 1;
}

sub beforeSaveHandler {
    my ($text, $topic, $web, $meta) = @_;

    my $allWebs = $Foswiki::cfg{Plugins}{ProtectFieldsPlugin}{ProtectedFieldsAllWebs};
    my $thisWeb = $Foswiki::cfg{Plugins}{ProtectFieldsPlugin}{ProtectedFields};
    $thisWeb = $thisWeb->{$web} if $thisWeb;
    return unless $allWebs || $thisWeb;

    my ($oldMeta, $oldText) = Foswiki::Func::readTopic($web, $topic);

    my $errorsAllWebs = checkFields($web, $topic, $meta, $oldMeta, $allWebs);
    my $errorsThisWeb = checkFields($web, $topic, $meta, $oldMeta, $thisWeb);

    return unless $errorsAllWebs || $errorsThisWeb;

    my @errors = ('%MAKETEXT{"Changed form fields"}%');
    push (@errors, @$errorsAllWebs) if $errorsAllWebs;
    push (@errors, @$errorsThisWeb) if $errorsThisWeb;

    use Data::Dumper;Foswiki::Func::writeWarning(Dumper(@errors));
    @errors = map { Foswiki::Func::expandCommonVariables($_) } @errors;
    use Data::Dumper;Foswiki::Func::writeWarning(Dumper(@errors));
    throw Foswiki::OopsException(
        'oopsgeneric',
        web   => $_[2],
        topic => $_[1],
        params => [shift @errors, join("\n\n", @errors)]
    );
}

sub checkFields {
    my ($web, $topic, $meta, $oldMeta, $fields) = @_;

    return unless $fields;

    my $errors;

    foreach my $field (keys $fields) {
        my $oldHash = $oldMeta->get('FIELD', $field);
        my $oldValue = ($oldHash)?$oldHash->{value}:'';
        my $newHash = $meta->get('FIELD', $field);
        my $newValue = ($newHash)?$newHash->{value}:'';
        next if $oldValue eq $newValue;

        my $allowed = Foswiki::Func::expandCommonVariables($fields->{$field}, $topic, $web, $oldMeta);
        next if $allowed;

        $oldValue =~ s#"#\\"#g;
        $newValue =~ s#"#\\"#g;
        $errors ||= ();
        push(@$errors, '%MAKETEXT{"You are not allowed to change formfield [_1] from \"[_2]\" to \"[_3]\"." args="'."$field,$oldValue,$newValue\"}%");
    }

    return $errors;
}

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2008-2014 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
