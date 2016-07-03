function getValues() {
    return [ document.getElementById("first").value, document.getElementById("second").value ];
}

function multiply() {
    var numbers = getValues();
    document.getElementById("out3").innerHTML = ( numbers[0] * numbers[1] );
}

function divide() {
    var numbers = getValues();
    if ( numbers[1] == 0 ) {
        document.getElementById("out3").innerHTML = "Cannot divide by zero";
    }
    else {
        document.getElementById("out3").innerHTML = ( numbers[0] / numbers[1] );
    }
}
