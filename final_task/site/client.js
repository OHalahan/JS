function makeAjax(destination) {
    var xhr = new XMLHttpRequest();
    // Destination
    xhr.open('POST', '/api/' + destination);
    // Content will be in JSON format, utf-8 charset
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    return xhr;
}

//should be called with a callback function to synchronise output
function callBooks(callback) {
    var request = makeAjax('get_books');
    request.send();
    request.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            //console.log(this.response); // See console to see response
            var response = JSON.parse(this.response || "{}");
            if (response.success) {
                callback(response["books"]);
            }
        }
    }
}

//called via callbacks and fills the table based on the provided array of "books"
function createTableBody(books) {
    var tableBody = document.getElementById("booksTable");
    while (tableBody.firstChild) {
        tableBody.removeChild(tableBody.firstChild);
    }
    var options = new Array("id", "title", "author", "section", "shelf", "taken");
    console.log(books);
    //TABLE ROWS
    for (i = 0; i < books.length; i++) {
        var tr = document.createElement('TR');
        //var book = new Array(ids[i], books[ids[i]]["title"], books[ids[i]]["author"], books[ids[i]]["section"], books[ids[i]]["shelf"], books[ids[i]]["taken"]);
        for (j = 0; j < options.length; j++) {
            var td = document.createElement('TD');
            td.appendChild(document.createTextNode(books[i][options[j]]));
            tr.appendChild(td);
        }
        tableBody.appendChild(tr);
    }
}

function saveDb() {
    var request = makeAjax('save_db');
    request.send();
    request.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            console.log(this.response); // See console to see response
            var response = JSON.parse(this.response || "{}");

            if (response.success) {
                return response.success;
            }
        }
    }
}






/*
function getServerLocalTime() {
    var xhr = new XMLHttpRequest();

    // Pay attention, that our server knows how to work with such destination
    // This is good practice
    xhr.open('POST', '/api/get_server_localtime');

    // Content will be in JSON format, utf-8 charset
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");

    xhr.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            console.log(this.response); // See console to see response

            var response = JSON.parse(this.response || "{}");

            // Our internal checks. Maybe some backend task has been failed and response data is wrong
            if (response.success && response.localtime) {
                document.getElementById('localtime').value = response.localtime;
            }
        }
    }

    xhr.send(JSON.stringify({call: 'new'}));
}

function onFormSubmit(form) {
    var owner = form.owner.value || '',
        sn = form.sn.value || '';

    makeAjaxCall({
        owner: owner,
        serialNumber: sn,
        method: 'get_owner_info' // We will send this method as argument, however it's bad practice
    });

    alert('See browser console -> network to see the request');
}
*/
