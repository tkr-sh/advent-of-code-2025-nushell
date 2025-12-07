def main [input: string] {
    let lines = open -r $input | lines;
    
    let start_idx = $lines | first | str index-of 'S';

    let total = $lines | slice 1.. | reduce --fold { beams: [{ index: $start_idx, possibility: 1}]} {|line, acc_lines|
        let new_indexes = $acc_lines.beams
        | reduce --fold {beams: []} {|beam, acc|
            let idx = $beam.index | into int;
            if ($line | split chars | get $idx) == '^' {
                let possibility_minus = $acc.beams | where index == ($idx - 1) | get 0 --optional | default { index: ($idx - 1), possibility: 0};
                let possibility_plus = $acc.beams | where index == ($idx + 1) | get 0 --optional | default { index: ($idx + 1), possibility: 0};
                {
                    beams: ($acc.beams | where index != ($idx - 1) and index != ($idx + 1) | append [
                        ($possibility_minus | update possibility {$in + $beam.possibility}),
                        ($possibility_plus | update possibility {$in + $beam.possibility})
                    ]),
                }
            } else {
                let current = $acc.beams | where index == ($idx) | get 0 --optional | default { index: $idx, possibility: 0};
                {
                    beams: ($acc.beams | where index != $idx | append [
                        ($current | update possibility {$in + $beam.possibility})
                    ]),
                }
            }
        };

        {
            beams: ($new_indexes.beams),
        }

    };

    $total.beams | each { $in.possibility } | math sum
}
