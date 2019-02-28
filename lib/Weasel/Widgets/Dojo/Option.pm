
package Weasel::Widgets::Dojo::Option;

use strict;
use warnings;

use Moose;
use Weasel::Widget::HTML::Selectable;
extends 'Weasel::Widget::HTML::Selectable';

use Weasel::WidgetHandlers qw/ register_widget_handler /;

register_widget_handler(__PACKAGE__, 'Dojo',
                        tag_name => 'tr',
                        attributes => {
                            role => 'option',
                        });


sub _option_popup {
    my ($self) = @_;

    # Note, this assumes there are no pop-ups nested in the DOM,
    # which from experimentation I believe to be true at this point
    my $popup = $self->find('ancestor::*[@dijitpopupparent]');

    return $popup;
}

sub click {
    my ($self) = @_;
    my $popup = $self->_option_popup;

    if (! $popup->is_displayed) {
        my $id = $popup->get_attribute('dijitpopupparent');
        $self->find("//*[\@id='$id']")->click; # pop up the selector
    }
    $self->SUPER::click;

    return;
}

sub selected {
    my ($self, $new_value) = @_;

    if (defined $new_value) {
        my $selected = $self->get_attribute('aria-selected') eq 'true';
        if ($new_value && ! $selected) {
            $self->click; # select
        }
        elsif (! $new_value && $selected) {
            $self->click; # unselect
        }
    }

    return $self->get_attribute('aria-selected') eq 'true';
}


1;

