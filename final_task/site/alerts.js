function goodNewsAdd() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-success";
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '<strong>Success!</strong> Book was succesfully added.';

    target.appendChild(myDiv);

    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function badNewsAdd() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-danger";
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '<strong>Fail!</strong> Failed to add book.';

    target.appendChild(myDiv);
    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function goodNewsDelete() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-success";
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '<strong>Success!</strong> Books were succesfully deleted.';

    target.appendChild(myDiv);

    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function badNewsDelete() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-danger";
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '<strong>Fail!</strong> Failed to delete book(s).';

    target.appendChild(myDiv);
    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function goodNewsSave() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-success";
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '<strong>Success!</strong> Books were succesfully Saved.';

    target.appendChild(myDiv);

    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}

function badNewsSave() {
    var target = document.getElementById("alerts");

    var myDiv = document.createElement("DIV");
    myDiv.className = "alert alert-danger";
    myDiv.innerHTML += '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>';
    myDiv.innerHTML += '<strong>Fail!</strong> Failed to save books.';

    target.appendChild(myDiv);
    setTimeout(function() {
        myDiv.parentNode.removeChild(myDiv);
    }, 4000);

}
