document.getElementById("generate").addEventListener("click", genCombinations);

function genCombinations() {
    var string = document.getElementById("string").value;
    function recursive_call( active, rest, arr ) {
        if ( !active && !rest )
            return undefined;
        if (!rest) {
            arr.push(active);
        }
        else {
            recursive_call( active + rest[0], rest.slice(1), arr );
            recursive_call( active, rest.slice(1), arr );
        }
        return arr;
    }
    document.getElementById("out5").innerHTML = recursive_call( "", string, [] );
}
