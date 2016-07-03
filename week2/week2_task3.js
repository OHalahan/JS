function randImg() {
    function createImg(src, width, height) {
        this.src = src;
        this.width = width;
        this.height = height;
    }
    var first = new createImg( "http://farm4.staticflickr.com/3691/11268502654_f28f05966c_m.jpg", 240, 160 );
    var second = new createImg( "http://farm1.staticflickr.com/33/45336904_1aef569b30_n.jpg", 320, 195 );
    var third = new createImg( "http://farm6.staticflickr.com/5211/5384592886_80a512e2c9.jpg", 500, 343 );

    var obj = [first, second, third];

    


}
