function makeAjax(destination) {
    var xhr = new XMLHttpRequest();
    // Destination
    xhr.open('POST', '/api/' + destination);
    // Content will be in JSON format, utf-8 charset
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    return xhr;
}

function isDb() {
    var request = makeAjax('is_db');
    request.send();
    request.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            console.log(this.response); // See console to see response
            var response = JSON.parse(this.response || "{}");
            // Our internal checks. Maybe some backend task has been failed and response data is wrong
            if (response.success) {
                console.log(response.success);
            }
        }
    }
}

function isDb() {
    var request = makeAjax('is_db');
    request.send();
    request.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            console.log(this.response); // See console to see response
            var response = JSON.parse(this.response || "{}");
            // Our internal checks. Maybe some backend task has been failed and response data is wrong
            if (response.success) {
                console.log(response.success);
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
