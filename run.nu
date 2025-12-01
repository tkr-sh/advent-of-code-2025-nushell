def main [n: int, is_first: bool, is_example: bool] {
    let nu_name = $"($n)/(if $is_first { "first" } else { "second" }).nu";

    nu $nu_name $"($n)/(if $is_example { 'example' } else { 'final' }).txt"
}
