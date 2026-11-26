#!/usr/bin/perl

# =======================================================================================
# Title:        IBN-to-IMT
# Programmer:   DZ-Jay <dz-game@techunlimited.net>
# Last Update:  2021-03-01
#
# Description:  Translates a music module composed in IntyBASIC Notation (IBN), into the
#               data format used by the Intellivision Music Tracker (IMT).  The result
#               is an Assembly Language source file with the original song represented
#               in the target format.
#
#               Copyright 2021, James Pujals (DZ-Jay), <dz-game@techunlimited.net>.
# =======================================================================================

use utf8;
use strict;
use warnings;
use integer;
use FileHandle;
use File::Basename;
use Getopt::Long qw(GetOptions :config pass_through bundling);
use Pod::Usage qw(pod2usage);

# use Data::Dumper;
#     $Data::Dumper::Deepcopy = 1;
    $| = 1;

my %OPTIONS         = (
    HELP            => 0,
    MANUAL          => 0,
    PROG_NAME       => undef,
    SOURCE_FILE     => undef,
    OUTPUT_FILE     => undef,
    NOTE_LENGTH     => 1,
    PATTERN_LENGTH  => 0,
    AUTO_REPEAT     => 0,
    EXPORT_MANUAL   => 0,
    CHANNEL_COUNT   => 6
    );

my @PRG_EXTS        = ('.pl', '.PL');
my @IBN_EXTS        = ('.txt', '.bas', '.ibn', '.mus', '.TXT', '.BAS', '.IBN', '.MUS');

sub STATE_START  {  0 };
sub STATE_SCAN   {  1 };
sub STATE_SUB    {  2 };
sub STATE_END    {  3 };
sub STATE_DEAD   { -1 };

my %STATE_MAP       = (
    &STATE_START    => 'START',
    &STATE_SCAN     => 'SONG-SCAN',
    &STATE_SUB      => 'SUBROUTINE-SCAN',
    &STATE_END      => 'END',
    &STATE_DEAD     => 'DEAD',
    );

# #########################################################
# PROCESS USER INPUT
# #########################################################
{
    my %args = (
        'h|help|?'      => \$OPTIONS{'HELP'          },
        'm|manual|man'  => \$OPTIONS{'MANUAL'        },

        'c|channels=i'  => \&get_arg_channels,
        'n|note-len=i'  => \$OPTIONS{'NOTE_LENGTH'   },
        'o|out=s'       => \$OPTIONS{'OUTPUT_FILE'   },
        'p|pat-len=i'   => \$OPTIONS{'PATTERN_LENGTH'},
        'r|repeat'      => \$OPTIONS{'AUTO_REPEAT'   },
        'x|export-man'  => \$OPTIONS{'EXPORT_MANUAL' }
        );

    # Extract program name
    my $prog = fileparse($0, @PRG_EXTS);
       $OPTIONS{'PROG_NAME'} = $prog;

    # Get command line options
    GetOptions(%args) or
        pod2usage(-verbose => 0);
        pod2usage(-verbose => 0) if ($OPTIONS{'HELP'  });
        pod2usage(-verbose => 2) if ($OPTIONS{'MANUAL'});
        export_manual(\%OPTIONS) if ($OPTIONS{'EXPORT_MANUAL'});

    # Validate the source file argument
    $OPTIONS{'SOURCE_FILE'} = shift(@ARGV) or
        pod2usage(-verbose => 0);

    # Set output filename
    unless ($OPTIONS{'OUTPUT_FILE'})
        {
        my ($file, $dirs) = fileparse($OPTIONS{'SOURCE_FILE'}, @IBN_EXTS);

        $OPTIONS{'OUTPUT_FILE'} = "${ dirs }${ file }.asm";
        }

# print Dumper(\%OPTIONS);
# exit;
}

# #########################################################
# INITIALIZE DATA STRUCTURES
# #########################################################
my %INSTRUMENTS = (
    W       => 1,   # Piano
    X       => 2,   # Clarinet
    Y       => 3,   # Flute
    Z       => 4    # Bass
    );

my %IBN_DATA = (
    COMMANDS    => [],
    LABELS      => {},
    LABEL_MAP   => {},
    SOURCE_MAP  => {},
    STATE       =>
        {
        CURR_IDX    => 0,
        CURR_STATE  => &STATE_START,
        CURR_CMD    => undef,
        ERROR       => undef,
        LAST_LABELS => [],
        STACK       => []
        }
    );

my %IBN_SONG = (
    NAME            => undef,
    SPEED           => undef,
    CHANNELS        => undef,
    REPEAT_LABEL    => undef,
    AUTO_REPEAT     => $OPTIONS{'AUTO_REPEAT'},
    NOTE_LENGTH     => $OPTIONS{'NOTE_LENGTH'},
    ROWS            => 0,
    DEFAULT         =>
        {
        A   =>
            {
            VOLUME  => 15,
            INSTR   => 1
            },
        B   =>,
            {
            VOLUME  => 15,
            INSTR   => 1
            },
        C   =>,
            {
            VOLUME  => 15,
            INSTR   => 1
            },
        D   =>,
            {
            VOLUME  => 15,
            INSTR   => 1
            },
        E   =>,
            {
            VOLUME  => 15,
            INSTR   => 1
            },
        F   =>
            {
            VOLUME  => 15,
            INSTR   => 1
            }
        },
    LABELS  => {},
    TRACKS  =>
        {
        A   => [],
        B   => [],
        C   => [],
        D   => [],
        E   => [],
        F   => []
        },
    DRUMS   =>
        {
        X   => [],
        Y   => []
        }
    );

my $IMT_DATA_REF    = undef;

# #########################################################
# READ SOURCE
# #########################################################
{
my $fh = FileHandle->new();
open($fh, "< ". $OPTIONS{'SOURCE_FILE'}) or die("Unable to open source file '". $OPTIONS{'SOURCE_FILE'} ."': $!\n");

    my $last_label = undef;
    my $src_line = 0;
    LINE: while (my $line = <$fh>)
        {
        chomp($line);

        # Remove comments ...
        $line =~ s/\s*(\'|REM\b).*//io;
        $src_line++;

        # Skip empty lines
        next unless ($line && $line =~ /^\s*\w/o);

        # Everything else is either a label, a command, or both.
        my ($prefix, $label, $command) = ($line =~ /^(\s*(\w+):)?\s*(.*?)\s*$/o);

        # Propagate stand alone labels ...
        unless ($prefix)
            {
            $label = $last_label;
            }

        # Process commands
        if ($command)
            {
            push(@{ $IBN_DATA{'COMMANDS'} }, $command);

            my $idx = $#{ $IBN_DATA{'COMMANDS'} };
            $IBN_DATA{'SOURCE_MAP'}->{ $idx } = $src_line;

            if ($label)
                {
                $IBN_DATA{'LABELS'   }->{ $label } = $idx;
                $IBN_DATA{'LABEL_MAP'}->{ $idx   } = $label;
                }

            # Clear used label
            $last_label = undef;
            }
        else
            {
            # If no command, keep track of label for next one
            $last_label = $label;
            }
        }

close($fh);

# print Dumper(\%IBN_DATA);
# exit;
}

# #########################################################
# EXTRACT IBN SOURCE DATA
# #########################################################
{
    my $last_idx = $#{ $IBN_DATA{'COMMANDS'} };
    COMMAND: while ($IBN_DATA{'STATE'}->{'CURR_IDX'} <= $last_idx)
        {
        # Extract command information
        my $idx     = $IBN_DATA{'STATE'   }->{'CURR_IDX'}++;
        my $command = $IBN_DATA{'COMMANDS'}->[ $idx ];

        $IBN_DATA{'STATE'}->{'CURR_CMD'} = $command;

        # If we have a label mapped to the current index,
        # we must keep track of it until it gets flushed
        # into the song stream.
        if (exists $IBN_DATA{'LABEL_MAP'}->{ $idx })
            {
            push(@{ $IBN_DATA{'STATE'}->{'LAST_LABELS'} }, $IBN_DATA{'LABEL_MAP'}->{ $idx });
            }

        # Process command
        process_cmd(\%IBN_DATA, \%IBN_SONG, $command)
            or last COMMAND;
        }

    # Check if we ended in a valid state ...
    unless (validate_cmd_state(\%IBN_DATA, [ &STATE_END ]))
        {
        # Not a valid state end state!
        # Display error and quit.
        my $error = $IBN_DATA{'STATE'}->{'ERROR'};
        die("ERROR: ${ error }\n");
        }

    # print Dumper(\%IBN_SONG);
    # exit;
}

# #########################################################
# TRANSFORM IBN SOURCE TO IMT DATA
# #########################################################
{
    my $min_len  = ($OPTIONS{'PATTERN_LENGTH'} == 0) ?   4 : $OPTIONS{'PATTERN_LENGTH'};
    my $max_len  = ($OPTIONS{'PATTERN_LENGTH'} == 0) ? 256 : $OPTIONS{'PATTERN_LENGTH'};
    my $detected = '';

    print "\n";
    if ($OPTIONS{'PATTERN_LENGTH'})
        {
        print "Processing song with pattern length of ", $OPTIONS{'PATTERN_LENGTH'}, " rows ...";
        }
    else
        {
        print "Determining song optimal pattern length ";
        $detected = '(detected)';
        }

    $IMT_DATA_REF = detect_optimal_pattern_length(\%IBN_SONG, $min_len, $max_len);

    print " Done.\n";

    print "\nSong Translation Results:\n";
    print "\tSong Speed:           ", $IBN_SONG{'SPEED'},                                        " ticks/row\n";
    print "\tOutput Channels:      ", $OPTIONS{'CHANNEL_COUNT'},                                 " tracks\n";
    print "\tActive Channels:      ", $IBN_SONG{'CHANNELS'},                                     " tracks\n";
    print "\tPattern Length:       ", $IMT_DATA_REF->{'LENGTH'},                                 " rows ${ detected }\n";
    print "\tUnique Sub-Patterns:  ", scalar(keys %{ $IMT_DATA_REF->{'UNIQUE'}->{'SUBPATTS'} }), " sub-patterns\n";
    print "\tUnique Patterns:      ", scalar(keys %{ $IMT_DATA_REF->{'UNIQUE'}->{'PATTERNS'} }), " patterns\n";
    print "\tSong Sequence:        ", scalar(@{ $IMT_DATA_REF->{'SEQUENCE'} }),                  " patterns\n";
    print "\tEstimated Data Size:  ", commify($IMT_DATA_REF->{'SIZE'}),                          " words (decles)\n";

    print "\nOutput file: \"", $OPTIONS{'OUTPUT_FILE'}, "\"\n\n";

    # print Dumper(\%IBN_SONG);
    # print Dumper($IMT_DATA_REF);
    # exit;
}

# #########################################################
# GENERATE OUTPUT
# #########################################################
{
my $fh = FileHandle->new();
open($fh, "> ". $OPTIONS{'OUTPUT_FILE'}) or die("Unable to open output file '". $OPTIONS{'OUTPUT_FILE'} ."': $!\n");

    get_song_header     ($fh, \%IBN_SONG, $IMT_DATA_REF);
    get_song_sequence   ($fh, \%IBN_SONG, $IMT_DATA_REF);
    get_song_patterns   ($fh, \%IBN_SONG, $IMT_DATA_REF);
    get_song_instruments($fh, \%IBN_SONG, $IMT_DATA_REF);
    get_song_drums      ($fh, \%IBN_SONG, $IMT_DATA_REF);
    get_song_subpatterns($fh, \%IBN_SONG, $IMT_DATA_REF);
    get_song_footer     ($fh, \%IBN_SONG, $IMT_DATA_REF);

close($fh);
}

# process_cmd($data_ref, $song_ref, $command)
sub process_cmd
{
    my ($data_ref, $song_ref, $command) = @_;

    my $proceed     = undef;
    my $state_ref   = $data_ref->{'STATE'};

    if ($command =~ /^DATA\s+(\d+)$/io)
        {
        my $speed = $1;

        $proceed = process_cmd_header($data_ref, $song_ref, $speed);
        }
    elsif ($command =~ /^MUSIC\s+(.+)$/io)
        {
        my $cmd = $1;

        # REPEAT
        if (uc($cmd) eq 'REPEAT')
            {
            $proceed = process_cmd_repeat($data_ref, $song_ref);
            }

        # STOP
        elsif (uc($cmd) eq 'STOP')
            {
            $proceed = process_cmd_stop($data_ref, $song_ref);
            }

        # JUMP
        elsif ($cmd =~ /^JUMP\s+(\w+)$/io)
            {
            my $target = $1;
            $proceed = process_cmd_jump($data_ref, $song_ref, $target);
            }

        # GOSUB
        elsif ($cmd =~ /^GOSUB\s+(\w+)$/io)
            {
            my $target = $1;

            $proceed = process_cmd_gosub($data_ref, $song_ref, $target);
            }

        # RETURN
        elsif (uc($cmd) eq 'RETURN')
            {
            $proceed = process_cmd_return($data_ref, $song_ref);
            }

        # SPEED
        elsif ($cmd =~ /^SPEED\s+(\d+)$/io)
            {
            my $speed = $1;
            $proceed = process_cmd_speed($data_ref, $song_ref, $speed);
            }

        # VOLUME
        elsif ($cmd =~ /^VOLUME\s+(\d+)$/io)
            {
            my $volume = $1;
            $proceed = process_cmd_volume($data_ref, $song_ref, $volume);
            }

        # NOTE
        else
            {
            $proceed = process_cmd_note($data_ref, $song_ref, $cmd);
            }
        }

    return $proceed;
}

# process_cmd_header($data_ref, $song_ref, $speed)
sub process_cmd_header
{
    my ($data_ref, $song_ref, $speed) = @_;

    # Validate current command state
    validate_cmd_state($data_ref, [ &STATE_START ])
        or return;

    $song_ref->{'SPEED'} = $speed;

    my $name = (scalar @{ $data_ref->{'STATE'}->{'LAST_LABELS'} })
             ? $data_ref->{'STATE'}->{'LAST_LABELS'}->[0]
             : 'Unknown';

    $song_ref->{'NAME' } = $name;
    $data_ref->{'STATE'}->{"CURR_STATE"} = &STATE_SCAN;

    return 1;   # Proceed with next command
}

# process_cmd_repeat($data_ref, $song_ref)
sub process_cmd_repeat
{
    my ($data_ref, $song_ref) = @_;

    # Validate current command state
    validate_cmd_state($data_ref, [ &STATE_SCAN ])
        or return;

    $song_ref->{'AUTO_REPEAT'} = 1;

    # End "scan" state and transition to "end"
    $data_ref->{'STATE'}->{'CURR_STATE'} = &STATE_END;

    return;   # Stop processing commands
}

# process_cmd_stop($data_ref, $song_ref)
sub process_cmd_stop
{
    my ($data_ref, $song_ref) = @_;

    # Validate current command state
    validate_cmd_state($data_ref, [ &STATE_SCAN ])
        or return;

    $song_ref->{'AUTO_REPEAT'} = 0;

    # End "scan" state and transition to "end"
    $data_ref->{'STATE'}->{'CURR_STATE'} = &STATE_END;

    return;   # Stop processing commands
}

# process_cmd_return($data_ref, $song_ref)
sub process_cmd_return
{
    my ($data_ref, $song_ref) = @_;

    # Validate current command state
    validate_cmd_state($data_ref, [ &STATE_SUB ])
        or return;

    my $state_ref = $data_ref->{'STATE'};
    if (scalar @{ $state_ref->{'STACK'} })
        {
        # Pop the previous index from the stack
        # and re-point the current index to it.
        $state_ref->{'CURR_IDX'} = pop(@{ $state_ref->{'STACK'} });
        }

    # End "subroutine-scan" state and return to "scan"
    $data_ref->{'STATE'}->{'CURR_STATE'} = &STATE_SCAN;

    return 1;   # Proceed with next command
}

# process_cmd_jump($data_ref, $song_ref, $target)
sub process_cmd_jump
{
    my ($data_ref, $song_ref, $target) = @_;

    # Validate current command state
    validate_cmd_state($data_ref, [ &STATE_SCAN, &STATE_SUB ])
        or return;

    my $end_song = 0;
    if (exists $data_ref->{'LABELS'}->{ $target })
        {
        my $state_ref  = $data_ref->{'STATE'};

        if (exists $song_ref->{'LABELS'}->{ $target })
            {
            # End the song stream and keep track of the
            # target as the repeat label for the sequence
            # backtracking offset.
            $song_ref->{'REPEAT_LABEL'} = $target;
            $end_song = 1;

            # Treat this jump as an unconditional end of song
            $data_ref->{'STATE'}->{'CURR_STATE'} = &STATE_END;
            }
        else
            {
            # Re-point the current index to the target.
            $state_ref->{'CURR_IDX'} = $data_ref->{'LABELS'}->{ $target };
            }
        }

    return ($end_song) ? undef : 1;
}

# process_cmd_gosub($data_ref, $song_ref, $target)
sub process_cmd_gosub
{
    my ($data_ref, $song_ref, $target) = @_;

    # Validate current command state
    validate_cmd_state($data_ref, [ &STATE_SCAN, &STATE_SUB ])
        or return;

    if (exists $data_ref->{'LABELS'}->{ $target })
        {
        my $state_ref  = $data_ref->{'STATE'};

        # Push the current index into the stack, and
        # re-point it to the target.
        push(@{ $state_ref->{'STACK'} }, $state_ref->{'CURR_IDX'});
        $state_ref->{'CURR_IDX'} = $data_ref->{'LABELS'}->{ $target };
        }

    # Engage or re-assert "subroutine-scan" state
    $data_ref->{'STATE'}->{'CURR_STATE'} = &STATE_SUB;

    return 1;   # Proceed with next command
}

# process_cmd_speed($data_ref, $song_ref, $speed)
sub process_cmd_speed
{
    my ($data_ref, $song_ref, $speed) = @_;

    # Validate current command state
    validate_cmd_state($data_ref, [ &STATE_SCAN, &STATE_SUB ])
        or return;

    $song_ref->{'SPEED'} = $speed;

    return 1;   # Proceed with next command
}

# process_cmd_volume($data_ref, $song_ref, $volume)
sub process_cmd_volume
{
    my ($data_ref, $song_ref, $volume) = @_;

    # Validate current command state
    validate_cmd_state($data_ref, [ &STATE_SCAN, &STATE_SUB ])
        or return;

    my $default_ref = $song_ref->{'DEFAULT'};
    foreach my $chn (keys %{ $default_ref })
        {
        $default_ref->{ $chn }->{'VOLUME'} = $volume;
        }

    return 1;   # Proceed with next command
}

# validate_cmd_state($data_ref, $valid_ref)
sub validate_cmd_state
{
    my ($data_ref, $valid_ref) = @_;

    my $state_ref = $data_ref ->{'STATE'     };
    my $state     = $state_ref->{'CURR_STATE'};
    my %valid     = ( map { $_ => 1 } @{ $valid_ref });

    # Check if the current state is in the valid set,
    # or skip if it's already in the DEAD state.
    if (!(($state == &STATE_DEAD) || (exists $valid{ $state })))
        {
        my $state_str = $STATE_MAP{ $state };
        my $curr_line = ($state_ref->{'CURR_IDX'} - 1);
        my $src_line  = $data_ref ->{'SOURCE_MAP'}->{ $curr_line };
        my $command   = $state_ref->{'CURR_CMD'  };

        $state_ref->{'CURR_STATE'} = &STATE_DEAD;
        $state_ref->{'ERROR'} = qq!Invalid statement for state "${ state_str }" on line \#${ src_line }: ${ command }!;
        }

    return ($state_ref->{'CURR_STATE'} == &STATE_DEAD)
        ? undef : 1;
}

# process_cmd_note($data_ref, $song_ref, $ibn_row)
sub process_cmd_note
{
    my ($data_ref, $song_ref, $ibn_row) = @_;

    my @tracks = split(/\s*,\s*/, $ibn_row);

    my $count  = scalar(@tracks);
    my $drumsX = (($count == 4) || ($count == 8));
    my $drumsY =  ($count == 8);
    $song_ref->{'CHANNELS'} = max($song_ref->{'CHANNELS'}, ($count - $drumsX - $drumsY));

    my $chn_ref = $song_ref->{'TRACKS'  };
    my $def_ref = $song_ref->{'DEFAULT' };
    my $drm_ref = $song_ref->{'DRUMS'   };

    # Process the first three channels
    foreach my $chn ('A', 'B', 'C')
        {
        my $track_ref   = $chn_ref->{ $chn };
        my $default_ref = $def_ref->{ $chn };
        my $last_ref    = $chn_ref->{ $chn }->[ $#{ $chn_ref->{ $chn } } ];
        my $event       = shift(@tracks);

        push(@{ $track_ref }, get_row_event($event, $last_ref, $default_ref, $song_ref->{'NOTE_LENGTH'}));
        }

    push( @{ $drm_ref->{'X'} }, shift(@tracks) ) if ($drumsX);

    # If we still have tracks, process the next three channels
    if (@tracks)
        {
        foreach my $chn ('D', 'E', 'F')
            {
            my $track_ref   = $chn_ref->{ $chn };
            my $default_ref = $def_ref->{ $chn };
            my $last_ref    = $chn_ref->{ $chn }->[ $#{ $chn_ref->{ $chn } } ];
            my $event       = shift(@tracks);

            push(@{ $track_ref }, get_row_event($event, $last_ref, $default_ref, $song_ref->{'NOTE_LENGTH'}));
            }

        push( @{ $drm_ref->{'Y'} }, shift(@tracks) ) if ($drumsY);
        }

    # Flush all collected labels onto the song stream,
    # pointing them all to the current row.
    while (my $label = pop(@{ $data_ref->{'STATE'}->{'LAST_LABELS'} }))
        {
        $song_ref->{'LABELS'}->{ $label } = $song_ref->{'ROWS'};
        }

    # Count the total number of rows processed
    $song_ref->{'ROWS'}++;

    return 1;   # Proceed with next command
}

# get_row_event($ibn_note, $last_ref, $default_ref, $note_length)
sub get_row_event
{
    my ($ibn_note, $last_ref, $default_ref, $note_length) = @_;

    my $note = $ibn_note;
    my $vol  = 0;
    my $inst = 0;

    # NUL Event - Continue
    if ($ibn_note eq '-')
        {
        $note = 'NUL';
        }

    # NUL Event - Silence
    elsif ($ibn_note eq 'S')
        {
        $note = 'NUL';
        $vol  = ($last_ref) ? $last_ref->{'VOLUME'} : 0;
        }

    # NOTE Event
    elsif ($ibn_note =~ /^([A-G])(\d)(\#?)([WXYZ]?)$/io)
        {
        my $n = $1;
        my $o = $2;
        my $s = $3 || '-';

        $vol = $default_ref->{'VOLUME'};

        if ($4)
            {
            $inst = $INSTRUMENTS{$4};
            $default_ref->{'INSTR'} = $inst;
            }
        else
            {
            $inst = $default_ref->{'INSTR'};
            }

        $note = join('', $n, $s, $o);
        }

    # Invalid Event
    else
        {
        # Just return the event data and leave
        # everything else undefined.
        $vol  = undef;
        $inst = undef;
        }

    # Return the channel event record
    return get_new_event($note, $inst, $vol, $note_length);
}

# detect_optimal_pattern_length($song_ref, $min, $max)
sub detect_optimal_pattern_length
{
    my ($song_ref, $min, $max) = @_;

    my @tracks = (sort keys %{ $song_ref->{'TRACKS'} })[0 .. ($song_ref->{'CHANNELS'} - 1)];

    my $found_min_size = 0;
    my $found_data_ref = undef;

    PAT_LEN: for (my $len = $min; $len <= $max; $len += 2)
        {
        my %patterns = map { $_, [] } @tracks;
        my $chunks   = 0;
        foreach my $chn (sort keys %patterns)
            {
            my @rows      = @{ $song_ref->{'TRACKS'}->{ $chn } };
            my $underflow = (scalar(@rows) % $len);

            # If this channel does not divide equally into chunks
            # of the expected length, we pad it with empty notes.
            if ($underflow)
                {
                my $null_note = get_new_event('NUL', 0, 0, $song_ref->{'NOTE_LENGTH'});
                push(@rows, ( $null_note ) x ($len - $underflow));
                }

            push(@{ $patterns{ $chn } }, [ splice(@rows, 0, $len) ]) while (@rows);

            # Keep track of the number of chunks in which
            # the tracks are split.  It does not matter which
            # track we use, they will all be the same size.
            $chunks = scalar(@{ $patterns{ $chn } });
            }

        my $data_ref = extract_pattern_data($song_ref, \%patterns, $len, $chunks);

        # As we compute the data size of each chunk length,
        # we keep track of the cheapest one.
        if ((!$found_data_ref) || ($data_ref->{'SIZE'} < $found_min_size))
            {
            $found_min_size = $data_ref->{'SIZE'};
            $found_data_ref = $data_ref;
            }

        print "." unless ($len % 16);
        }

    # Return the most optimal structure
    return $found_data_ref;
}

# extract_pattern_data($song_ref, $patt_ref, $patt_length, $chunks)
sub extract_pattern_data
{
    my ($song_ref, $patt_ref, $patt_length, $chunks) = @_;

    my $note_length = $song_ref->{'NOTE_LENGTH'};
    my $repeat      = $song_ref->{'AUTO_REPEAT'};

    my %data = get_new_data_structure($patt_length, $chunks, $note_length);

    CHUNK: for (my $chk_idx = 0; $chk_idx < $chunks; $chk_idx++)
        {
        my @pat_tokens = ();

        TRACK: foreach my $trk (sort keys %{ $patt_ref })
            {
            my @sub_tokens = ();
            ROW: for (my $row_idx = 0; $row_idx < $patt_length; $row_idx++)
                {
                my $event_ref = $patt_ref->{ $trk }->[ $chk_idx ]->[ $row_idx ];
                my $evn_key   = get_event_key($event_ref);

                push(@sub_tokens, $evn_key);
                }

            # Find unique sub-patterns
            my $sub_key = join('!', @sub_tokens);
            unless (exists $data{'UNIQUE'}->{'SUBPATTS'}->{ $sub_key })
                {
                push(@{ $data{'SUBPATTS'} }, $patt_ref->{ $trk }->[ $chk_idx ]);
                $data{'UNIQUE'}->{'SUBPATTS'}->{ $sub_key } = $#{ $data{'SUBPATTS'} };
                }

            push(@pat_tokens, $data{'UNIQUE'}->{'SUBPATTS'}->{ $sub_key });
            }

        # Find unique patterns
        my $pat_key = join('|', @pat_tokens);
        unless (exists $data{'UNIQUE'}->{'PATTERNS'}->{ $pat_key })
            {
            push(@{ $data{'PATTERNS'} }, \@pat_tokens);
            $data{'UNIQUE'}->{'PATTERNS'}->{ $pat_key } = $#{ $data{'PATTERNS'} };
            }

        my $patt_idx = $data{'UNIQUE'}->{'PATTERNS'}->{ $pat_key };

        # Build the song sequence
        push(@{ $data{'SEQUENCE'} }, $patt_idx);

        # Keep track of the labels for each pattern
        my $ibn_row_idx = ($patt_length * $chk_idx);
        my $pat_labels  = get_pattern_labels($song_ref->{'LABELS'}, $ibn_row_idx);

        if (scalar @{ $pat_labels })
            {
            # The labels are mapped to their corresponding pattern index.
            if (exists $data{'PATT_LABELS'}->{ $patt_idx })
                {
                # If this was a duplicate pattern, then add the new labels
                # to the existing ones.
                push(@{ $data{'PATT_LABELS'}->{ $patt_idx } }, @{ $pat_labels })
                }
            else
                {
                # Otherwise, we just add the labels
                $data{'PATT_LABELS'}->{ $patt_idx } = $pat_labels;
                }
            }
        }

    # Determine the sequence terminator
    my $repeat_label = $song_ref->{'REPEAT_LABEL'};
    my $seq_end      = 'TRK_END_SONG';

        # If we have a repeat label (from a "MUSIC JUMP" command),
        # and it points to an existing pattern, then set the song
        # terminator to a backtracking offset pointing to it.
        if (defined $repeat_label)
            {
            my $patt_idx = get_label_pattern($data{'PATT_LABELS'}, $repeat_label);
            if (defined $patt_idx)
                {
                $seq_end = ($patt_idx - scalar(@{ $data{'SEQUENCE'} }));
                }
            }

        # Otherwise, see if we need to repeat the entire song
        elsif ($repeat)
            {
            $seq_end = -( scalar(@{ $data{'SEQUENCE'} }) );
            }

    # Add the sequence terminator
    push(@{ $data{'SEQUENCE'} }, $seq_end);

    # Compute data size
    my $unique_subpats = scalar(keys %{ $data{'UNIQUE'}->{'SUBPATTS'} });
    my $unique_patts   = scalar(keys %{ $data{'UNIQUE'}->{'PATTERNS'} });
    my $seq_length     = scalar(@{ $data{'SEQUENCE'} });

       $data{'SIZE'}   = compute_data_size($patt_length, $unique_subpats, $unique_patts, $seq_length);

    return \%data;
}

# get_new_data_structure($patt_length, $chunks, $note_length)
sub get_new_data_structure
{
    my ($patt_length, $chunks, $note_length) = @_;

    my @null_subpatt = ( (get_new_event('NUL', 0, 0, $note_length)) x $patt_length );

    my @sub_tokens   = map { get_event_key($_) } @null_subpatt;
    my $sub_key      = join('!', @sub_tokens);

    my %data = (
        LENGTH      => $patt_length,
        CHUNKS      => $chunks,
        SIZE        => 0,
        SEQUENCE    => [],
        PATTERNS    => [],
        SUBPATTS    => [ \@null_subpatt ],
        PATT_LABELS => {},
        UNIQUE      =>
            {
            SUBPATTS => { $sub_key => 0 },
            PATTERNS => {}
            }
        );

    return %data;
}

# compute_data_size($patt_length, $unique_subpats, $unique_patts, $seq_length)
sub compute_data_size
{
    my ($patt_length, $unique_subpats, $unique_patts, $seq_length) = @_;

    my $total = 0;
    my %sizes = (
        HDR_SIZE => 4,
        PFX_SIZE => (3 * 4),
        INS_SIZE => (4 * 3),
        ENV_SIZE => (4 * (1 + 16)),
        SUB_SIZE => ($patt_length * (1 + $unique_subpats)),
        SEQ_SIZE => $seq_length,
        PAT_SIZE => (1 + ($unique_patts * $OPTIONS{'CHANNEL_COUNT'})),
        DRM_SIZE => 1
        );

    # Compute total
    foreach my $key (keys %sizes)
        {
        $total += $sizes{ $key };
        }

    return $total;
}

# get_new_event($note, $instrument, $volume, $length)
sub get_new_event
{
    my ($note, $instrument, $volume, $length) = @_;

    my %event = (
        NOTE    => $note,
        INSTR   => $instrument,
        VOLUME  => $volume,
        DELAY   => ($length - 1)
        );

    return \%event;
}

# get_event_data($event_ref)
sub get_event_data
{
    my $event_ref = shift(@_);

    my $note  = $event_ref->{'NOTE'  };
    my $instr = $event_ref->{'INSTR' };
    my $vol   = dec2hex($event_ref->{'VOLUME'}, 1);
    my $delay = dec2hex($event_ref->{'DELAY' }, 1);

    return "\"". $note ." ". $instr . $vol . $delay .'"';
}

# get_event_key($event_ref)
sub get_event_key
{
    my $event_ref = shift(@_);

    return join('|', $event_ref->{'NOTE'}, $event_ref->{'INSTR'}, $event_ref->{'VOLUME'}, $event_ref->{'DELAY'});
}

# get_pattern_key($patt_ref)
sub get_pattern_key
{
    my $patt_ref = shift(@_);

    return join('|', map { $patt_ref->{$_} } (sort keys %{ $patt_ref }));
}

# get_pattern_labels($labels_ref, $patt_idx)
sub get_pattern_labels
{
    my ($labels_ref, $patt_idx) = @_;

    my @pat_labels = ();
    foreach my $label (keys %{ $labels_ref })
        {
        push(@pat_labels, $label)
            if ($labels_ref->{ $label } == $patt_idx);
        }

    return \@pat_labels;
}

# get_label_pattern($labels_ref, $label)
sub get_label_pattern
{
    my ($labels_ref, $label) = @_;

    my $patt_idx = undef;
    IDX: foreach my $idx (keys %{ $labels_ref })
        {
        foreach my $patt_lbl (@{ $labels_ref->{ $idx } })
            {
            if ($patt_lbl eq $label)
                {
                $patt_idx = $idx;
                last IDX;
                }
            }
        }

    return $patt_idx;
}

# get_song_header($fh, $ibn_song_ref, $song_data_ref)
sub get_song_header
{
    my ($fh, $ibn_song_ref, $song_data_ref) = @_;

    my $speed = ($ibn_song_ref->{'SPEED'} / $ibn_song_ref->{'NOTE_LENGTH'});
    my $song_label = trail_string(camelize($ibn_song_ref->{'NAME'}), 11);
    my $song_name  = trail_string($ibn_song_ref->{'NAME'}, 65);

    print $fh <<__END_OF_STRING__;
;; ======================================================================== ;;
;;  SONG: ${ song_name } ;;
;;      This song data was automatically generated from an IBN song by      ;;
;;      the program "ibn2imt.pl".                                           ;;
;; ======================================================================== ;;
${ song_label } PROC

; ------------------------------------------------------------------------- ;
;  Song Header                                                              ;
; ------------------------------------------------------------------------- ;

            DECLE   ${ speed }, \@\@patterns, \@\@instr, \@\@drums

__END_OF_STRING__
}

# get_song_sequence($fh, $ibn_song_ref, $song_data_ref)
sub get_song_sequence
{
    my ($fh, $ibn_song_ref, $song_data_ref) = @_;

    print $fh <<__END_OF_STRING__;
; ------------------------------------------------------------------------- ;
;  Sequence                                                                 ;
; ------------------------------------------------------------------------- ;
__END_OF_STRING__

    my @seq     = @{ $song_data_ref->{'SEQUENCE'} };
    my @chunks  = ();
    push(@chunks, [ splice(@seq, 0, 10) ]) while (@seq);

    foreach my $chnk (@chunks)
        {
        my @patts = map { pad_string($_, 3) } @{ $chnk };
        print $fh "            DECLE   ", join(', ', @patts), "\n";
        }

    print $fh "\n";
}

# get_song_patterns($fh, $ibn_song_ref, $song_data_ref)
sub get_song_patterns
{
    my ($fh, $ibn_song_ref, $song_data_ref) = @_;

    print $fh <<__END_OF_STRING__;
; ------------------------------------------------------------------------- ;
;  Channel Patterns                                                         ;
; ------------------------------------------------------------------------- ;
\@\@patterns:
__END_OF_STRING__

    my $length   = pad_string(($song_data_ref->{'LENGTH'} * $ibn_song_ref->{'NOTE_LENGTH'}), 3);
    my $patt_idx = 0;
    foreach my $pattern (@{ $song_data_ref->{'PATTERNS'} })
        {
        # Expand or contract the list of pattern tracks
        # depending on the configured channel count.
        my $diff = ($OPTIONS{'CHANNEL_COUNT'} - scalar(@{ $pattern }));

        # Do we have require more channels?
        #   Pad the tracks list.
        if ($diff > 0)
            {
            push(@{ $pattern }, (0) x $diff);
            }

        # Do we require less channels?
        #   Truncate the tracks list.
        elsif ($diff < 0)
            {
            splice(@{ $pattern }, 0, $OPTIONS{'CHANNEL_COUNT'});
            }

        my $labels = (exists $song_data_ref->{'PATT_LABELS'}->{ $patt_idx })
                   ? ':  ' . join(', ', @{ $song_data_ref->{'PATT_LABELS'}->{ $patt_idx } })
                   : '';

        # Compose the actual pattern record
        my @tracks = ();
        foreach my $subpatt_idx (@{ $pattern })
            {
            push(@tracks, '@@p' . pad_number($subpatt_idx, 3));
            }

        print $fh '            DECLE   ', join(', ', $length, @tracks), "  ; #", pad_number($patt_idx++, 2), $labels, "\n";
        }

    print $fh "\n";
}

# get_song_instruments($fh, $ibn_song_ref, $song_data_ref)
sub get_song_instruments
{
    my ($fh, $ibn_song_ref, $song_data_ref) = @_;

    # Note:
    #   The envelopes & pitch effects are approximations
    #   to the what IntyBASIC does.  The sounds of IntyBASIC
    #   cannot be perfectly match because of differences
    #   in the way the sounds are synthesized.
    print $fh <<__END_OF_STRING__;
; ------------------------------------------------------------------------- ;
;  Pitch Effects                                                            ;
; ------------------------------------------------------------------------- ;
\@\@pfxNone:  DECLE    0,  0,  0,  0              ; None: No effect
\@\@pfxWind:  DECLE   12, 12, 12, 12              ; Wind: 1 octave higher
\@\@pfxBass:  DECLE  -24,-24,-24,-24              ; Bass: 2 octaves lower

; ------------------------------------------------------------------------- ;
;  Envelopes                                                                ;
; ------------------------------------------------------------------------- ;
__END_OF_STRING__

    print $fh <<__END_OF_STRING__;
            ; W: Piano
\@\@env_W:    DECLE   4
            DECLE   \$EDDC, \$CBBA, \$A998, \$8776
            DECLE   \$6677, \$6655, \$6677, \$6655
            DECLE   \$6677, \$6655, \$6677, \$6655
            DECLE   \$6677, \$6655, \$6677, \$6655

            ; X: Clarinet
\@\@env_X:    DECLE   4
            DECLE   \$DEED, \$DCCC, \$BBBB, \$CCCC
            DECLE   \$BBBB, \$CCCC, \$BBBB, \$CCCC
            DECLE   \$BBBB, \$CCCC, \$BBBB, \$CCCC
            DECLE   \$BBBB, \$CCCC, \$BBBB, \$CCCC

            ; Y: Flute
\@\@env_Y:    DECLE   4
            DECLE   \$ACDD, \$CCCC, \$BBBB, \$AAAA
            DECLE   \$BBBB, \$AAAA, \$BBBB, \$AAAA
            DECLE   \$BBBB, \$AAAA, \$BBBB, \$AAAA
            DECLE   \$BBBB, \$AAAA, \$BBBB, \$AAAA

            ; Z: Bass
\@\@env_Z:    DECLE   4
            DECLE   \$CDEE, \$DCCC, \$BBCC, \$BBCC
            DECLE   \$BBCC, \$BBCC, \$BBCC, \$BBCC
            DECLE   \$BBCC, \$BBCC, \$BBCC, \$BBCC
            DECLE   \$BBCC, \$BBCC, \$BBCC, \$BBCC

; ------------------------------------------------------------------------- ;
;  Instruments                                                              ;
; ------------------------------------------------------------------------- ;
\@\@instr:    DECLE   \@\@pfxNone,  0,  \@\@env_W     ; #1: Piano
            DECLE   \@\@pfxWind,  2,  \@\@env_X     ; #2: Clarinet
            DECLE   \@\@pfxNone,  1,  \@\@env_Y     ; #3: Flute
            DECLE   \@\@pfxBass,  0,  \@\@env_Z     ; #4: Bass

__END_OF_STRING__
}

# get_song_drums($fh, $ibn_song_ref, $song_data_ref)
sub get_song_drums
{
    my ($fh, $ibn_song_ref, $song_data_ref) = @_;

    print $fh <<__END_OF_STRING__;
; ------------------------------------------------------------------------- ;
;  Instruments                                                              ;
; ------------------------------------------------------------------------- ;
\@\@drums:    DECLE   0

__END_OF_STRING__
}

# get_song_subpatterns($fh, $ibn_song_ref, $song_data_ref)
sub get_song_subpatterns
{
    my ($fh, $ibn_song_ref, $song_data_ref) = @_;

    print $fh <<__END_OF_STRING__;
; ------------------------------------------------------------------------- ;
;  Sub-Patterns                                                             ;
; ------------------------------------------------------------------------- ;
__END_OF_STRING__

    my $idx = 0;
    my $length = ($song_data_ref->{'LENGTH'} * $ibn_song_ref->{'NOTE_LENGTH'});
    PATTERN: foreach my $pattern (@{ $song_data_ref->{'SUBPATTS'} })
        {
        print $fh '@@p', pad_number($idx++, 3), ': NPK.Begin(', $length, ")\n";
        ROW: foreach my $row (@{ $pattern })
            {
            print $fh '            NPK.Note(', get_event_data($row), ")\n";
            }

        print $fh "        NPK.End\n\n";
        }
}

# get_song_footer($fh, $ibn_song_ref, $song_data_ref)
sub get_song_footer
{
    my ($fh, $ibn_song_ref, $song_data_ref) = @_;

    my $filename = trail_string(qq|"$OPTIONS{'OUTPUT_FILE'}"|, 66);
    print $fh <<__END_OF_STRING__;
        ENDP
;; ======================================================================== ;;
;;  EOF: ${ filename } ;;
;; ======================================================================== ;;
__END_OF_STRING__
}

# max($a, $b)
sub max
{
    my ($a, $b) = @_;

    return (($a || 0) > ($b || 0)) ? $a : $b;
}

# pad_number($val, $len)
sub pad_number
{
    my ($val, $len) = @_;

    return pad_string($val, $len, '0');
}

# pad_string($str, $len, $prefix)
sub pad_string
{
    my $str    = shift(@_);
    my $len    = shift(@_);
    my $prefix = (@_) ? shift(@_) : ' ';

    my $strlen = length($str);
    if ($strlen < $len)
        {
        $str = $prefix x ($len - $strlen) . $str;
        }

    return $str;
}

# trail_string($str, $len, $suffix)
sub trail_string
{
    my $str    = shift(@_);
    my $len    = shift(@_);
    my $suffix = (@_) ? shift(@_) : ' ';

    my $strlen = length($str) || 0;
    if ($strlen < $len)
        {
        $str .= $suffix x ($len - $strlen);
        }

    return $str;
}

# camelize($str)
sub camelize
{
    my $str = shift(@_);

    if ($str)
        {
        $str =~ s{(\w+)}{
            ($a = lc $1) =~ s<(^[a-z]|_[a-z])><
                ($b = uc $1) =~ s/^_//;
                $b;
            >eg;
            $a;
        }eg;

        # Remove word delimiters
        $str =~ s/[^a-zA-Z0-9]//g;
        }

    return $str;
}

# dec2hex($val)
sub dec2hex
{
    my $val   = shift(@_);
    my $width = shift(@_) || 2;

    return sprintf("%0${ width }X", $val);
}

# commify($text)
sub commify
{
    my $text = reverse shift(@_);

    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}


# get_arg_channels($opt_name, $opt_value)
sub get_arg_channels
{
    my ($opt_name, $opt_value) = @_;

    if (($opt_value == 3) || ($opt_value == 6))
        {
        $OPTIONS{'CHANNEL_COUNT'} = $opt_value;
        }
    else
        {
        die("\nERROR: Invalid channel value '${ opt_value }'.  Must be either '3' or '6'.\n\n")
        }
}

# export_manual($opts_ref)
sub export_manual
{
    my $opts_ref = shift(@_);

    my $man_out = $opts_ref->{'PROG_NAME'} . '-manual.txt';

    my $fh = FileHandle->new();
    open($fh, "> ${ man_out }") or die("Unable to open manual export file '${ man_out }': $!\n");

        print "User manual exported as \'${ man_out }\'\n";
        pod2usage(-verbose => 2, -output => $fh);

    close($fh);
}

__END__

=head1 NAME

ibn2imt.pl - Translates an IBN music file into Intellivision Music Tracker format.

=head1 SYNOPSIS

ibn2imt.pl [options] [B<source>] [-o [B<output>]]

 Options:
    -h  --help              Brief help message
    -m  --manual            Full user manual documentation
    -c  --channels          Number of channels to output (3 or 6)
    -n  --note-len          Note length, in rows (defaults to 1)
    -o  --out               Output filename
    -p  --pat-len           Pattern length, in rows (defaults to auto-select)
    -r  --repeat            Enable automatic repeat at end of song
    -x  --export-man        Export user manual

 Arguments:
    source                  IBN source filename (required)
    output                  IMT output filename (optional)

=head1 OPTIONS

=over 4

=item B<-h>  B<--help>

Prints a brief help message on usage and exits.

=item B<-m>  B<--manual>

Prints the full user manual page and exits.

=item B<-c>  B<--channels>

The number of channels to output, 3 or 6.  This value must coincide with the tracker configuration
that you plan to use.

=item B<-n>  B<--note-len>

The length of notes to apply, in rows.  All notes read from the B<IBN> source will be translated into
tracker events of the given note length.  The default is each note takes one row.

=item B<-o>  B<--out>

The name of the output file.  If not provided, the default is the source name with an C<asm> extension.

=item B<-p>  B<--pat-len>

The length of patterns, in rows.  The source B<IBN> song stream will be split into patterns of the
given length.  If no length is provided, the default is to attempt to determine the most optimal
length.

=item B<-r>  B<--repeat>

Indicates whether the song sequence should end with an automatic repeat indicator.  The default is
to follow the B<IBN> closing command (C<B<MUSIC STOP>> or C<B<MUSIC REPEAT>>).

Note that this option only changes the default behaviour when encountering a closing command.  If the
song ends with a C<B<MUSIC JUMP>> command pointing to a previous section, it will take precedence.

=item B<-x>  B<--export-man>

Exports the full user manual page as a text file and exits.

=back

=head1 ARGUMENTS

=over 4

=item B<source>

The filename of the B<IBN> source to translate.  This argument is required.

=item B<output>

The filename of the translated B<IMT> output.  This argument is optional.  If not provided
B<C<ibn2imt.pl>> will use the B<source> filename with an C<asm> extension.

=back

=head1 DESCRIPTION

B<This program> will translate a music module composed in IntyBASIC Notation (B<IBN>), into the data
format used by the Intellivision Music Tracker (B<IMT>).  The result is an assembly source file
with the original song represented in the target format.

The output file includes instrument definitions that attempt to reproduce the IntyBASIC sounds.

By default, the program will produce output to support 6 channels, following the default configuration
of the Intellivision Music Tracker.  It will also try to determine automatically the most optimal
length of patterns to use, removing duplicate patterns across all channels.

The default behaviour can be altered with command line options.

=head2 How It Works

The crucial problem that B<C<ibn2imt.pl>> attempts to address is how to identify patterns, and how to
determine an optimal pattern length in which to split the song data.  The solution it employs is
actually to apply I<brute-force>.

First, the program scans the original BASIC source file and identifies all the labels and music
player commands, extracting a stream of note events (the I<song stream>) and splitting them into
I<channels>.  Any music subroutines encountered via the command C<B<MUSIC GOSUB>> are "unrolled"
and included I<inline> as part of the song stream.

Throughout this entire pre-processing step, the volume and active instrument of each channel
are tracked.

Then, operating on each extracted channel in turn, the program splits the song stream into patterns
of various row lengths, starting at 4 and increasing the length by two, all the way to 256.  At each
split, it attempts to deduplicate re-occurring patterns across all channels, and computes an estimate
of the size of the data needed to reproduce it.

At the end, the program compares the relative sizes of the data at each split length, and chooses
the smallest one.  This is assumed to be the optimal length with a balance between rows and data size.

If a specific pattern length is given in the command line, the automatic detection is short-circuited,
and patterns are split accordingly.

The selected pattern split is then rendered in the Intellivision Music Tracker (B<IMT>) format by
emitting the sequence of reused patterns, the channel patterns, and their individual event sub-patterns.

All labels in the original source are tracked throughout processing and pattern extraction.  When
emitting output, any patterns corresponding to a labeled section will include a comment for reference.

=head2 Caveats

=over 4

=item * You must ensure that the source file contains I<only> song statements in valid IntyBASIC Music Notation
(B<IBN>), or else you may not get the results that you expect.

=item * Variable song speed is not supported by the Intellivision Music Tracker.  Therefore, the
C<B<MUSIC SPEED>> command simply overwrites the last known speed.  Subsequent speed changes trump
all previous ones, so that the last one encountered sets the final speed of the entire song.

=item * B<The program> works best when the original song is naturally organized into repeating groups
of notes, or musical passages, of the same length.  If the source song starts with, say a couple of
notes at the end of a measure, you should pad it with silence so that it conforms to the same length
as the rest of the measures in the song.  Otherwise, the pattern-splitting process will not identify
patterns properly.

=item * Because the implementation of the Intellivision Music Tracker synthesizer is different from that
of the IntyBASIC music player, the instrument sounds will only be approximations.  Specifically, the
more intricate I<vibrato> effect applied to the B<flute> and B<clarinet> instruments in IntyBASIC,
is implemented as a simple I<S<LFO modulation>> in the tracker.

=item * The commands C<B<MUSIC STOP>> and C<B<MUSIC REPEAT>> are interpreted as the end of the song.
Therefore, any subsequent statements will be ignored unless referenced in some other way.

=item * You should take care to ensure that control-flow commands such as C<B<MUSIC JUMP>> and
C<B<MUSIC GOSUB>> follow a coherent and logical flow.  Chaotic jumping around in your song may not
translate correctly into an Intellivision Music Tracker (B<IMT>) pattern sequence.

=item * Contrary to IntyBASIC, B<C<ibn2imt.pl>> treats subsequent C<B<MUSIC GOSUB>> commands as nested
subroutine calls.  This shouldn't be a problem under normal circumstances.  However, you must be
exceptionaly careful when exiting a subroutine prematurely via a C<B<MUSIC JUMP>> command, since it
may result in unbalanced C<B<GOSUB/RETURN>> pairs.

=item * Because pattern extraction occurs independently of label positioning, there is a chance
that labels will not line up with the start of a pattern.  Consequently, determining the
I<backtracking> offset from the target of a C<B<MUSIC JUMP>> command may fail.  In such event,
B<the program> will default to an I<end-of-song> marker.

=back

=head2 Known Issues & Limitations

=over 4

=item * Error checking is superficial at best.  A valid and coherent IntyBASIC Notation (B<IBN>) file
is expected, so be careful that your song data is correct.

=item * Drum arguments are read and extracted, but completely ignored during processing.

=item * The control-flow command C<B<MUSIC JUMP>> is treated in a special way:

=over 4

=item * If it points forward into the song stream, it will skip all notes until that point.

=item * If it points backwards to a previously encountered label, it will signal the end of the
song and set the target as the repeat offset for I<backtracking> at the end of the sequence.

=item * If a target pattern cannot be determined for some reason, it will default to the
I<end-of-song> marker.

=back

In all cases, any notes following the command will be ignored, unless referenced in some other
way.

=item * The performance command C<B<MUSIC SPEED>> will override the actual speed of the entire song,
not just of the following sections.

=back

=head1 AUTHOR

"IBN-to-IMT" (B<C<ibn2imt.pl>>) was designed and developed by James Pujals, a.k.a. I<DZ-Jay>.  If you have any
feedback, good or bad (hopefully good), you can contact James at B<E<lt>dz-game@techunlimited.netE<gt>>.

=head1 ACKNOWLEDGEMENTS

This program would not have I<any reason> to exist if it were not for the fabulous work by Arnauld
Chevallier and E<Oacute>scar Toledo, respective authors of the original Intellivision Music Tracker
and IntyBASIC.

Their gracious generosity in sharing their hard work with the community is what inspired me to do the
same, with the hope of enriching the musical canon of our favorite gaming console.

So, if you ever get a chance to meet Arnauld or E<Oacute>scar in person, buy them a beer or three.

=head1 SUPPORT

For support inquiries, bug reports, or feature requests, your best bet is to post a comment in one
of the typical fora where Intellivision programmers hang out, such as:

=over 4

=item B<IntvPROG Mailing List>

URL: L<https://groups.io/g/intvprog>

E-mail: L<intvprog@groups.io>

=item B<Atari Age Intellivision Programming Forum>

URL: https://atariage.com/forums/forum/144-intellivision-programming/

=back

If all else fails and you can't get the help you need, you can always contact the author directly.
He's cool. :)

=head1 EXAMPLES

=over 4

=item B<ibn2imt.pl -h>

Produces a brief description of usage.

=item B<ibn2imt.pl -m>

Produces the full usage manual page.

=item B<ibn2imt.pl mysong.bas>

Translates source file C<B<mysong.bas>>, automatically detecting the optimal pattern length, and
renders the output as six channels in file C<B<mysong.asm>>.

=item B<ibn2imt.pl -p 32 ibn_song.bas -o imt_song.asm>

Translates source file C<B<ibn_song.bas>> using a pattern length of 32 rows, and renders the output
as six channels in file C<B<imt_song.asm>>.

=item B<ibn2imt.pl -c 3 -p 16 mysong.bas>

Translates source file C<B<mysong.bas>> using a pattern length of 16 rows, and renders the output
as three channels in file C<B<mysong.asm>>.

=cut
