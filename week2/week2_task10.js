document.getElementById("sortingBtn").addEventListener("click", callSorting);

function callSorting(){
    var orderBy = document.getElementById("orderBy").value;
    sortObj(orderBy);
}

function sortObj(strategy) {

    function sortByStrategy(x,y) {
        if ( x[strategy] < y[strategy] ) {
            return -1;
        }
        if ( x[strategy] > y[strategy] ) {
            return 1;
        }
        else {
            return 0;
        }
    }

    document.getElementById("out10").innerHTML = list( library.sort(sortByStrategy) );

}
