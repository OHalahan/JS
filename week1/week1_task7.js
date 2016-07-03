document.getElementById("vowels").addEventListener("click", vCount);

function vCount() {
    var string = document.getElementById("vString").value.toLowerCase();
    var vList = 'aeiou';
    var count = 0;

    for ( var i = 0; i < string.length; i++ ) {
        if ( vList.indexOf(string[i]) !== -1 ) {
            count++;
        }
    }
    document.getElementById("out7").innerHTML = count;
}
