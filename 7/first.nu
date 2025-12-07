def main [input: string] {
    let lines = open -r $input | lines;
    
    let start_idx = $lines | first | str index-of 'S';

    let total = $lines | slice 1.. | reduce --fold { nb_split: 0, beam_indexes: [$start_idx]} {|line, acc_lines|
        let new_indexes = $acc_lines.beam_indexes
        | reduce --fold {nb_split: 0, beam_indexes: []} {|idx, acc|
            if ($line | split chars | get $idx) == '^' {
                {
                    beam_indexes: ($acc.beam_indexes | append [($idx - 1), ($idx + 1)]),
                    nb_split: ($acc.nb_split + 1)
                }
            } else {
                {
                    beam_indexes: ($acc.beam_indexes | append [$idx]),
                    nb_split: $acc.nb_split
                }
            }
        };

        {
            beam_indexes: ($new_indexes.beam_indexes | uniq),
            nb_split: ($new_indexes.nb_split + $acc_lines.nb_split) 
        }

    };

    $total.nb_split
}
