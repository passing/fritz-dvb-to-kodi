#!/usr/bin/perl
use strict;
use LWP::Simple;

my @groups=(
{
	dvb_path => "/dvb/m3u/tvsd.m3u",
	logo_url => "http://tv.avm.de/tvapp/logos/",
	group_title => "SD"
},
{
	dvb_path => "/dvb/m3u/tvhd.m3u",
	logo_url => "http://tv.avm.de/tvapp/logos/hd/",
	group_title => "HD"
},
{
	dvb_path => "/dvb/m3u/radio.m3u",
	logo_url => "http://tv.avm.de/tvapp/logos/radio/",
	group_title => "Radio",
	radio => 1
}
);

my %logo_replace = (
	" " => "_",
	"/" => "_",
	"," => "",
	"Ä" => "ae",
	"ä" => "ae",
	"Ö" => "oe",
	"ö" => "oe",
	"Ü" => "ue",
	"ü" => "ue",
	"ß" => "ss",
);

my $file_out = "all.m3u";

#####

my $host=shift || die("host missing");

#####

my $count = 0;

open(WRITE, ">", $file_out);
print(WRITE "#EXTM3U\n");

foreach my $group_ref (@groups) {
	my %group = %$group_ref;

	my $dvb_url = "http://$host/$group{'dvb_path'}";
	printf ("fetching %s\n", $dvb_url);
	my $content=get($dvb_url) || die("fetch failed");
	open(READ, "<", \$content);

	# drop first line
	<READ>;

	while (<READ>) {
		if (/^#EXTINF:0,(.*)$/) {
			my $name=$1;
			my %options;	
			my @options_list;

			# group-title
			$options{'group-title'}=$group{'group_title'};

			# tvg-name
			$options{'tvg-name'}=$name;
			$options{'tvg-name'} =~ s/ /_/g;

			# tvg-logo
			my $name_logo=lc($name);
			foreach my $key (keys(%logo_replace)) {
				$name_logo =~ s/\Q$key/$logo_replace{$key}/g
			}
			$options{'tvg-logo'}=$group{'logo_url'} . $name_logo . ".png";

			# format options
			foreach (sort(keys(%options))) {
				push(@options_list, sprintf("%s=\"%s\"", $_, $options{$_}))
			}

			# radio
			push(@options_list, "radio=true") if $group{'radio'};

			$name =~ s/,/./g;

			printf (WRITE "#EXTINF:0 %s,%s\n", join(" ", @options_list), $name);
			$count++;
		} else {
			print(WRITE $_);
		}
	}

	close(READ);
}

close (WRITE);

printf ("wrote %u channels to %s\n", $count, $file_out);
